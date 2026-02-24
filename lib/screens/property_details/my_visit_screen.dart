import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/data/property_api_service/visit_api_service.dart';
import 'package:gharzo_project/model/model/my_visit_model.dart';
import 'package:gharzo_project/providers/visit_provider.dart';
import 'package:gharzo_project/screens/property_details/visit_details_screen.dart'
    show VisitDetailScreen;
import 'package:provider/provider.dart';

class MyVisitRequestsScreen extends StatefulWidget {
  const MyVisitRequestsScreen({super.key});

  @override
  State<MyVisitRequestsScreen> createState() => _MyVisitRequestsScreenState();
}

class _MyVisitRequestsScreenState extends State<MyVisitRequestsScreen> {
  // Use the same theme color from your previous screen for consistency
  final themeColor = const Color(0xFF2457D7);
  bool _canCancel(String status) {
    final s = status.toLowerCase();
    return s == 'pending' || s == 'confirmed';
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      debugPrint("🟢 MyVisitRequestsScreen initState → loadMyVisits()");
      context.read<MyVisitProvider>().loadMyVisits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: CommonWidget.gradientAppBar(
        title: "My Visit Requests",
        onPressed: () => Navigator.pop(context),
      ),
      body: Consumer<MyVisitProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: themeColor));
          }

          if (provider.visits.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.visits.length,
            itemBuilder: (context, index) => _visitCard(provider.visits[index]),
          );
        },
      ),
    );
  }

  Widget _visitCard(MyVisit visit) {
    // Logic for status colors
    Color statusColor;
    switch (visit.status.toLowerCase()) {
      case 'confirmed':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = themeColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VisitDetailScreen(visitId: visit.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP ROW: Property Title & Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visit.propertyTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              visit.city,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(visit.status, statusColor),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, thickness: 0.5),
              ),

              // BOTTOM ROW: Date & Time Info
              Row(
                children: [
                  _infoTile(
                    Icons.calendar_today_outlined,
                    visit.preferredDate.toLocal().toString().split(' ')[0],
                  ),
                  const SizedBox(width: 20),
                  _infoTile(Icons.access_time_rounded, visit.preferredTimeSlot),
                ],
              ),

              const SizedBox(height: 16),

              // FOOTER: ID & Arrow
              // FOOTER: ID, Cancel & Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ID: ${visit.visitNumber}",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Row(
                    children: [
                      if (_canCancel(visit.status))
                        _cancelButton(onTap: () => _showCancelDialog(visit)),

                      const SizedBox(width: 8),

                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Stylish status badge
  Widget _buildStatusChip(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // Small helper for icon+text details
  Widget _infoTile(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: themeColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            "No visits scheduled yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your scheduled property visits will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _cancelButton({required VoidCallback onTap}) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.cancel_outlined, size: 18),
      label: const Text("Cancel"),
      style: TextButton.styleFrom(
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  void _showCancelDialog(MyVisit visit) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Visit"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Enter cancellation reason",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;

              final success = await VisitService.cancelVisit(
                visitId: visit.id,
                reason: controller.text.trim(),
              );

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? "Visit cancelled successfully"
                        : "Failed to cancel visit",
                  ),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );

              if (success) {
                context.read<MyVisitProvider>().loadMyVisits();
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
