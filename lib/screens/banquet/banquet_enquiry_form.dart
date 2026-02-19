import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/providers/banquet_provider.dart';

class BanquetEnquiryScreen extends StatelessWidget {
  final String banquetId;
  const BanquetEnquiryScreen({super.key, required this.banquetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Using a clean, minimal AppBar
      appBar: CommonWidget.gradientAppBar(
        title: "Reservation Enquiry",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // Sub-header to set the mood
            const Text(
              "Share your event details and we'll get back to you shortly.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 32),
            BanquetEnquiryForm(banquetId: banquetId),
          ],
        ),
      ),
    );
  }
}

class BanquetEnquiryForm extends StatefulWidget {
  final String banquetId;
  const BanquetEnquiryForm({super.key, required this.banquetId});

  @override
  State<BanquetEnquiryForm> createState() => _BanquetEnquiryFormState();
}

class _BanquetEnquiryFormState extends State<BanquetEnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await BanquetProvider.submitEnquiry(
      banquetId: widget.banquetId,
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      message: messageCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (mounted) {
      _showFeedback(success);
    }

    if (success) {
      _formKey.currentState!.reset();
      // Optional: Auto-close after success
      // Future.delayed(Duration(seconds: 2), () => Navigator.pop(context));
    }
  }

  void _showFeedback(bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? Colors.black : Colors.redAccent,
        content: Text(
          success ? "✨ Enquiry Sent Successfully" : "Submission Failed",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Stylish Modern Input Decoration
  InputDecoration _modernInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black38, fontSize: 14, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, size: 20, color: Colors.black87),
      floatingLabelStyle: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameCtrl,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: _modernInput("Full Name", Icons.person_outline),
            validator: (v) => v!.isEmpty ? "We need your name" : null,
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: _modernInput("Contact Number", Icons.phone_outlined),
            validator: (v) => v!.length < 10 ? "Enter a valid number" : null,
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: _modernInput("Email Address", Icons.alternate_email),
            validator: (v) => !v!.contains("@") ? "Email is required" : null,
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: messageCtrl,
            maxLines: 4,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: _modernInput("Event Details / Message", Icons.chat_bubble_outline),
            validator: (v) => v!.isEmpty ? "Tell us about your event" : null,
          ),
          const SizedBox(height: 40),
          PrimaryButton(title: "CONFIRM ENQUIRY",
            onPressed: isLoading ? null : submit,
          )

          // PREMIUM SUBMIT BUTTON
        ],
      ),
    );
  }
}