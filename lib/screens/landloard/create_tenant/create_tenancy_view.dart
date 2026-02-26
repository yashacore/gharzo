import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:gharzo_project/model/model/create_tenancy_model.dart';

class CreateTenancyView extends StatefulWidget {
  const CreateTenancyView({super.key});

  @override
  State<CreateTenancyView> createState() => _CreateTenancyViewState();
}

class _CreateTenancyViewState extends State<CreateTenancyView> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emergencyNameCtrl = TextEditingController();
  final emergencyPhoneCtrl = TextEditingController();

  bool loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final request = CreateTenancyRequest(
      propertyId: "69982084cfe601cc6a394db0",
      roomId: "69985b5383d4ce3e1dbc391f",
      bedNumber: 1,
      tenantInfo: TenantInfo(
        name: nameCtrl.text,
        phone: phoneCtrl.text,
        emergencyContact: EmergencyContact(
          name: emergencyNameCtrl.text,
          phone: emergencyPhoneCtrl.text,
          relation: "Father",
        ),
        idProof: IdProof(type: "Aadhaar", number: ""),
        policeVerification: PoliceVerification(done: false),
        employmentDetails: EmploymentDetails(type: "Student"),
      ),
      agreement: Agreement(
        startDate: "2026-02-20",
        endDate: "2027-02-20",
        durationMonths: 12,
        renewalOption: true,
        autoRenew: false,
      ),
      financials: Financials(
        monthlyRent: 1,
        securityDeposit: 111,
        securityDepositPaid: false,
        maintenanceCharges: 11,
        rentDueDay: 5,
        lateFeePerDay: 50,
        gracePeriodDays: 3,
      ),
    );

    final response = await ApiServiceMethod.createTenancy(request);

    debugPrint("🟢 CREATE TENANCY RESPONSE => $response");

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response['success'] == true
              ? "Tenancy created successfully"
              : response['message'] ?? "Failed",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Tenancy")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field("Tenant Name", nameCtrl),
              _field("Tenant Phone", phoneCtrl, keyboard: TextInputType.phone),
              _field("Emergency Contact Name", emergencyNameCtrl),
              _field(
                "Emergency Contact Phone",
                emergencyPhoneCtrl,
                keyboard: TextInputType.phone,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : _submit,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Create Tenancy"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
