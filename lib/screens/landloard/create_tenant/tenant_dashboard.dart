import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/landlord/tenancy_dashboard_provider.dart';
import 'package:gharzo_project/screens/landloard/create_tenant/create_tenancy_screen.dart';
import 'package:gharzo_project/screens/landloard/create_tenant/update_tenant_screen.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

final colors = AppThemeColors();

class TenantDashboardScreen extends StatefulWidget {
  const TenantDashboardScreen({super.key});

  @override
  State<TenantDashboardScreen> createState() => _TenantDashboardScreenState();
}

class _TenantDashboardScreenState extends State<TenantDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TenancyDashboardProvider>().fetchTenancies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TenancyDashboardProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Create",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTenancyScreen()),
          );
        },
      ),

      appBar: CommonWidget.gradientAppBar(
        title: "Tenant Hub",
        onPressed: () => Navigator.pop(context),
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.tenancies.isEmpty
          ? const Center(child: Text("No tenancies found"))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _header(p),
                const SizedBox(height: 16),
                ...p.tenancies.map(_tenancyCard).toList(),
              ],
            ),
    );
  }

  // ================= HEADER =================

  Widget _header(TenancyDashboardProvider p) {
    final tenantName = p.tenancies.first.tenant.name;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: colors.primary,
            child: Text(
              tenantName.isNotEmpty ? tenantName[0].toUpperCase() : "?",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tenantName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              Text("Welcome back 👋", style: TextStyle(color: colors.textGrey)),
            ],
          ),
        ],
      ),
    );
  }

  // ================= TENANCY CARD =================

  Widget _tenancyCard(tenancy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 2, right: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Section with Status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.home_work_rounded, color: colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tenancy.property.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        tenancy.property.city,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusChip(tenancy.status),
              ],
            ),
          ),

          // 2. Room Information Ribbon
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.meeting_room_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  "Room ${tenancy.room.roomNumber}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  tenancy.room.roomType,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),

          // 3. Financials Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _financeInfo(
                  "Monthly Rent",
                  "₹${tenancy.financials.monthlyRent}",
                  Colors.green,
                ),
                const SizedBox(width: 12),
                _financeInfo(
                  "Security Deposit",
                  "₹${tenancy.financials.securityDeposit}",
                  Colors.blueGrey,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 4. Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTenancyScreen(tenancy: tenancy),
                      ),
                    );
                    if (updated == true) {
                      context.read<TenancyDashboardProvider>().fetchTenancies();
                    }
                  },
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  label: const Text("Edit"),
                  style: TextButton.styleFrom(foregroundColor: Colors.blueGrey),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _openRejectDialog(context, tenancy.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modern Financial Info Helper
  Widget _financeInfo(String label, String value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Stylish Status Chip Helper
  Widget _statusChip(String status) {
    Color statusColor = status.toLowerCase() == 'active'
        ? Colors.green
        : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _openRejectDialog(BuildContext context, String tenancyId) {
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reject Tenancy"),
        content: TextField(
          controller: reasonCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: "Reason",
            hintText: "Enter rejection reason",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (reasonCtrl.text.trim().isEmpty) return;

              final success = await context
                  .read<TenancyDashboardProvider>()
                  .rejectTenancy(
                    tenancyId: tenancyId,
                    reason: reasonCtrl.text.trim(),
                  );

              Navigator.pop(context);

              if (success) {
                context.read<TenancyDashboardProvider>().fetchTenancies();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Tenancy rejected"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("REJECT"),
          ),
        ],
      ),
    );
  }
}
