import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/data/reels_api_service/franchise_enquiry_service.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

class FranchiseEnquiryView extends StatefulWidget {
  const FranchiseEnquiryView({super.key});

  @override
  State<FranchiseEnquiryView> createState() =>
      _FranchiseEnquiryViewState();
}

class _FranchiseEnquiryViewState extends State<FranchiseEnquiryView> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> controllers = {
    "name": TextEditingController(),
    "email": TextEditingController(),
    "phone": TextEditingController(),
    "message": TextEditingController(),
  };

  String priority = "High";

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "contactInfo": {
        "name": controllers["name"]!.text.trim(),
        "email": controllers["email"]!.text.trim(),
        "phone": controllers["phone"]!.text.trim(),
      },
      "message": controllers["message"]!.text.trim(),
      "priority": priority,
      "source": "Website",
      "status": "New",
      "typeSpecificData": {},
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success =
    await FranchiseEnquiryService.submitFranchiseEnquiry(payload);

    Navigator.pop(context);

    _showResultDialog(success);
  }

  void _showResultDialog(bool success) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? "Enquiry Sent" : "Failed"),
        content: Text(
          success
              ? "Our team will contact you shortly."
              : "Something went wrong. Please try again.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (success) Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
        appBar: CommonWidget.gradientAppBar(
          title: "Franchise Enquiry",
          onPressed: () {
            Navigator.pop(context);
          },
        ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _formCard(
                title: "Contact Information",
                children: [
                  _field("name", "Full Name", Icons.person_outline),
                  _field("email", "Email Address", Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress),
                  _field("phone", "Phone Number", Icons.phone_outlined,
                      keyboardType: TextInputType.phone),
                ],
              ),

              const SizedBox(height: 20),

              _formCard(
                title: "Enquiry Details",
                children: [
                  DropdownButtonFormField<String>(
                    value: priority,
                    items: ["High", "Medium", "Low"]
                        .map(
                          (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                        .toList(),
                    onChanged: (v) => setState(() => priority = v!),
                    decoration: _inputDecoration(
                        "Priority", Icons.priority_high),
                  ),
                  const SizedBox(height: 14),
                  _field(
                    "message",
                    "Message",
                    Icons.message_outlined,
                    maxLines: 4,
                  ),
                ],
              ),

              const SizedBox(height: 30),
              PrimaryButton(title: "Submit", onPressed: ()=>_submitForm())


            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _formCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _field(
      String keyName,
      String label,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controllers[keyName],
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (v) =>
        v == null || v.isEmpty ? "$label is required" : null,
        decoration: _inputDecoration(label, icon),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
