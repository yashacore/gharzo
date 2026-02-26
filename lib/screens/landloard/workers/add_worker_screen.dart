import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/providers/landlord/worker_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

final colors = AppThemeColors();

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  final _formKey = GlobalKey<FormState>();

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
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final expYearsCtrl = TextEditingController();
  final expDescCtrl = TextEditingController();
  final emergencyNameCtrl = TextEditingController();
  final emergencyPhoneCtrl = TextEditingController();

  String selectedWorkerType = 'Plumber';
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
    Future.microtask(() => context.read<WorkerProvider>().fetchMyProperties());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<WorkerProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: CommonWidget.gradientAppBar(
        title: "Register New Worker",
        onPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _sectionHeader("Identity & Role"),
            _card([
              _text(nameCtrl, "Full Name", Icons.person_outline),
              _text(
                phoneCtrl,
                "Phone Number",
                Icons.phone_android_outlined,
                number: true,
              ),
              _text(
                emailCtrl,
                "Email Address (Optional)",
                Icons.email_outlined,
                required: false,
              ),
              _dropdown(
                "Worker Category",
                selectedWorkerType,
                workerTypes,
                Icons.engineering_outlined,
                (v) => setState(() => selectedWorkerType = v),
              ),
            ]),

            _sectionHeader("Property Allocation"),
            _card([
              const Text(
                "Assigned Properties",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildPropertySelector(p),
              const Divider(height: 32),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Full Property Access"),
                subtitle: const Text(
                  "Worker can access all current and future properties",
                  style: TextStyle(fontSize: 12),
                ),
                value: fullAccess,
                activeColor: colors.primary,
                onChanged: (v) {
                  setState(() => fullAccess = v);
                  if (v) context.read<WorkerProvider>().clearProperties();
                },
              ),
            ]),

            _sectionHeader("Skill Set"),
            _card([
              _buildChipGroup(specializations, selectedSpecs, (s, selected) {
                setState(
                  () =>
                      selected ? selectedSpecs.add(s) : selectedSpecs.remove(s),
                );
              }),
            ]),

            _sectionHeader("Experience Summary"),
            _card([
              _text(
                expYearsCtrl,
                "Total Years of Experience",
                Icons.history_toggle_off,
                number: true,
              ),
              _text(
                expDescCtrl,
                "Brief Professional Background",
                Icons.description_outlined,
                required: false,
              ),
            ]),

            _sectionHeader("Work Schedule"),
            _card([
              _dropdown(
                "Availability Status",
                availabilityStatus,
                ["Available", "Unavailable"],
                Icons.event_available,
                (v) => setState(() => availabilityStatus = v),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _timeSelector(
                      "From",
                      fromTime,
                      (t) => setState(() => fromTime = t),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _timeSelector(
                      "To",
                      toTime,
                      (t) => setState(() => toTime = t),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Working Days",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              _buildChipGroup(workingDays, selectedDays, (d, selected) {
                setState(
                  () => selected ? selectedDays.add(d) : selectedDays.remove(d),
                );
              }),
            ]),

            _sectionHeader("Emergency Information"),
            _card([
              _text(
                emergencyNameCtrl,
                "Contact Person Name",
                Icons.contact_emergency_outlined,
              ),
              _text(
                emergencyPhoneCtrl,
                "Emergency Phone",
                Icons.phone_callback_outlined,
                number: true,
              ),
              _dropdown(
                "Relationship",
                emergencyRelation,
                ["Father", "Brother", "Spouse", "Friend", "Other"],
                Icons.people_outline,
                (v) => setState(() => emergencyRelation = v),
              ),
            ]),

            const SizedBox(height: 32),
            PrimaryButton(
              title: p.creating ? "Creating..." : "CREATE WORKER PROFILE",
              onPressed: p.creating ? null : _submit,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, top: 24, bottom: 12),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(
        color: colors.primary,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );

  Widget _text(
    TextEditingController c,
    String label,
    IconData icon, {
    bool number = false,
    bool required = true,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: c,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      validator: required ? (v) => v!.isEmpty ? "Required field" : null : null,
      style: const TextStyle(fontSize: 15),
      decoration: _inputDecoration(label, icon),
    ),
  );

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    IconData icon,
    Function(String) onChanged,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v!),
      decoration: _inputDecoration(label, icon),
    ),
  );

  InputDecoration _inputDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: colors.primary),
        filled: true,
        fillColor: Colors.grey.shade50,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      );

  Widget _timeSelector(
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onPick,
  ) => InkWell(
    onTap: () async {
      final picked = await showTimePicker(context: context, initialTime: time);
      if (picked != null) onPick(picked);
    },
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                time.format(context),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildChipGroup(
    List<String> items,
    Set<String> selection,
    Function(String, bool) onToggle,
  ) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: items.map((s) {
      final isSelected = selection.contains(s);
      return FilterChip(
        label: Text(
          s,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        selected: isSelected,
        selectedColor: colors.primary,
        checkmarkColor: Colors.white,
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(
          color: isSelected ? colors.primary : Colors.grey.shade300,
        ),
        onSelected: (val) => onToggle(s, val),
      );
    }).toList(),
  );

  Widget _buildPropertySelector(WorkerProvider p) {
    if (p.propertiesLoading) return const LinearProgressIndicator();
    if (p.properties.isEmpty)
      return const Text(
        "No properties available",
        style: TextStyle(color: Colors.redAccent),
      );

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: p.properties.map((prop) {
        final id = prop['_id'].toString();
        final selected = p.selectedPropertyIds.contains(id);
        return ChoiceChip(
          label: Text(
            prop['title'] ?? "Untitled",
            style: TextStyle(color: selected ? Colors.white : Colors.black87),
          ),
          selected: selected,
          selectedColor: colors.primary,
          onSelected: (_) => p.toggleProperty(id),
        );
      }).toList(),
    );
  }

  // ================= LOGIC REMAINS UNCHANGED =================
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
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
      "assignedProperties": fullAccess
          ? []
          : provider.selectedPropertyIds.toList(),
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
    final success = await provider.createWorker(payload);
    if (success && mounted) Navigator.pop(context, true);
  }
}
