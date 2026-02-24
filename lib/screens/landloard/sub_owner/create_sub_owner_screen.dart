import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/providers/landlord/create_sub_owner_provider.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

final colors = AppThemeColors();

class CreateSubOwnerScreen extends StatefulWidget {
  const CreateSubOwnerScreen({super.key});

  @override
  State<CreateSubOwnerScreen> createState() => _CreateSubOwnerScreenState();
}

class _CreateSubOwnerScreenState extends State<CreateSubOwnerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch properties once
    Future.microtask(() {
      final provider = context.read<SubOwnerProvider>();
      provider.fetchProperties();
      provider.fetchPermissions(); // 👈 ADD THIS
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubOwnerProvider>();

    return Scaffold(
      appBar: CommonWidget.gradientAppBar(
        title: "Create Sub Owner",
        onPressed: () => Navigator.pop(context),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ===== BASIC DETAILS =====
                  _sectionHeader("Sub Owner Details"),
                  _text(nameCtrl, "Full Name"),
                  _text(emailCtrl, "Email"),
                  _text(phoneCtrl, "Phone Number", number: true),
                  _text(passwordCtrl, "Password", obscure: true),
                  _text(notesCtrl, "Notes", required: false),

                  const SizedBox(height: 24),

                  // ===== PERMISSIONS =====
                  _sectionHeader("Assign Properties"),
                  // ===== SELECT ALL OPTION =====
                  const SizedBox(height: 12),

                  if (provider.properties.isEmpty)
                    const Text("No properties found"),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: provider.properties.map((p) {
                      final String id = p['_id'].toString();
                      final String title = p['title'] ?? "Untitled";

                      final bool selected = provider.selectedPropertyIds
                          .contains(id);

                      return FilterChip(
                        label: Text(
                          title,
                          style: TextStyle(
                            color: selected ? Colors.white : colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        selected: selected,
                        selectedColor: colors.primary,
                        backgroundColor: colors.containerWhite,
                        checkmarkColor: Colors.white,
                        onSelected: (bool value) {
                          provider.toggleProperty(id);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ===== PERMISSIONS =====
                  _sectionHeader("Assign Permission"),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: provider.permissions.map((p) {
                      final String id = p['_id'].toString(); // ✅ SEND THIS
                      final String name = p['name']; // ✅ SHOW THIS

                      final bool selected = provider.selectedPermissionIds
                          .contains(id);

                      return FilterChip(
                        label: Text(
                          name,
                          style: TextStyle(
                            color: selected ? Colors.white : colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        selected: selected,
                        selectedColor: colors.primary,
                        checkmarkColor: Colors.white,
                        backgroundColor: colors.containerWhite,
                        onSelected: (_) {
                          provider.togglePermission(id);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ===== SUBMIT =====
                  PrimaryButton(
                    title: "Create",
                    onPressed: provider.loading ? null : _submit,
                  ),
                ],
              ),
            ),
    );
  }

  // ================= SUBMIT =================

  Future<void> _submit() async {
    final provider = context.read<SubOwnerProvider>();

    if (!_formKey.currentState!.validate()) return;

    if (provider.selectedPropertyIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one property"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await provider.createSubOwner(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passwordCtrl.text,
      notes: notesCtrl.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Sub-owner created" : "Failed to create sub-owner",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) Navigator.pop(context);
  }

  // ================= HELPERS =================

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: colors.textGrey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _text(
    TextEditingController ctrl,
    String label, {
    bool number = false,
    bool obscure = false,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        obscureText: obscure,
        validator: required
            ? (v) => v == null || v.isEmpty ? "Required" : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: colors.primary.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
