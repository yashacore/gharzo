import 'package:flutter/material.dart';
import 'package:gharzo_project/providers/landlord/complaint_provider.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

final colors = AppThemeColors();

class LandlordComplaintsScreen extends StatefulWidget {
  const LandlordComplaintsScreen({super.key});

  @override
  State<LandlordComplaintsScreen> createState() =>
      _LandlordComplaintsScreenState();
}

class _LandlordComplaintsScreenState extends State<LandlordComplaintsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ComplaintDashboardProvider>().fetchLandlordComplaints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ComplaintDashboardProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaints"),
        backgroundColor: colors.textWhite,
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.complaints.isEmpty
          ? const Center(child: Text("No complaints found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: p.complaints.length,
              itemBuilder: (context, index) {
                final complaint = p.complaints[index];
                return _complaintCard(complaint);
              },
            ),
    );
  }

  // ================= COMPLAINT CARD =================

  Widget _complaintCard(dynamic c) {
    final tenant = c['tenantId'] ?? {};
    final property = c['propertyId'] ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.containerWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
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
            children: [_priorityChip(c['priority']), _statusChip(c['status'])],
          ),

          const SizedBox(height: 12),

          // ===== TITLE =====
          Text(
            c['title'] ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            c['description'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: colors.textGrey),
          ),

          const Divider(height: 28),

          // ===== DETAILS =====
          _infoRow(Icons.person_outline, tenant['name'] ?? ''),
          _infoRow(Icons.location_city_outlined, property['title'] ?? ''),
          _infoRow(
            Icons.confirmation_number_outlined,
            c['complaintNumber'] ?? '',
          ),

          const SizedBox(height: 14),

          // ===== FOOTER =====
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                c['category'] ?? '',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
              Text(
                _formatDate(c['createdAt']),
                style: TextStyle(fontSize: 12, color: colors.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colors.textGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: colors.textGrey)),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;

    switch (status) {
      case "Pending":
        color = Colors.orange;
        break;
      case "In Progress":
        color = Colors.blue;
        break;
      case "Completed":
        color = Colors.green;
        break;
      case "Resolved":
        color = Colors.teal;
        break;
      default:
        color = Colors.grey;
    }

    return _chip(status, color);
  }

  Widget _priorityChip(String priority) {
    Color color;

    switch (priority) {
      case "High":
        color = Colors.red;
        break;
      case "Medium":
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return _chip(priority, color);
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    final d = DateTime.tryParse(date);
    if (d == null) return '';
    return "${d.day}/${d.month}/${d.year}";
  }
}
