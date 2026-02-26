import 'package:flutter/material.dart';
import 'package:gharzo_project/providers/landlord/my_properties_provider.dart';
import 'package:provider/provider.dart';

class AddBedScreen extends StatefulWidget {
  final String roomId;

  const AddBedScreen({super.key, required this.roomId});

  @override
  State<AddBedScreen> createState() => _AddBedScreenState();
}

class _AddBedScreenState extends State<AddBedScreen> {
  final _formKey = GlobalKey<FormState>();

  final bedNumberCtrl = TextEditingController();
  final rentCtrl = TextEditingController();
  final depositCtrl = TextEditingController();
  final maintenanceCtrl = TextEditingController(text: "0");
  final lengthCtrl = TextEditingController(text: "72");
  final widthCtrl = TextEditingController(text: "36");
  final notesCtrl = TextEditingController();

  String bedType = "Single";
  String genderPref = "Any";
  String occupationPref = "Any";
  String condition = "Good";

  bool hasAC = false;
  bool hasBathroom = false;
  bool hasLocker = false;
  bool hasStudyTable = false;
  bool hasWardrobe = false;
  bool nearWindow = false;
  bool cornerBed = false;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<MyPropertiesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Bed")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section("Basic"),
            _text(bedNumberCtrl, "Bed Number (eg. B1)"),
            _dropdown("Bed Type", bedType, ["Single", "Double"],
                    (v) => setState(() => bedType = v)),

            _section("Pricing"),
            _text(rentCtrl, "Monthly Rent", number: true),
            _text(depositCtrl, "Security Deposit", number: true),
            _text(maintenanceCtrl, "Maintenance", number: true),

            _section("Features"),
            _switch("AC", hasAC, (v) => setState(() => hasAC = v)),
            _switch("Attached Bathroom", hasBathroom, (v) => setState(() => hasBathroom = v)),
            _switch("Locker", hasLocker, (v) => setState(() => hasLocker = v)),
            _switch("Study Table", hasStudyTable, (v) => setState(() => hasStudyTable = v)),
            _switch("Wardrobe", hasWardrobe, (v) => setState(() => hasWardrobe = v)),

            _section("Position"),
            _switch("Near Window", nearWindow, (v) => setState(() => nearWindow = v)),
            _switch("Corner Bed", cornerBed, (v) => setState(() => cornerBed = v)),

            _section("Preferences"),
            _dropdown("Gender Preference", genderPref, ["Any", "Male", "Female"],
                    (v) => setState(() => genderPref = v)),
            _dropdown("Occupation Type", occupationPref,
                ["Any", "Student", "Working Professional"],
                    (v) => setState(() => occupationPref = v)),

            _section("Bed Size (inches)"),
            _text(lengthCtrl, "Length", number: true),
            _text(widthCtrl, "Width", number: true),

            _section("Condition"),
            _dropdown("Condition", condition, ["New", "Good", "Average"],
                    (v) => setState(() => condition = v)),

            _text(notesCtrl, "Notes", required: false),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: p.creating ? null : _submit,
              child: p.creating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("CREATE BED"),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SUBMIT =================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "roomId": widget.roomId,
      "bedNumber": bedNumberCtrl.text.trim(),
      "bedType": bedType,
      "pricing": {
        "rent": int.parse(rentCtrl.text),
        "securityDeposit": int.parse(depositCtrl.text),
        "maintenanceCharges": int.parse(maintenanceCtrl.text),
      },
      "features": {
        "hasAC": hasAC,
        "hasAttachedBathroom": hasBathroom,
        "hasLocker": hasLocker,
        "hasStudyTable": hasStudyTable,
        "hasWardrobe": hasWardrobe,
      },
      "position": {
        "nearWindow": nearWindow,
        "cornerBed": cornerBed,
        "description": "",
      },
      "preferences": {
        "genderPreference": genderPref,
        "occupationType": occupationPref,
      },
      "bedSize": {
        "length": int.parse(lengthCtrl.text),
        "width": int.parse(widthCtrl.text),
        "unit": "inches",
      },
      "condition": condition,
      "notes": notesCtrl.text.trim(),
    };

    final success =
    await context.read<MyPropertiesProvider>().createBed(payload);

    if (success && mounted) Navigator.pop(context, true);
  }

  // ================= HELPERS =================

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(t.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
  );

  Widget _text(TextEditingController c, String l,
      {bool number = false, bool required = true}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: c,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          validator: required ? (v) => v!.isEmpty ? "Required" : null : null,
          decoration: InputDecoration(labelText: l),
        ),
      );

  Widget _dropdown(
      String label, String value, List<String> items, Function(String) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v!),
    );
  }

  Widget _switch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}