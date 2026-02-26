import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/providers/project_provider.dart';
import 'package:gharzo_project/screens/projects/add_project_review.dart';
import 'package:gharzo_project/screens/projects/image_slider.dart';
import 'package:gharzo_project/screens/projects/project_enquiry_screen.dart';
import 'package:gharzo_project/screens/projects/section_tile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final phone = "9876543210";

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProjectProvider>().fetchProjectDetail(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final theme = Theme.of(context);

    if (provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.error.isNotEmpty || provider.project == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(provider.error.isEmpty ? "Data unavailable" : provider.error)),
      );
    }

    final p = provider.project!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CommonWidget.gradientAppBar(
        title: p.name,
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with rounded bottom corners
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: ImageSlider(images: p.images),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.tagline,
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "₹${p.minPrice ~/ 100000}L - ₹${p.maxPrice ~/ 100000}L",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // New Add Review Button (Icon style for elegance)
                      Column(
                        children: [
                          IconButton.filledTonal(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) =>  ProjectReviewScreen(projectId: p.id)),
                              );
                              // Navigate to Add Review Screen
                            },
                            icon: const Icon(Icons.rate_review_outlined),
                          ),
                          const Text("Add Review", style: TextStyle(fontSize: 10))
                        ],
                      )
                    ],
                  ),

                  const Divider(height: 32),

                  // Description
                  const SectionTitle("About Project"),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: TextStyle(height: 1.5, color: Colors.grey[800]),
                  ),

                  const SizedBox(height: 24),

                  // Amenities (Grid-like Wrap)
                  const SectionTitle("Amenities"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: p.amenities.map((e) => _buildAmenityChip(e)).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Contact Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          icon: Icons.call_rounded,
                          label: "Call",
                          color: Colors.blue,
                          onTap: () => _launchUrl("tel:$phone"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: "WhatsApp",
                          color: const Color(0xFF25D366),
                          onTap: () => _launchUrl("https://wa.me/91$phone"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      // Sticky Bottom Navigation for primary action
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          child: PrimaryButton(
            title: "Request Project Enquiry",
            onPressed: () async{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProjectEnquiryScreen(projectId: p.id)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAmenityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _actionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}