import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class ChannelPartnerFormView extends StatefulWidget {
  const ChannelPartnerFormView({super.key});

  @override
  State<ChannelPartnerFormView> createState() =>
      _ChannelPartnerFormViewState();
}

class _ChannelPartnerFormViewState extends State<ChannelPartnerFormView> {
  final _formKey = GlobalKey<FormState>();

  /// Controllers
  final Map<String, TextEditingController> controllers = {
    "name": TextEditingController(),
    "phone": TextEditingController(),
    "email": TextEditingController(),
    "company": TextEditingController(),
    "message": TextEditingController(),
  };

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final companyName = controllers["company"]!.text.trim();

    final payload = {
      "contactInfo": {
        "name": controllers["name"]!.text.trim(),
        "phone": controllers["phone"]!.text.trim(),
        "email": controllers["email"]!.text.trim(),
      },
      "channelPartnerDetails": {
        "companyName": companyName,
      },
      "message": "Channel Partner Inquiry from $companyName",
    };

    debugPrint("CHANNEL PARTNER PAYLOAD => $payload");

    // 🔥 Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success =
    await ChannelPartnerService.submitChannelPartner(payload);

    Navigator.pop(context); // close loader

    if (success) {
      _showSuccessDialog();
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(title: "Submit",
        onPressed: () async =>_submitForm(),
        ),
      ),

      backgroundColor: const Color(0xFFF5F6FA),
      appBar: CommonWidget.gradientAppBar(
        title: "Channel Partner Form",
        onPressed: () {
          Navigator.pop(context);
        },
      ),      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              /// 🔥 TOP CARD
              _headerCard(),

              const SizedBox(height: 20),

              /// 🔹 CONTACT INFO
              _formCard(
                title: "Contact Information",
                children: [
                  _dynamicField(
                    keyName: "name",
                    label: "Full Name",
                    icon: Icons.person_outline,
                    validator: (v) =>
                    v!.isEmpty ? "Name required" : null,
                  ),
                  _dynamicField(
                    keyName: "phone",
                    label: "Phone Number",
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                    v!.length != 10 ? "Enter valid phone" : null,
                  ),
                  _dynamicField(
                    keyName: "email",
                    label: "Email Address",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    !v!.contains("@") ? "Enter valid email" : null,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 COMPANY INFO
              _formCard(
                title: "Company Details",
                children: [
                  _dynamicField(
                    keyName: "company",
                    label: "Company Name",
                    icon: Icons.business_outlined,
                    validator: (v) =>
                    v!.isEmpty ? "Company required" : null,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 MESSAGE
              _formCard(
                title: "Message",
                children: [
                  _dynamicField(
                    keyName: "message",
                    label: "Write your message",
                    icon: Icons.message_outlined,
                    maxLines: 4,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// 🔥 SUBMIT BUTTON
            ],
          ),
        ),
      ),
    );
  }

  // ====================== UI COMPONENTS ======================

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppThemeColors().backgroundLeft,
            AppThemeColors().backgroundRight,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Become a Channel Partner",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Partner with us and grow your real estate business",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

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
            blurRadius: 15,
            offset: const Offset(0, 8),
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

  Widget _dynamicField({
    required String keyName,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controllers[keyName],
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppThemeColors().primary,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enquiry Submitted"),
        content: const Text(
          "Thank you for contacting us. Our team will get back to you soon.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Something went wrong"),
        content: const Text(
          "Unable to submit your enquiry. Please try again later.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

}



class ChannelPartnerService {
  static const String _baseUrl =
      "https://api.gharzoreality.com/api/v2/enquiries/channel-partner";

  static Future<bool> submitChannelPartner(Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint("API ERROR: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("API EXCEPTION: $e");
      return false;
    }
  }
}
