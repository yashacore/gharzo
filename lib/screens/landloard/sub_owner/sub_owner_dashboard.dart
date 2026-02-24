import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/landlord/create_sub_owner_provider.dart';
import 'package:gharzo_project/screens/dashboard/dashboard_provider.dart';
import 'package:gharzo_project/screens/landloard/sub_owner/create_sub_owner_screen.dart';
import 'package:gharzo_project/screens/landloard/sub_owner/edit_sub_owner.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:gharzo_project/providers/landlord/sub_owner_dashboard_provider.dart';

final colors = AppThemeColors();

class SubOwnerDashboardScreen extends StatefulWidget {
  const SubOwnerDashboardScreen({super.key});

  @override
  State<SubOwnerDashboardScreen> createState() =>
      _SubOwnerDashboardScreenState();
}

class _SubOwnerDashboardScreenState extends State<SubOwnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SubOwnerDashboardProvider>().fetchSubOwners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubOwnerDashboardProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Create",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateSubOwnerScreen()),
          );
        },
      ),
      appBar: CommonWidget.gradientAppBar(
        title: "Sub Owners",
        onPressed: () => Navigator.pop(context),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.subOwners.isEmpty
          ? const Center(child: Text("No sub owners found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.subOwners.length,
              itemBuilder: (context, index) {
                final subOwner = provider.subOwners[index];
                return _subOwnerCard(subOwner);
              },
            ),
    );
  }

  // ================= CARD =================

  Widget _subOwnerCard(dynamic subOwner) {
    final String name = subOwner['name'] ?? "";
    final String email = subOwner['email'] ?? "";
    final String phone = subOwner['phone'] ?? "";
    final bool firstLogin = subOwner['firstLogin'] ?? false;
    final bool fullAccess = subOwner['hasFullPropertyAccess'] ?? false;

    final List properties = subOwner['assignedProperties'] ?? [];
    final List permissions = subOwner['permissions'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.containerWhite,
        borderRadius: BorderRadius.circular(16),
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
          // ===== HEADER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _statusChip(firstLogin ? "First Login" : "Active"),
            ],
          ),

          const SizedBox(height: 6),
          Text(email, style: TextStyle(color: colors.textGrey)),
          Text(phone, style: TextStyle(color: colors.textGrey)),

          const Divider(height: 28),

          // ===== PROPERTIES =====
          Text(
            "PROPERTIES (${properties.length})",
            style: TextStyle(
              color: colors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: properties.map<Widget>((p) {
              final String title = p['title'] ?? "Untitled";
              return _chip(title);
            }).toList(),
          ),

          const SizedBox(height: 16),

          // ===== PERMISSIONS =====
          Text(
            fullAccess
                ? "PERMISSIONS (ALL)"
                : "PERMISSIONS (${permissions.length})",
            style: TextStyle(
              color: colors.textGrey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          fullAccess
              ? _chip("All Permissions")
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: permissions.map<Widget>((p) {
                    final String name = p['name'];
                    return _chip(name);
                  }).toList(),
                ),
          const SizedBox(height: 16),

          // ===== ACTION BUTTONS =====

          // ===== ACTION BUTTONS =====
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _actionButton(
                  icon: Icons.security_outlined,
                  label: "Permissions",
                  color: colors.primary,
                  onTap: () {
                    _openEditPermissionDialog(context, subOwner);
                  },
                ),

                _actionButton(
                  icon: Icons.edit_outlined,
                  label: "Edit",
                  color: Colors.orange,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditSubOwnerScreen(subOwner: subOwner),
                      ),
                    );

                    // 🔥 REFRESH LIST AFTER RETURN
                    context.read<SubOwnerDashboardProvider>().fetchSubOwners();
                  },
                ),

                _actionButton(
                  icon: Icons.power_settings_new,
                  label: subOwner['status'] == "Active" ? "Disable" : "Enable",
                  color: subOwner['status'] == "Active"
                      ? Colors.red
                      : Colors.green,
                  onTap: () {
                    _confirmToggleStatus(context, subOwner);
                  },
                ),

                // 🔥 DELETE
                _actionButton(
                  icon: Icons.delete_outline,
                  label: "Delete",
                  color: Colors.redAccent,
                  onTap: () {
                    _confirmDeleteSubOwner(context, subOwner);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _statusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: label == "First Login"
            ? Colors.orange.withOpacity(0.15)
            : Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: label == "First Login" ? Colors.orange : Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _openEditPermissionDialog(BuildContext context, dynamic subOwner) async {
    final provider = context.read<SubOwnerDashboardProvider>();
    final String subOwnerId = subOwner['_id'];

    await provider.fetchAllPermissions();
    provider.initPermissionSelection(subOwner['permissions'] ?? []);

    showDialog(
      context: context,
      builder: (_) {
        return Consumer<SubOwnerDashboardProvider>(
          builder: (context, p, _) {
            return AlertDialog(
              title: const Text("Edit Permissions"),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Select all
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Give All Permissions"),
                        Switch(
                          value: p.isAllTempSelected,
                          onChanged: (v) {
                            v
                                ? p.selectAllTempPermissions()
                                : p.clearAllTempPermissions();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: p.allPermissions.map((perm) {
                            final code = perm['code'];
                            final name = perm['name'];
                            final selected = p.tempSelectedPermissionCodes
                                .contains(code);

                            return FilterChip(
                              label: Text(
                                name,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : colors.textPrimary,
                                ),
                              ),
                              selected: selected,
                              selectedColor: colors.primary,
                              checkmarkColor: Colors.white,
                              onSelected: (_) => p.toggleTempPermission(code),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: p.updatingPermissions
                      ? null
                      : () async {
                          final success = await p.updateSubOwnerPermissions(
                            subOwnerId: subOwnerId,
                          );

                          if (success) {
                            Navigator.pop(context);
                            p.fetchSubOwners(); // refresh list
                          }
                        },
                  child: p.updatingPermissions
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("SAVE"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmToggleStatus(BuildContext context, dynamic subOwner) {
    final bool isActive = subOwner['status'] == "Active";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isActive ? "Disable Sub Owner?" : "Enable Sub Owner?"),
        content: Text(
          isActive
              ? "This sub-owner will lose access immediately."
              : "This sub-owner will regain access.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? Colors.red : Colors.green,
            ),
            onPressed: () async {
              Navigator.pop(context);

              final subOwnerProvider = context.read<SubOwnerProvider>();

              final dashboardProvider = context
                  .read<SubOwnerDashboardProvider>();

              final success = await dashboardProvider.toggleSubOwnerStatus(
                subOwnerId: subOwner['_id'],
                makeActive: !isActive,
              );

              if (success) {
                // 🔥 REFRESH LIST
                dashboardProvider.fetchSubOwners();
              }
            },
            child: Text(isActive ? "Disable" : "Enable"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSubOwner(BuildContext context, dynamic subOwner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Sub Owner"),
        content: Text(
          "Are you sure you want to permanently delete "
          "${subOwner['name']}?\n\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              final success = await context
                  .read<SubOwnerProvider>()
                  .deleteSubOwner(subOwner['_id']);

              if (success) {
                context.read<SubOwnerDashboardProvider>().fetchSubOwners();
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
