import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/providers/landlord/worker_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

final colors = AppThemeColors();

class WorkerDetailScreen extends StatefulWidget {
  final String workerId;
  const WorkerDetailScreen({super.key, required this.workerId});

  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  Map<String, dynamic>? worker;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await context.read<WorkerProvider>().fetchWorkerDetail(widget.workerId);
    setState(() {
      worker = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (worker == null) return const Scaffold(body: Center(child: Text("Worker not found")));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: CommonWidget.gradientAppBar(
        title: "Worker Details",
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildHeroHeader(),
            const SizedBox(height: 24),
            _buildStatsGrid(),
            const SizedBox(height: 24),
            _buildDetailSection(
              title: "Professional Summary",
              icon: Icons.badge_outlined,
              child: Column(
                children: [
                  _infoRow("Category", worker!['workerType']),
                  _infoRow("Experience", "${worker!['experience']['years']} Years"),
                  _infoRow("Status", worker!['availability']['status'], isStatus: true),
                ],
              ),
            ),
            _buildDetailSection(
              title: "Specialization",
              icon: Icons.star_border_rounded,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (worker!['specialization'] as List).map((e) => _buildModernChip(e.toString())).toList(),
              ),
            ),
            _buildDetailSection(
              title: "Availability",
              icon: Icons.calendar_today_outlined,
              child: Column(
                children: [
                  _infoRow("Hours", "${worker!['availability']['workingHours']['from']} - ${worker!['availability']['workingHours']['to']}"),
                  _infoRow("Days", (worker!['availability']['workingDays'] as List).join(", ")),
                ],
              ),
            ),
            _buildDetailSection(
              title: "Assigned Properties",
              icon: Icons.domain_outlined,
              child: worker!['assignedProperties'].isEmpty
                  ? const Text("No properties assigned", style: TextStyle(color: Colors.grey))
                  : Column(
                children: worker!['assignedProperties'].map<Widget>((p) => _buildPropertyTile(p)).toList(),
              ),
            ),
            _buildDetailSection(
              title: "Emergency Contact",
              icon: Icons.contact_emergency_outlined,
              child: Column(
                children: [
                  _infoRow("Name", worker!['emergencyContact']['name']),
                  _infoRow("Phone", worker!['emergencyContact']['phone']),
                  _infoRow("Relation", worker!['emergencyContact']['relation']),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colors.primary.withOpacity(0.2), width: 2)),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: colors.primary.withOpacity(0.1),
              child: Icon(Icons.person_rounded, color: colors.primary, size: 40),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(worker!['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                const SizedBox(height: 4),
                Text(worker!['phone'], style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                Text(worker!['email'], style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = worker!['stats'];
    return Row(
      children: [
        _statCard("Rating", stats['averageRating'].toString(), Icons.star_rounded, Colors.orange),
        const SizedBox(width: 12),
        _statCard("Total Tasks", stats['totalAssigned'].toString(), Icons.assignment_rounded, Colors.blue),
        const SizedBox(width: 12),
        _statCard("Completed", stats['totalCompleted'].toString(), Icons.check_circle_rounded, Colors.green),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Text(title.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey.shade400, letterSpacing: 1.1)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          isStatus ? _buildStatusBadge(value) : Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isAvailable = status.toLowerCase() == 'available';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(color: isAvailable ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildModernChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF0F4F8), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: colors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildPropertyTile(dynamic p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Text(p['title'] ?? "Untitled", style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}