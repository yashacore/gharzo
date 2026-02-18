import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/add_properties/contact_information/contact_info_provider.dart';
import 'package:gharzo_project/screens/add_properties/submit_property/submit_property_view.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';

class ContactInfoView extends StatelessWidget {
  final String propertyId;

  const ContactInfoView({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    const Color gradientStart = Color(0xFF1E3C72);

    return ChangeNotifierProvider(
      create: (_) => ContactProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.contactDetails,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Consumer<ContactProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: gradientStart,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Primary Contact",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      "This information will be used by potential buyers to contact you regarding your listing.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey[200]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _customTextField(
                            label: "Full Name",
                            hint: "Full Name",
                            icon: Icons.person_rounded,
                            accentColor: gradientStart,
                            onChanged: (v) => provider.name = v,
                          ),
                          _customTextField(
                            label: "Phone Number",
                            hint: "Phone Number",
                            icon: Icons.phone_android_rounded,
                            accentColor: gradientStart,
                            isNumber: true,
                            onChanged: (v) => provider.phone = v,
                          ),
                          _customTextField(
                            label: "Alternate Phone",
                            hint: "Secondary number (optional)",
                            icon: Icons.add_call,
                            accentColor: gradientStart,
                            isNumber: true,
                            onChanged: (v) => provider.alternatePhone = v,
                          ),
                          _customTextField(
                            label: "Email Address",
                            hint: "Email",
                            icon: Icons.alternate_email_rounded,
                            accentColor: gradientStart,
                            onChanged: (v) => provider.email = v,
                          ),
                          // Dropdown for Preferred Call Time
                          Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: DropdownButtonFormField<String>(
                              value: provider.preferredCallTime,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded),
                              decoration: InputDecoration(
                                labelText: "Preferred Call Time",
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.history_toggle_off_rounded, color: gradientStart),
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey[200]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey[200]!),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: "Morning (9AM-12PM)",
                                    child: Text("Morning (9AM-12PM)")),
                                DropdownMenuItem(
                                    value: "Afternoon (12PM-5PM)",
                                    child: Text("Afternoon (12PM-5PM)")),
                                DropdownMenuItem(
                                    value: "Evening (5PM-9PM)",
                                    child: Text("Evening (5PM-9PM)")),
                              ],
                              onChanged: (v) => provider.preferredCallTime = v!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: gradientStart.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: CommonWidget.commonElevatedBtn(
                      btnText: "Continue",
                      isLoading: provider.loading,
                      onPressed: provider.loading
                          ? null
                          : () async {
                        // Start loading
                        provider.loading = true;
                        provider.notifyListeners();

                        // Submit Contact Info
                        bool success = await provider.submit(propertyId);

                        provider.loading = false;
                        provider.notifyListeners();

                        if (success) {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubmitPropertyView(
                                  propertyId: propertyId,
                                ),
                              ),
                            );
                          }
                        } else {
                          // Show error
                          if (context.mounted && provider.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(provider.error!)),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _customTextField({
    required String label,
    required String hint,
    required IconData icon,
    required Color accentColor,
    required Function(String) onChanged,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: TextField(
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        onChanged: onChanged,
        style: const TextStyle(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: Icon(icon, color: accentColor, size: 22),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: accentColor, width: 1.5),
          ),
          floatingLabelStyle: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
