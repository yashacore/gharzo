import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/landloard/workers/add_worker_screen.dart';
import 'package:gharzo_project/screens/landloard/workers/edit_worker_screen.dart';
import 'package:gharzo_project/screens/landloard/workers/worker_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/providers/landlord/worker_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

final colors = AppThemeColors();

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WorkerProvider>().fetchWorkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<WorkerProvider>();

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
            MaterialPageRoute(builder: (_) => const AddWorkerScreen()),
          );

          if (created == true && mounted) {
            context.read<WorkerProvider>().fetchWorkers(); // 🔥 REFRESH
          }
        },
      ),
      appBar: CommonWidget.gradientAppBar(
        title: "Manage Workers",
        onPressed: () => Navigator.pop(context),
      ),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : p.workers.isEmpty
          ? const Center(child: Text("No workers found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: p.workers.length,
              itemBuilder: (context, index) {
                return _workerCard(p.workers[index]);
              },
            ),
    );
  }

  // ================= WORKER CARD =================

  Widget _workerCard(dynamic w) {
    final experience = w['experience'] ?? {};
    final emergency = w['emergencyContact'] ?? {};

    final bool isActive = w['status'] == "Active";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerDetailScreen(workerId: w['_id']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.containerWhite,
          borderRadius: BorderRadius.circular(18),
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
            // ================= CONTENT =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        w['name'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      _statusChip(isActive ? "Active" : "Inactive"),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    w['workerType'] ?? '',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Divider(height: 24),

                  _infoRow(Icons.phone, w['phone']),
                  _infoRow(Icons.email_outlined, w['email']),
                  _infoRow(
                    Icons.work_outline,
                    "${experience['years'] ?? 0} yrs experience",
                  ),

                  const SizedBox(height: 12),

                  // SPECIALIZATION
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (w['specialization'] ?? [])
                        .map<Widget>((s) => _chip(s.toString()))
                        .toList(),
                  ),

                  const Divider(height: 24),

                  // EMERGENCY
                  Text(
                    "Emergency Contact",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _infoRow(Icons.person_outline, emergency['name']),
                  _infoRow(Icons.phone_android, emergency['phone']),
                ],
              ),
            ),

            // ================= ACTION BAR =================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.04),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  // EDIT
                  _actionButton(
                    icon: Icons.edit_outlined,
                    label: "Edit",
                    color: Colors.orange,
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditWorkerScreen(worker: w),
                        ),
                      );

                      if (updated == true && context.mounted) {
                        context.read<WorkerProvider>().fetchWorkers();
                      }
                    },
                  ),

                  // ACTIVE / INACTIVE SWITCH
                  Expanded(
                    child: Column(
                      children: [
                        Switch(
                          value: w['status'] == "Active",
                          activeColor: colors.primary,
                          onChanged: (v) async {
                            final success = await context.read<WorkerProvider>().toggleWorkerStatus(
                              workerId: w['_id'],
                              status: v ? "Active" : "Inactive",
                            );

                            if (success && context.mounted) {
                              context.read<WorkerProvider>().fetchWorkers(); // 🔄 refresh list
                            }
                          },
                        ),
                        Text(
                          isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color:
                            isActive ? colors.success : colors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DELETE
                  _actionButton(
                    icon: Icons.delete_outline,
                    label: "Delete",
                    color: colors.error,
                    onTap: () {
                      _confirmDeleteWorker(context, w['_id']);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ================= HELPERS =================

  Widget _infoRow(IconData icon, String? text) {
    if (text == null || text.isEmpty) return const SizedBox();
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

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.primary,
        ),
      ),
    );
  }

  Widget _statusChip(String? status) {
    final isAvailable = status == "Available";
    final color = isAvailable ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status ?? '',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
  void _confirmDeleteWorker(BuildContext context, String workerId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Worker"),
        content: const Text(
          "Are you sure you want to permanently delete this worker?\n\n"
              "This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);

              final success =
              await context.read<WorkerProvider>().deleteWorker(workerId);

              if (success && context.mounted) {
                // 🔄 refresh list
                await context.read<WorkerProvider>().fetchWorkers();

                // ⬅ close detail page if needed
                // Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Worker deleted successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
