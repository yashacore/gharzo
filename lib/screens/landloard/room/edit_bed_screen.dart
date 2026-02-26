import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:gharzo_project/providers/landlord/my_properties_provider.dart';
import 'package:gharzo_project/model/model/bed/bed_model_user.dart';

final colors = AppThemeColors();

class EditBedScreen extends StatefulWidget {
  final BedModel bed;

  const EditBedScreen({super.key, required this.bed});

  @override
  State<EditBedScreen> createState() => _EditBedScreenState();
}

class _EditBedScreenState extends State<EditBedScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final bedNumberCtrl = TextEditingController();
  final rentCtrl = TextEditingController();
  final depositCtrl = TextEditingController();
  final maintenanceCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  // State
  String bedType = "Single";
  String condition = "Good";

  bool hasAC = false;
  bool hasAttachedBathroom = false;
  bool hasLocker = false;
  bool hasStudyTable = false;
  bool hasWardrobe = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  // ================= PREFILL =================
  void _prefill() {
    final b = widget.bed;

    bedNumberCtrl.text = b.bedNumber;
    rentCtrl.text = b.rent.toString();
    depositCtrl.text = b.securityDeposit.toString();
    maintenanceCtrl.text = b.maintenanceCharges.toString();

    bedType = b.bedType;

    // ❗ Not provided by API → defaults
    condition = "Good";
    notesCtrl.text = "";
    hasAC = false;
    hasAttachedBathroom = false;
    hasLocker = false;
    hasStudyTable = false;
    hasWardrobe = false;
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      appBar: CommonWidget.gradientAppBar(
        title: "Edit Bed",
        onPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section("Basic Info"),
              _card([
                _text(bedNumberCtrl, "Bed Number"),
                _dropdown(
                  "Bed Type",
                  bedType,
                  const ["Single", "Double"],
                      (v) => setState(() => bedType = v!),
                ),
                _dropdown(
                  "Condition",
                  condition,
                  const ["Excellent", "Good", "Average"],
                      (v) => setState(() => condition = v!),
                ),
              ]),
              const SizedBox(height: 24),

              _section("Pricing"),
              _card([
                _text(rentCtrl, "Rent", number: true),
                _text(depositCtrl, "Security Deposit", number: true),
                _text(maintenanceCtrl, "Maintenance Charges", number: true),
              ]),
              const SizedBox(height: 24),

              _section("Features"),
              _card([
                _switch("AC", hasAC, (v) => setState(() => hasAC = v)),
                _switch("Attached Bathroom", hasAttachedBathroom,
                        (v) => setState(() => hasAttachedBathroom = v)),
                _switch("Locker", hasLocker,
                        (v) => setState(() => hasLocker = v)),
                _switch("Study Table", hasStudyTable,
                        (v) => setState(() => hasStudyTable = v)),
                _switch("Wardrobe", hasWardrobe,
                        (v) => setState(() => hasWardrobe = v)),
              ]),
              const SizedBox(height: 24),

              _section("Notes"),
              _card([
                _text(notesCtrl, "Notes", maxLines: 3),
              ]),
              const SizedBox(height: 36),
              PrimaryButton(title: "Submit",
                onPressed: isLoading ? null : _submit,

              )

            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t.toUpperCase(),
      style: TextStyle(
        color: colors.textGrey,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );

  Widget _card(List<Widget> c) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: colors.containerWhite,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(children: c),
  );

  Widget _text(TextEditingController c, String l,
      {bool number = false, int maxLines = 1}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: c,
          maxLines: maxLines,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
          decoration: InputDecoration(labelText: l),
        ),
      );

  Widget _dropdown(String l, String v, List<String> items,
      Function(String?) onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: DropdownButtonFormField<String>(
          value: v,
          items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(labelText: l),
        ),
      );

  Widget _switch(String t, bool v, Function(bool) onChanged) =>
      SwitchListTile(
        title: Text(t),
        value: v,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
      );


  // ================= SUBMIT =================
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final payload = {
      "bedNumber": bedNumberCtrl.text.trim(),
      "bedType": bedType,
      "pricing": {
        "rent": int.parse(rentCtrl.text),
        "securityDeposit": int.parse(depositCtrl.text),
        "maintenanceCharges": int.parse(maintenanceCtrl.text),
      },
      "features": {
        "hasAC": hasAC,
        "hasAttachedBathroom": hasAttachedBathroom,
        "hasLocker": hasLocker,
        "hasStudyTable": hasStudyTable,
        "hasWardrobe": hasWardrobe,
      },
      "condition": condition,
      "notes": notesCtrl.text.trim(),
    };

    final success = await context
        .read<MyPropertiesProvider>()
        .updateBed(bedId: widget.bed.id, payload: payload);

    if (!mounted) return;

    setState(() => isLoading = false);

    if (success) Navigator.pop(context, true);
  }
}