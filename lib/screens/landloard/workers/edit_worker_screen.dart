import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/providers/landlord/worker_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

final colors = AppThemeColors();

class EditWorkerScreen extends StatefulWidget {
  final dynamic worker;

  const EditWorkerScreen({super.key, required this.worker});

  @override
  State<EditWorkerScreen> createState() => _EditWorkerScreenState();
}

class _EditWorkerScreenState extends State<EditWorkerScreen> {
  final _formKey = GlobalKey<FormState>();

  // ===== LISTS =====
  final List<String> workerTypes = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Cleaner',
    'Painter',
    'General Maintenance',
    'AC Repair',
    'Appliance Repair',
    'Pest Control',
    'Other',
  ];

  final List<String> specializations = [
    "Pipe fitting",
    "Leak repair",
    "Electrical wiring",
    "AC repair",
    "Painting",
  ];

  final List<String> workingDays = [
    "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
  ];

  // ===== CONTROLLERS =====
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final expYearsCtrl = TextEditingController();
  final expDescCtrl = TextEditingController();
  final emergencyNameCtrl = TextEditingController();
  final emergencyPhoneCtrl = TextEditingController();

  String selectedWorkerType = "Plumber";
  String emergencyRelation = "Brother";
  String availabilityStatus = "Available";

  TimeOfDay fromTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay toTime = const TimeOfDay(hour: 18, minute: 0);

  bool fullAccess = false;

  final Set<String> selectedSpecs = {};
  final Set<String> selectedDays = {};

  @override
  void initState() {
    super.initState();
    _fillData();
  }

  void _fillData() {
    final w = widget.worker;

    nameCtrl.text = w['name'] ?? '';
    phoneCtrl.text = w['phone'] ?? '';
    emailCtrl.text = w['email'] ?? '';
    selectedWorkerType = w['workerType'] ?? "Plumber";

    expYearsCtrl.text = "${w['experience']?['years'] ?? 0}";
    expDescCtrl.text = w['experience']?['description'] ?? "";

    emergencyNameCtrl.text = w['emergencyContact']?['name'] ?? "";
    emergencyPhoneCtrl.text = w['emergencyContact']?['phone'] ?? "";
    emergencyRelation = w['emergencyContact']?['relation'] ?? "Brother";

    availabilityStatus = w['availability']?['status'] ?? "Available";

    final wh = w['availability']?['workingHours'];
    if (wh != null) {
      fromTime = _parseTime(wh['from']);
      toTime = _parseTime(wh['to']);
    }

    selectedSpecs.addAll(List<String>.from(w['specialization'] ?? []));
    selectedDays.addAll(List<String>.from(w['availability']?['workingDays'] ?? []));

    fullAccess = w['hasFullPropertyAccess'] ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WorkerProvider>();
      provider.clearProperties();

      for (final p in (w['assignedProperties'] ?? [])) {
        provider.toggleProperty(p['_id'].toString());
      }

      provider.fetchMyProperties();
    });
  }

  TimeOfDay _parseTime(String t) {
    final parts = t.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<WorkerProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: CommonWidget.gradientAppBar(
        title: "Edit Worker",
        onPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section("Identity & Role"),
            _card([
              _text(nameCtrl, "Full Name", Icons.person_outline),
              _text(phoneCtrl, "Phone Number", Icons.phone_android, number: true),
              _text(emailCtrl, "Email (Optional)", Icons.email, required: false),
              _dropdown("Worker Category", selectedWorkerType, workerTypes,
                  Icons.engineering, (v) => setState(() => selectedWorkerType = v)),
            ]),

            _section("Property Allocation"),
            _card([
              _propertySelector(p),
              SwitchListTile(
                title: const Text("Full Property Access"),
                value: fullAccess,
                onChanged: (v) {
                  setState(() => fullAccess = v);
                  if (v) context.read<WorkerProvider>().clearProperties();
                },
              ),
            ]),

            _section("Specialization"),
            _card([_chipGroup(specializations, selectedSpecs)]),

            _section("Experience"),
            _card([
              _text(expYearsCtrl, "Experience (Years)", Icons.history, number: true),
              _text(expDescCtrl, "Description", Icons.description, required: false),
            ]),

            _section("Availability"),
            _card([
              _dropdown("Status", availabilityStatus, ["Available", "Unavailable"],
                  Icons.event_available, (v) => setState(() => availabilityStatus = v)),
              _timeRow(),
              _chipGroup(workingDays, selectedDays),
            ]),

            _section("Emergency Contact"),
            _card([
              _text(emergencyNameCtrl, "Name", Icons.person),
              _text(emergencyPhoneCtrl, "Phone", Icons.phone, number: true),
              _dropdown("Relation", emergencyRelation,
                  ["Father", "Brother", "Spouse", "Friend", "Other"],
                  Icons.people, (v) => setState(() => emergencyRelation = v)),
            ]),

            const SizedBox(height: 30),

            PrimaryButton(
              title: p.creating ? "Updating..." : "UPDATE WORKER",
              onPressed: p.creating ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  // ================= SUBMIT =================
  Future<void> _submit() async {
    debugPrint("🟢 EDIT WORKER SUBMIT STARTED");

    if (!_formKey.currentState!.validate()) {
      debugPrint("❌ FORM VALIDATION FAILED");
      return;
    }
    debugPrint("✅ FORM VALIDATED");

    final provider = context.read<WorkerProvider>();

    final payload = {
      "name": nameCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "workerType": selectedWorkerType,
      "specialization": selectedSpecs.toList(),
      "experience": {
        "years": int.tryParse(expYearsCtrl.text) ?? 0,
        "description": expDescCtrl.text.trim(),
      },
      "assignedProperties":
      fullAccess ? [] : provider.selectedPropertyIds.toList(),
      "hasFullPropertyAccess": fullAccess,
      "availability": {
        "status": availabilityStatus,
        "workingDays": selectedDays.toList(),
        "workingHours": {
          "from": fromTime.format(context),
          "to": toTime.format(context),
        },
      },
      "emergencyContact": {
        "name": emergencyNameCtrl.text.trim(),
        "phone": emergencyPhoneCtrl.text.trim(),
        "relation": emergencyRelation,
      },
    };

    debugPrint("📦 EDIT WORKER PAYLOAD:");
    payload.forEach((key, value) {
      debugPrint("➡️ $key : $value");
    });

    debugPrint("🚀 CALLING UPDATE WORKER API");
    debugPrint("🆔 Worker ID: ${widget.worker['_id']}");

    final success = await provider.updateWorker(
      workerId: widget.worker['_id'],
      payload: payload,
    );

    debugPrint("⬅️ UPDATE WORKER RESPONSE: success = $success");

    if (success && mounted) {
      debugPrint("🎉 WORKER UPDATED — POPPING SCREEN");
      Navigator.pop(context, true);
    } else {
      debugPrint("❌ WORKER UPDATE FAILED");
    }

    debugPrint("🟢 EDIT WORKER SUBMIT FINISHED");
  }
  // ================= UI HELPERS =================

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Text(t.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold, color: colors.primary)),
  );

  Widget _card(List<Widget> c) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: colors.containerWhite,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: c),
  );

  Widget _text(TextEditingController c, String l, IconData i,
      {bool number = false, bool required = true}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: c,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          validator: required ? (v) => v!.isEmpty ? "Required" : null : null,
          decoration: InputDecoration(prefixIcon: Icon(i), labelText: l),
        ),
      );

  Widget _dropdown(String l, String v, List<String> items, IconData i,
      Function(String) onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: DropdownButtonFormField(
          value: v,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (x) => onChanged(x as String),
          decoration: InputDecoration(prefixIcon: Icon(i), labelText: l),
        ),
      );

  Widget _chipGroup(List<String> items, Set<String> selected) => Wrap(
    spacing: 8,
    children: items.map((s) {
      final isSel = selected.contains(s);
      return FilterChip(
        label: Text(s),
        selected: isSel,
        selectedColor: colors.primary,
        onSelected: (v) =>
            setState(() => v ? selected.add(s) : selected.remove(s)),
      );
    }).toList(),
  );

  Widget _timeRow() => Row(
    children: [
      Expanded(child: _time("From", fromTime, (t) => setState(() => fromTime = t))),
      const SizedBox(width: 12),
      Expanded(child: _time("To", toTime, (t) => setState(() => toTime = t))),
    ],
  );

  Widget _time(String l, TimeOfDay t, Function(TimeOfDay) onPick) => ListTile(
    title: Text(l),
    trailing: Text(t.format(context)),
    onTap: () async {
      final picked = await showTimePicker(context: context, initialTime: t);
      if (picked != null) onPick(picked);
    },
  );

  Widget _propertySelector(WorkerProvider p) {
    if (p.propertiesLoading) return const LinearProgressIndicator();
    return Wrap(
      spacing: 8,
      children: p.properties.map((prop) {
        final id = prop['_id'].toString();
        final sel = p.selectedPropertyIds.contains(id);
        return ChoiceChip(
          label: Text(prop['title'] ?? ""),
          selected: sel,
          onSelected: (_) => p.toggleProperty(id),
        );
      }).toList(),
    );
  }
}