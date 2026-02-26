import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/data/property_api_service/visit_api_service.dart';
import 'package:gharzo_project/model/model/user_model/visit_details_model.dart';

class VisitDetailScreen extends StatefulWidget {
  final String visitId;
  const VisitDetailScreen({super.key, required this.visitId});

  @override
  State<VisitDetailScreen> createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  bool isLoading = true;
  VisitDetailModel? visit;
  final Color themeColor = const Color(
    0xFF2457D7,
  ); // Matching your primary blue
  bool _canRate(String status) {
    final s = status.toLowerCase();
    return s == "completed" || s == "no show";
  }

  @override
  void initState() {
    super.initState();
    loadVisit();
  }

  Future<void> loadVisit() async {
    visit = await VisitService.fetchVisitDetail(widget.visitId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: themeColor)),
      );
    }

    if (visit == null) {
      return const Scaffold(
        body: Center(
          child: Text("Visit not found", style: TextStyle(fontSize: 16)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Light modern background
      appBar: CommonWidget.gradientAppBar(
        title: "Visit Details",
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏠 PROPERTY CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderBadge(visit!.status),
                      Text(
                        "#${visit!.visitNumber}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    visit!.propertyTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        visit!.city,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            _sectionTitle("Visit Information"),
            const SizedBox(height: 10),

            // 📋 INFO GRID CONTAINER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                children: [
                  _infoRow(
                    "Scheduled Date",
                    visit!.preferredDate.toLocal().toString().split(' ')[0],
                    Icons.calendar_today,
                  ),
                  const Divider(height: 24),
                  _infoRow(
                    "Time Slot",
                    visit!.preferredTimeSlot,
                    Icons.access_time,
                  ),
                  const Divider(height: 24),
                  _infoRow(
                    "Visit Type",
                    visit!.visitType,
                    Icons.people_outline,
                  ),
                  const Divider(height: 24),
                  _infoRow(
                    "No. of Visitors",
                    visit!.numberOfVisitors.toString(),
                    Icons.groups_outlined,
                  ),
                  const Divider(height: 24),
                  _infoRow(
                    "Purpose",
                    visit!.purpose,
                    Icons.assignment_outlined,
                  ),
                ],
              ),
            ),

            // 💬 MESSAGE SECTION (Conditional)
            if (visit!.message.isNotEmpty) ...[
              const SizedBox(height: 25),
              _sectionTitle("Your Message"),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  visit!.message,
                  style: TextStyle(color: Colors.grey.shade800, height: 1.5),
                ),
              ),
            ],

            const SizedBox(height: 30),
            _sectionTitle("Visit Timeline"),
            const SizedBox(height: 15),

            // ⏳ TIMELINE LIST
            ...visit!.timeline.map((t) => _buildTimelineTile(t)),
            if (_canRate(visit!.status)) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.star_rate_rounded),
                  label: const Text("Rate Visit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => _showRateDialog(),
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.w800,
        color: Colors.grey.shade500,
        fontSize: 11,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: themeColor),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildHeaderBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimelineTile(dynamic t) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(width: 2, height: 40, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.status,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "${t.name} • ${t.timestamp.toLocal().toString().split('.')[0]}",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              if (t.notes.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  t.notes,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  void _showRateDialog() {
    int rating = 5;
    bool interestedInBuying = true;
    final reviewController = TextEditingController();

    final likedOptions = ["Location", "Amenities", "Price", "Connectivity"];
    final dislikedOptions = ["Price", "Noise", "Location"];

    final liked = <String>{};
    final disliked = <String>{};

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Rate Your Visit"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Rating"),
                  Row(
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () => setState(() => rating = i + 1),
                      );
                    }),
                  ),

                  const SizedBox(height: 10),
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Review",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text("What did you like?"),
                  Wrap(
                    spacing: 6,
                    children: likedOptions.map((e) {
                      return FilterChip(
                        label: Text(e),
                        selected: liked.contains(e),
                        onSelected: (v) =>
                            setState(() => v ? liked.add(e) : liked.remove(e)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),
                  const Text("What did you dislike?"),
                  Wrap(
                    spacing: 6,
                    children: dislikedOptions.map((e) {
                      return FilterChip(
                        label: Text(e),
                        selected: disliked.contains(e),
                        onSelected: (v) => setState(
                          () => v ? disliked.add(e) : disliked.remove(e),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: interestedInBuying,
                    title: const Text("Interested in buying / renting"),
                    onChanged: (v) => setState(() => interestedInBuying = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                onPressed: () async {
                  final success = await VisitService.rateVisit(
                    visitId: widget.visitId,
                    rating: rating,
                    review: reviewController.text.trim(),
                    liked: liked.toList(),
                    disliked: disliked.toList(),
                    interestedInBuying: interestedInBuying,
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? "Thank you for your feedback ⭐"
                            : "Failed to submit review",
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                },
                child: const Text("Submit"),
              ),
            ],
          );
        },
      ),
    );
  }
}
