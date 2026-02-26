import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/landlord/announcement_provider.dart';
import 'package:gharzo_project/screens/landloard/annoucment/add_announcement_screen.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:intl/intl.dart';

final colors = AppThemeColors();

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({super.key});

  @override
  State<AnnouncementListScreen> createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AnnouncementProvider>().fetchAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnnouncementProvider>();

    return Scaffold(
      appBar: CommonWidget.gradientAppBar(
        title: "Announcements",
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: const Color(0xFFF4F7FA),
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
            MaterialPageRoute(builder: (_) => const AddAnnouncementScreen()),
          );
          if (created == true) provider.fetchAnnouncements();
        },
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.fetchAnnouncements(),
              child: CustomScrollView(
                slivers: [
                  // 1. Stats Section
                  SliverToBoxAdapter(child: _buildHeaderStats(provider)),

                  // 2. List Section
                  provider.announcements.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(child: Text("No announcements found")),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, i) =>
                                  _announcementCard(provider.announcements[i]),
                              childCount: provider.announcements.length,
                            ),
                          ),
                        ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
    );
  }

  // Quick stats summary at the top
  Widget _buildHeaderStats(AnnouncementProvider p) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _statItem("Total", p.announcements.length.toString(), Colors.blue),
          _statItem(
            "Scheduled",
            p.announcements
                .where((e) => e['status'] == 'Scheduled')
                .length
                .toString(),
            Colors.orange,
          ),
          _statItem(
            "Pinned",
            p.announcements
                .where((e) => e['isPinned'] == true)
                .length
                .toString(),
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _announcementCard(dynamic a) {
    final DateTime scheduledDate = DateTime.parse(a['scheduledFor']);
    final List targetProps = a['targetProperties'] ?? [];
    final List attachments = a['attachments'] ?? [];

    // Check if there is an image attachment to show
    String? imageUrl;
    if (attachments.isNotEmpty && attachments[0]['fileType'] == 'image') {
      imageUrl = attachments[0]['url'];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image Section
            if (imageUrl != null)
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _priorityBadge(a['priority']),
                  ),
                ],
              ),

            // Priority Strip (Only show if no image, otherwise it looks cluttered)
            if (imageUrl == null)
              Container(height: 4, color: _getPriorityColor(a['priority'])),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _statusBadge(a['status']),
                      const SizedBox(width: 8),
                      // Target Audience Indicator
                      _audienceBadge(a['targetAudience']),
                      const Spacer(),
                      if (a['isPinned'] == true)
                        const Icon(
                          Icons.push_pin,
                          color: Colors.orange,
                          size: 18,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    a['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a['message'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),

                  // Target Properties Tags
                  if (targetProps.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: targetProps
                          .map(
                            (p) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "#${p['title']}",
                                style: TextStyle(
                                  color: colors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM, hh:mm a').format(scheduledDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      // Stats
                      _miniStat(
                        Icons.people_alt_outlined,
                        "${a['stats']['totalRecipients'] ?? 0}",
                      ),
                      const SizedBox(width: 12),
                      _miniStat(
                        Icons.remove_red_eye_outlined,
                        "${a['stats']['totalReads'] ?? 0}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- New Modern Helper Widgets ---

  Widget _miniStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _audienceBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 4, backgroundColor: _getPriorityColor(priority)),
          const SizedBox(width: 6),
          Text(
            priority,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = status == "Scheduled" ? Colors.orange : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getPriorityColor(String p) {
    switch (p) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      default:
        return Colors.blueAccent;
    }
  }
}
