import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/landlord/tenancy_dashboard_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

import '../../../model/model/tenancy_model.dart' show TenancyModel;

final colors = AppThemeColors();

class EditTenancyScreen extends StatefulWidget {
  final TenancyModel tenancy;

  const EditTenancyScreen({super.key, required this.tenancy});

  @override
  State<EditTenancyScreen> createState() => _EditTenancyScreenState();
}

class _EditTenancyScreenState extends State<EditTenancyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers (same as Create)
  late TextEditingController tenantNameCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController bedCtrl;
  late TextEditingController rentCtrl;
  late TextEditingController depositCtrl;
  late TextEditingController maintenanceCtrl;

  late TextEditingController emergencyNameCtrl;
  late TextEditingController emergencyPhoneCtrl;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    final t = widget.tenancy;

    tenantNameCtrl = TextEditingController(text: t.tenant.name);
    phoneCtrl = TextEditingController(text: t.tenant.phone);
    bedCtrl = TextEditingController(text: "1");

    rentCtrl = TextEditingController(text: t.financials.monthlyRent.toString());
    depositCtrl = TextEditingController(
      text: t.financials.securityDeposit.toString(),
    );
    maintenanceCtrl = TextEditingController(text: "0");

    emergencyNameCtrl = TextEditingController(text: "Father");
    emergencyPhoneCtrl = TextEditingController(text: t.tenant.phone);
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final p = context.read<TenancyDashboardProvider>();
    final t = widget.tenancy;

    final success = await p.updateTenancy(
      tenancyId: t.id,

      // ===== BASIC =====
      bedNumber: int.parse(bedCtrl.text),

      // ===== AGREEMENT =====
      agreementStart: t.agreement.startDate,
      agreementEnd: t.agreement.endDate,
      durationMonths: t.agreement.durationMonths,
      renewalOption: true,
      autoRenew: false,

      // ===== FINANCIALS =====
      monthlyRent: int.parse(rentCtrl.text),
      securityDeposit: int.parse(depositCtrl.text),
      securityDepositPaid: false,
      maintenanceCharges: int.parse(maintenanceCtrl.text),
      rentDueDay: 5,
      lateFeePerDay: 50,
      gracePeriodDays: 3,

      // ===== EMERGENCY =====
      emergencyName: emergencyNameCtrl.text,
      emergencyPhone: emergencyPhoneCtrl.text,
      emergencyRelation: "Father",

      // ===== EMPLOYMENT =====
      employmentType: "Student",

      // ===== ID PROOF =====
      idProofType: "Aadhaar",
      idProofNumber: "NA",

      // ===== POLICE =====
      policeVerified: false,

      // ===== OCCUPANCY =====
      moveInDate: t.agreement.startDate,
      moveOutDate: t.agreement.endDate,

      status: t.status,
    );

    setState(() => loading = false);

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tenancy;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: CommonWidget.gradientAppBar(
        title: "Edit Tenancy",
        onPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(
                "Property Allocation",
                Icons.location_city_outlined,
              ),
              _buildCard([
                _readonly("Property", t.property.title),
                _readonly("Room", t.room.roomNumber),
                _text(bedCtrl, "Bed Number", Icons.bed_outlined, number: true),
              ]),

              const SizedBox(height: 25),
              _sectionHeader("Emergency Contact", Icons.warning_amber_outlined),
              _buildCard([
                _text(emergencyNameCtrl, "Contact Name", Icons.person_outline),
                _text(
                  emergencyPhoneCtrl,
                  "Contact Phone",
                  Icons.phone,
                  number: true,
                ),
              ]),

              const SizedBox(height: 25),
              _sectionHeader("Tenant Information", Icons.person_outline),
              _buildCard([
                _text(tenantNameCtrl, "Full Name", Icons.badge_outlined),
                _text(
                  phoneCtrl,
                  "Phone Number",
                  Icons.phone_android_outlined,
                  number: true,
                ),
              ]),

              const SizedBox(height: 25),
              _sectionHeader(
                "Agreement & Financials",
                Icons.description_outlined,
              ),
              _buildCard([
                _text(
                  rentCtrl,
                  "Monthly Rent",
                  Icons.currency_rupee,
                  number: true,
                ),
                _text(
                  depositCtrl,
                  "Security Deposit",
                  Icons.lock_clock_outlined,
                  number: true,
                ),
                _text(
                  maintenanceCtrl,
                  "Maintenance",
                  Icons.build_circle_outlined,
                  number: true,
                ),
              ]),

              const SizedBox(height: 35),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: colors.containerWhite,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15),
      ],
    ),
    child: Column(children: children),
  );

  Widget _sectionHeader(String title, IconData icon) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 12),
    child: Row(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: colors.textGrey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );

  Widget _text(
    TextEditingController c,
    String l,
    IconData icon, {
    bool number = false,
  }) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: TextFormField(
      controller: c,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
      decoration: InputDecoration(prefixIcon: Icon(icon), labelText: l),
    ),
  );

  Widget _readonly(String label, String value) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
      ),
    ),
  );

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 58,
    child: ElevatedButton(
      onPressed: loading ? null : submit,
      child: loading
          ? const CircularProgressIndicator()
          : const Text("UPDATE TENANCY"),
    ),
  );
}
