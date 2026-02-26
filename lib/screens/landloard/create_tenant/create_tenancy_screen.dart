import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/data/landlord/tenant_api_service.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

// Using your defined colors
final colors = AppThemeColors();

class CreateTenancyScreen extends StatefulWidget {
  const CreateTenancyScreen({super.key});

  @override
  State<CreateTenancyScreen> createState() => _CreateTenancyScreenState();
}

class _CreateTenancyScreenState extends State<CreateTenancyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Data
  List<dynamic> properties = [];
  List<dynamic> rooms = [];
  String? selectedPropertyId;
  String? selectedRoomId;

  // Controllers (VISIBLE UI)
  final tenantNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final bedCtrl = TextEditingController(text: "1");
  final rentCtrl = TextEditingController();
  final depositCtrl = TextEditingController();
  final maintenanceCtrl = TextEditingController();

  // Emergency Contact
  final emergencyNameCtrl = TextEditingController();
  final emergencyPhoneCtrl = TextEditingController();
  String emergencyRelation = "Father";

  // Verification
  final idProofCtrl = TextEditingController();
  String selectedIdProofType = "Aadhaar";
  String employmentType = "Student";
  bool policeVerified = false;

  // Financial rules
  final rentDueDayCtrl = TextEditingController(text: "5");
  final lateFeeCtrl = TextEditingController(text: "50");
  final gracePeriodCtrl = TextEditingController(text: "3");

  // Agreement
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 365));
  bool renewal = true;
  bool depositPaid = false;
  bool loading = false;

  // Dropdown data
  final List<String> relations = [
    "Father",
    "Mother",
    "Brother",
    "Sister",
    "Spouse",
    "Other",
  ];
  final List<String> idProofTypes = [
    "Aadhaar",
    "PAN",
    "Passport",
    "Driving License",
  ];
  final List<String> employmentTypes = [
    "Student",
    "Salaried",
    "Self Employed",
    "Unemployed",
  ];

  @override
  void initState() {
    super.initState();
    loadProperties();
  }

  Future<void> loadProperties() async {
    properties = await TenancyApiService.fetchMyProperties();
    setState(() {});
  }

  Future<void> loadRooms(String propertyId) async {
    rooms = [];
    selectedRoomId = null;
    setState(() {});
    rooms = await TenancyApiService.fetchRoomsByProperty(propertyId);
    setState(() {});
  }

  Future<void> submit() async {
    debugPrint("🟢 SUBMIT TENANCY STARTED");

    // 1️⃣ Form validation
    if (!_formKey.currentState!.validate()) {
      debugPrint("❌ FORM VALIDATION FAILED");
      return;
    }
    debugPrint("✅ FORM VALIDATED");

    // 2️⃣ Show loader
    debugPrint("⏳ SET LOADING TRUE");
    setState(() => loading = true);

    // 3️⃣ Build payload
    debugPrint("📦 BUILDING TENANCY PAYLOAD");

    final payload = {
      "propertyId": selectedPropertyId,
      "roomId": selectedRoomId,
      "bedNumber": int.parse(bedCtrl.text),

      "tenantInfo": {
        "name": tenantNameCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),

        "emergencyContact": {
          "name": emergencyNameCtrl.text.trim(),
          "phone": emergencyPhoneCtrl.text.trim(),
          "relation": emergencyRelation,
        },

        "idProof": {
          "type": selectedIdProofType,
          "number": idProofCtrl.text.trim(),
        },

        "policeVerification": {"done": policeVerified},

        "employmentDetails": {"type": employmentType},
      },

      "agreement": {
        "startDate": startDate.toIso8601String().split("T").first,
        "endDate": endDate.toIso8601String().split("T").first,
        "durationMonths": 12,
        "renewalOption": renewal,
        "autoRenew": false,
      },

      "financials": {
        "monthlyRent": int.parse(rentCtrl.text),
        "securityDeposit": int.parse(depositCtrl.text),
        "securityDepositPaid": depositPaid,
        "maintenanceCharges": int.parse(maintenanceCtrl.text),
        "rentDueDay": int.parse(rentDueDayCtrl.text),
        "lateFeePerDay": int.parse(lateFeeCtrl.text),
        "gracePeriodDays": int.parse(gracePeriodCtrl.text),
      },
    };

    // 4️⃣ Payload preview
    debugPrint("📋 PAYLOAD PREVIEW:");
    payload.forEach((key, value) {
      debugPrint("➡️ $key : $value");
    });

    // 5️⃣ API Call
    debugPrint("🚀 CALLING CREATE TENANCY API");

    final success = await TenancyApiService.createTenancy(payload);

    debugPrint("⬅️ API RESPONSE: success = $success");

    // 6️⃣ Hide loader
    debugPrint("🔄 SET LOADING FALSE");
    setState(() => loading = false);

    // 7️⃣ UI feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Tenancy Created" : "Failed"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    // 8️⃣ Navigation
    if (success) {
      debugPrint("🎉 TENANCY CREATED — POP SCREEN");
      Navigator.pop(context);
    } else {
      debugPrint("❌ TENANCY CREATION FAILED");
    }

    debugPrint("🟢 SUBMIT TENANCY FINISHED");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: CommonWidget.gradientAppBar(
        title: "Create Tenancy",
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
                _buildDropdown(
                  "Select Property",
                  selectedPropertyId,
                  properties
                      .map(
                        (p) => DropdownMenuItem(
                          value: p['_id'].toString(),
                          child: Text(p['title'] ?? ""),
                        ),
                      )
                      .toList(),
                  (v) {
                    setState(() {
                      selectedPropertyId = v;
                      selectedRoomId = null;
                    });
                    loadRooms(v!);
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  "Select Room",
                  selectedRoomId,
                  rooms
                      .map(
                        (r) => DropdownMenuItem(
                          value: r['_id'].toString(),
                          child: Text("Room ${r['roomNumber']}"),
                        ),
                      )
                      .toList(),
                  (v) => setState(() => selectedRoomId = v),
                ),
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
                _buildDropdown(
                  "Relation",
                  emergencyRelation,
                  relations
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  (v) => setState(() => emergencyRelation = v!),
                ),
              ]),

              const SizedBox(height: 25),
              _sectionHeader(
                "Verification Details",
                Icons.verified_user_outlined,
              ),
              _buildCard([
                _buildDropdown(
                  "ID Proof Type",
                  selectedIdProofType,
                  idProofTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  (v) => setState(() => selectedIdProofType = v!),
                ),
                _text(idProofCtrl, "ID Proof Number", Icons.badge_outlined),
                _buildDropdown(
                  "Employment Type",
                  employmentType,
                  employmentTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  (v) => setState(() => employmentType = v!),
                ),
                _buildSwitchTile(
                  "Police Verification Done",
                  policeVerified,
                  (v) => setState(() => policeVerified = v),
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
                const Divider(height: 30),
                _buildSwitchTile(
                  "Security Deposit Paid",
                  depositPaid,
                  (v) => setState(() => depositPaid = v),
                ),
                _buildSwitchTile(
                  "Renewal Option Available",
                  renewal,
                  (v) => setState(() => renewal = v),
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

  Widget _buildDropdown(
    String hint,
    String? value, // ✅ nullable
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint, style: TextStyle(color: colors.textHint, fontSize: 14)),
      items: items,
      onChanged: onChanged,
      validator: (v) => v == null ? "Required" : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.primary.withOpacity(0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) =>
      SwitchListTile(title: Text(title), value: value, onChanged: onChanged);

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 58,
    child: ElevatedButton(
      onPressed: loading ? null : submit,
      child: loading
          ? const CircularProgressIndicator()
          : const Text("CREATE TENANCY"),
    ),
  );

  @override
  void dispose() {
    tenantNameCtrl.dispose();
    phoneCtrl.dispose();
    bedCtrl.dispose();
    rentCtrl.dispose();
    depositCtrl.dispose();
    maintenanceCtrl.dispose();
    emergencyNameCtrl.dispose();
    emergencyPhoneCtrl.dispose();
    idProofCtrl.dispose();
    rentDueDayCtrl.dispose();
    lateFeeCtrl.dispose();
    gracePeriodCtrl.dispose();
    super.dispose();
  }
}
