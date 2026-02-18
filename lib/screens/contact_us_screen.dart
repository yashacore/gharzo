import 'package:flutter/material.dart';
import 'package:gharzo_project/providers/contac_us_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final colors = AppThemeColors();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactInquiryProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            _formCard(provider),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.backgroundLeft,
            colors.backgroundRight,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton( color: colors.textWhite,  onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,size: 34,),),
          const SizedBox(height: 12),
          Text(
            "Contact Us",
            style: TextStyle(
              color: colors.textWhite,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Have a question or property inquiry?\nWe’d love to hear from you.",
            style: TextStyle(
              color: colors.textWhite.withOpacity(.85),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ================= FORM CARD =================
  Widget _formCard(ContactInquiryProvider provider) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.containerWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field("Full Name", _nameCtrl, Icons.person),
              _field("Email", _emailCtrl, Icons.email,
                  type: TextInputType.emailAddress),
              _field("Phone", _phoneCtrl, Icons.phone,
                  type: TextInputType.phone),
              _field("Subject", _subjectCtrl, Icons.subject),
              _field(
                "Message",
                _messageCtrl,
                Icons.message,
                maxLines: 4,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  onPressed: provider.isLoading ? null : _submit,
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Submit Inquiry",
                    style: TextStyle(
                      color: colors.buttonTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _field(
      String label,
      TextEditingController controller,
      IconData icon, {
        int maxLines = 1,
        TextInputType type = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        validator: (v) => v == null || v.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: colors.primary),
          labelText: label,
          labelStyle: TextStyle(color: colors.labelText),
          hintText: label,
          hintStyle: TextStyle(color: colors.hintText),
          filled: true,
          fillColor: const Color(0xffF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ================= SUBMIT =================
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await context.read<ContactInquiryProvider>().submitInquiry(
        fullName: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        subject: _subjectCtrl.text,
        message: _messageCtrl.text,
        inquiryType: "Property Inquiry",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: colors.success,
          content: const Text("Inquiry submitted successfully"),
        ),
      );

      _formKey.currentState!.reset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: colors.error,
          content: Text(e.toString()),
        ),
      );
    }
  }
}
