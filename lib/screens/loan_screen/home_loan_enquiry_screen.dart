import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/home_loan_enquiry_provider.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:provider/provider.dart';

import '../../utils/theme/colors.dart';
import '../../common/common_widget/primary_button.dart';

class HomeLoanEnquiryScreen extends StatefulWidget {
  const HomeLoanEnquiryScreen({super.key});

  @override
  State<HomeLoanEnquiryScreen> createState() =>
      _HomeLoanEnquiryScreenState();
}

class _HomeLoanEnquiryScreenState
    extends State<HomeLoanEnquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Contact
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  // Loan
  final loanAmountCtrl = TextEditingController();
  final propertyValueCtrl = TextEditingController();
  final incomeCtrl = TextEditingController();

  String employmentType = "Salaried";
  String priority = "Medium";

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    loanAmountCtrl.dispose();
    propertyValueCtrl.dispose();
    incomeCtrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<HomeLoanEnquiryProvider>(context, listen: false);

    final loanAmount =
        double.tryParse(loanAmountCtrl.text.trim()) ?? 0;
    final propertyValue =
        double.tryParse(propertyValueCtrl.text.trim()) ?? 0;
    final monthlyIncome =
        double.tryParse(incomeCtrl.text.trim()) ?? 0;

    final request = HomeLoanEnquiryRequest(
      contactInfo: ContactInfo(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
      ),
      loanDetails: LoanDetails(
        loanAmount: loanAmount,
        propertyValue: propertyValue,
        employmentType: employmentType,
        monthlyIncome: monthlyIncome,
      ),
      message:
      "Home Loan Inquiry - Loan Amount: ₹${loanAmountCtrl.text}, "
          "Property Value: ₹${propertyValueCtrl.text}",
      priority: priority,
    );

    await provider.submit(request);

    if (!mounted) return;

    if (provider.isSuccess) {
      provider.reset(); // ✅ reset BEFORE navigation

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Home loan enquiry submitted successfully"),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const BottomBarView(),
        ),
      );

    } else if (provider.error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors();

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: CommonWidget.gradientAppBar(
        title: "Loan Enquiry Form",
        onPressed: () => Navigator.pop(context),
      ),
      body: Consumer<HomeLoanEnquiryProvider>(
        builder: (_, provider, __) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _section(
                    "Contact Information",
                    [
                      _input("Full Name", nameCtrl),
                      _input("Email", emailCtrl,
                          keyboard: TextInputType.emailAddress),
                      _input("Phone", phoneCtrl,
                          keyboard: TextInputType.phone),
                    ],
                  ),
                  _section(
                    "Loan Details",
                    [
                      _input("Loan Amount (₹)", loanAmountCtrl,
                          keyboard: TextInputType.number),
                      _input("Property Value (₹)", propertyValueCtrl,
                          keyboard: TextInputType.number),
                      _dropdown(
                        "Employment Type",
                        employmentType,
                        ["Salaried", "Self Employed"],
                            (v) =>
                            setState(() => employmentType = v!),
                      ),
                      _input("Monthly Income (₹)", incomeCtrl,
                          keyboard: TextInputType.number),
                    ],
                  ),
                  _section(
                    "Priority",
                    [
                      _dropdown(
                        "Priority",
                        priority,
                        ["Low", "Medium", "High"],
                            (v) => setState(() => priority = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    title: "Submit Enquiry",
                    onPressed:
                    provider.isLoading ? null : submit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /* ---------------- UI HELPERS ---------------- */

  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _input(
      String label,
      TextEditingController controller, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) =>
        v == null || v.isEmpty ? "$label is required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(
      String label,
      String value,
      List<String> items,
      ValueChanged<String?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map(
              (e) =>
              DropdownMenuItem(value: e, child: Text(e)),
        )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
