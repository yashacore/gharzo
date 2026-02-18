import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/data/reels_api_service/services_api.dart';
import 'package:gharzo_project/providers/services_provider.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:provider/provider.dart';


class ServiceEnquiryScreen extends StatefulWidget {
  final String serviceId;

  const ServiceEnquiryScreen({super.key, required this.serviceId});

  @override
  State<ServiceEnquiryScreen> createState() => _ServiceEnquiryScreenState();
}

class _ServiceEnquiryScreenState extends State<ServiceEnquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final subjectCtrl = TextEditingController();
  final messageCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final localityCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  String contactMethod = "WhatsApp";
  String timeSlot = "Morning (9AM-12PM)";
  bool isLoading = false;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<ServicesProvider>(context, listen: false);

    final request = ServiceEnquiryRequest(
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      subject: subjectCtrl.text.trim(),
      message: messageCtrl.text.trim(),
      serviceId: widget.serviceId,
      preferredContactMethod: contactMethod,
      preferredTimeSlot: timeSlot,
      location: Location(
        city: cityCtrl.text,
        locality: localityCtrl.text,
        pincode: pincodeCtrl.text,
        address: addressCtrl.text,
      ),
    );

    await provider.createEnquiry(request);

    if (!mounted) return;

    if (provider.isSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomBarView()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enquiry Submitted Successfully")),
      );

      provider.reset();
    }
    else if (provider.error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.gradientAppBar(
        title: "Service Enquiry Form",
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _cardSection("Personal Details", [
                _input("Full Name", nameCtrl),
                _input("Phone", phoneCtrl, isPhone: true),
                _input("Email", emailCtrl, isEmail: true),
              ]),
              _cardSection("Service Details", [
                _input("Subject", subjectCtrl),
                _input("Message", messageCtrl, maxLines: 3),
              ]),
              _cardSection("Location", [
                _input("City", cityCtrl),
                _input("Locality", localityCtrl),
                _input("Pincode", pincodeCtrl, isNumber: true),
                _input("Address", addressCtrl),
              ]),
              _cardSection("Preferences", [
                _dropdown(
                  "Contact Method",
                  contactMethod,
                  ["WhatsApp", "Call", "Email"],
                      (v) => setState(() => contactMethod = v!),
                ),
                _dropdown(
                  "Preferred Time",
                  timeSlot,
                  [
                    "Morning (9AM-12PM)",
                    "Afternoon (12PM-4PM)",
                    "Evening (4PM-8PM)"
                  ],
                      (v) => setState(() => timeSlot = v!),
                ),
              ]),
              const SizedBox(height: 20),
              PrimaryButton(
                title: "Submit Enquiry",
                onPressed: isLoading ? null : submit,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _cardSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl,
      {bool isPhone = false,
        bool isEmail = false,
        bool isNumber = false,
        int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNumber
            ? TextInputType.number
            : isPhone
            ? TextInputType.phone
            : TextInputType.text,
        validator: (v) {
          if (v == null || v.isEmpty) return "$label is required";
          if (isEmail && !v.contains("@")) return "Enter valid email";
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
