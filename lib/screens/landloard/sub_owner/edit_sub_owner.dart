import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/providers/landlord/create_sub_owner_provider.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

final colors = AppThemeColors();

class EditSubOwnerScreen extends StatefulWidget {
  final Map<String, dynamic> subOwner;

  const EditSubOwnerScreen({super.key, required this.subOwner});

  @override
  State<EditSubOwnerScreen> createState() => _EditSubOwnerScreenState();
}

class _EditSubOwnerScreenState extends State<EditSubOwnerScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController notesCtrl;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.subOwner['name']);
    emailCtrl = TextEditingController(text: widget.subOwner['email']);
    phoneCtrl = TextEditingController(text: widget.subOwner['phone']);
    notesCtrl = TextEditingController(text: widget.subOwner['notes'] ?? "");

    Future.microtask(() {
      final provider = context.read<SubOwnerProvider>();

      /// Load master data
      provider.fetchProperties();
      provider.fetchPermissions();

      /// Preselect assigned properties
      provider.clearAllProperties();
      for (final p in widget.subOwner['assignedProperties'] ?? []) {
        provider.selectedPropertyIds.add(p['_id'].toString());
      }

      /// Preselect permissions
      provider.clearAllPermissions();
      for (final p in widget.subOwner['permissions'] ?? []) {
        provider.selectedPermissionIds.add(p['_id'].toString());
      }
    });
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubOwnerProvider>();

    return Scaffold(
      appBar: CommonWidget.gradientAppBar(
        title: "Edit Sub Owner",
        onPressed: () => Navigator.pop(context),
      ),
      body: provider.loading || provider.permissionsLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ===== BASIC INFO =====
                  _sectionHeader("Sub Owner Details"),
                  _text(nameCtrl, "Full Name"),
                  _text(emailCtrl, "Email"),
                  _text(phoneCtrl, "Phone Number", number: true),
                  _text(notesCtrl, "Notes", required: false),

                  const SizedBox(height: 24),

                  // ===== PROPERTIES =====
                  _sectionHeader("Assigned Properties"),
                  _selectAllTile(
                    title: "Select All Properties",
                    value: provider.isAllSelected,
                    onChanged: (v) => v
                        ? provider.selectAllProperties()
                        : provider.clearAllProperties(),
                  ),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: provider.properties.map((p) {
                      final id = p['_id'].toString();
                      final title = p['title'] ?? "Untitled";
                      final selected = provider.selectedPropertyIds.contains(
                        id,
                      );

                      return FilterChip(
                        label: Text(
                          title,
                          style: TextStyle(
                            color: selected ? Colors.white : colors.textPrimary,
                          ),
                        ),
                        selected: selected,
                        selectedColor: colors.primary,
                        onSelected: (_) => provider.toggleProperty(id),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ===== PERMISSIONS =====
                  _sectionHeader("Permissions"),
                  _selectAllTile(
                    title: "Select All Permissions",
                    value: provider.isAllPermissionsSelected,
                    onChanged: (v) => v
                        ? provider.selectAllPermissions()
                        : provider.clearAllPermissions(),
                  ),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: provider.permissions.map((p) {
                      final id = p['_id'].toString();
                      final name = p['name'];
                      final selected = provider.selectedPermissionIds.contains(
                        id,
                      );

                      return FilterChip(
                        label: Text(
                          name,
                          style: TextStyle(
                            color: selected ? Colors.white : colors.textPrimary,
                          ),
                        ),
                        selected: selected,
                        selectedColor: colors.primary,
                        onSelected: (_) => provider.togglePermission(id),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // ===== SAVE =====
                  PrimaryButton(
                    title: "UPDATE SUB OWNER",
                    onPressed: provider.loading ? null : _submit,
                  ),
                ],
              ),
            ),
    );
  }

  // ================= SUBMIT =================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<SubOwnerProvider>();

    final success = await provider.editSubOwner(
      subOwnerId: widget.subOwner['_id'],
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      notes: notesCtrl.text.trim(),
      hasFullPropertyAccess: provider.isAllSelected,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Sub-owner updated" : "Update failed"),
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
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: number ? TextInputType.number : TextInputType.text,
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

  Widget _selectAllTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      contentPadding: EdgeInsets.zero,
      activeColor: colors.primary,
    );
  }
}
