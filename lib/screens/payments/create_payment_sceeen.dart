import 'package:flutter/material.dart';
import 'package:gharzo_project/providers/landlord/payment_dashboard_provider.dart';
import 'package:provider/provider.dart';
// Keep your existing provider import here

class GenerateRentPaymentScreen extends StatefulWidget {
  const GenerateRentPaymentScreen({super.key});

  @override
  State<GenerateRentPaymentScreen> createState() => _GenerpZEAWYtiB6bJ16NuLbGCc6CZ6jJdKfb63();
}

class _GenerpZEAWYtiB6bJ16NuLbGCc6CZ6jJdKfb63 extends State<GenerateRentPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedTenancyId;

  // Initialize with '0' to make it user-friendly and avoid null parsing errors
  final maintenanceCtrl = TextEditingController(text: '0');
  final waterCtrl = TextEditingController(text: '0');
  final electricityCtrl = TextEditingController(text: '0');
  final otherCtrl = TextEditingController(text: '0');
  final otherDescCtrl = TextEditingController();
  final discountCtrl = TextEditingController(text: '0');
  final prevBalanceCtrl = TextEditingController(text: '0');
  final adjustmentCtrl = TextEditingController(text: '0');
  final notesCtrl = TextEditingController();

  int billingMonth = DateTime.now().month;
  int billingYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentDashboardProvider>().fetchMyTenancies();
    });
  }

  @override
  void dispose() {
    final controllers = [
      maintenanceCtrl, waterCtrl, electricityCtrl, otherCtrl,
      otherDescCtrl, discountCtrl, prevBalanceCtrl, adjustmentCtrl, notesCtrl
    ];
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  // UI Helper for Input Decoration
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      prefixText: "Rs. ", // Or your local currency
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentDashboardProvider>();
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Generate Rent Bill", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionTitle("Tenant Details"),
                  _buildTenantSelector(provider),

                  const SizedBox(height: 20),
                  _buildSectionTitle("Utility Charges"),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildNumberField("Maintenance", maintenanceCtrl, Icons.build_circle_outlined),
                          const SizedBox(height: 12),
                          _buildNumberField("Water Charges", waterCtrl, Icons.water_drop_outlined),
                          const SizedBox(height: 12),
                          _buildNumberField("Electricity", electricityCtrl, Icons.electric_bolt_outlined),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildSectionTitle("Additional Costs & Discounts"),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildNumberField("Other Charges", otherCtrl, Icons.add_circle_outline),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: otherDescCtrl,
                            decoration: InputDecoration(
                              labelText: "What are the other charges for?",
                              hintText: "e.g. Parking, Repair",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const Divider(height: 32),
                          _buildNumberField("Previous Balance", prevBalanceCtrl, Icons.history),
                          const SizedBox(height: 12),
                          _buildNumberField("Adjustments", adjustmentCtrl, Icons.settings_suggest_outlined),
                          const SizedBox(height: 12),
                          _buildNumberField("Discount", discountCtrl, Icons.credit_card, isDiscount: true),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildSectionTitle("Notes"),
                  TextFormField(
                    controller: notesCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Any internal notes for this payment...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: submit,
                      child: const Text(
                        "GENERATE & SEND INVOICE",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildTenantSelector(PaymentDashboardProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: selectedTenancyId,
          hint: const Text("Select Tenant & Property"),
          isExpanded: true,
          decoration: const InputDecoration(border: InputBorder.none),
          items: provider.tenancies.map((t) {
            return DropdownMenuItem<String>(
              value: t['_id'],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(t['tenantId']['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("${t['propertyId']['title']} - Room ${t['roomId']['roomNumber']}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) => setState(() => selectedTenancyId = v),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController ctrl, IconData icon, {bool isDiscount = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: _inputStyle(label, icon).copyWith(
        prefixIconColor: isDiscount ? Colors.green : Colors.blueGrey,
      ),
      onTap: () {
        if (ctrl.text == '0') ctrl.clear(); // Quality of life: clear '0' when user taps
      },
    );
  }
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedTenancyId == null) {
      // _snack("Please select tenant", isError: true);
      return;
    }

    final payload = {
      "tenancyId": selectedTenancyId,
      "billingMonth": billingMonth,
      "billingYear": billingYear,
      "maintenanceCharges": int.parse(maintenanceCtrl.text),
      "waterCharges": int.parse(waterCtrl.text),
      "electricityCharges": int.parse(electricityCtrl.text),
      "otherCharges": int.parse(otherCtrl.text),
      "otherChargesDescription": otherDescCtrl.text.trim(),
      "discount": int.parse(discountCtrl.text),
      "previousBalance": int.parse(prevBalanceCtrl.text),
      "adjustments": int.parse(adjustmentCtrl.text),
      "notes": notesCtrl.text.trim(),
    };

    final success =
    await context.read<PaymentDashboardProvider>().generateRent(
      payload: payload,
    );

    if (success) {
      // _snack("Rent payment generated");
      Navigator.pop(context, true);
    } else {
      // _snack("Failed to generate rent", isError: true);
    }
  }



}