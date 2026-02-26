import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/model/model/user_model/project_review_model.dart';
import 'package:gharzo_project/providers/project_provider.dart';
import 'package:provider/provider.dart';

class ProjectReviewScreen extends StatefulWidget {
  final String projectId;
  const ProjectReviewScreen({super.key, required this.projectId});

  @override
  State<ProjectReviewScreen> createState() => _ProjectReviewScreenState();
}

class _ProjectReviewScreenState extends State<ProjectReviewScreen> {
  final _formKey = GlobalKey<FormState>();

  int rating = 5;
  final reviewCtrl = TextEditingController();
  final prosCtrl = TextEditingController();
  final consCtrl = TextEditingController();

  String reviewType = "Buyer";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CommonWidget.gradientAppBar(
        title: "Write a review",
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Rating Section ---
              _buildSectionCard(
                child: Column(
                  children: [
                    const Text(
                      "How was your experience?",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    _starRatingBar(),
                    const SizedBox(height: 8),
                    Text(
                      _getRatingText(),
                      style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Review Details ---
              _buildSectionCard(
                child: Column(
                  children: [
                    _dropdown(
                      "I am a...",
                      reviewType,
                      ["Buyer", "Investor", "Tenant"],
                          (v) => setState(() => reviewType = v),
                    ),
                    _field(reviewCtrl, "Your Detailed Review", Icons.rate_review_outlined, maxLines: 4),
                    _field(prosCtrl, "Pros (e.g. Great Location, Parking)", Icons.add_circle_outline, helper: "Separate pros with commas"),
                    _field(consCtrl, "Cons (e.g. Traffic, High Maintenance)", Icons.remove_circle_outline, helper: "Separate cons with commas"),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              if (provider.error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Center(child: Text(provider.error, style: const TextStyle(color: Colors.red))),
                ),

              provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                title: "Submit Review",
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _starRatingBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => setState(() => rating = index + 1),
          icon: Icon(
            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: Colors.amber,
            size: 40,
          ),
        );
      }),
    );
  }

  String _getRatingText() {
    switch (rating) {
      case 1: return "Poor";
      case 2: return "Fair";
      case 3: return "Good";
      case 4: return "Very Good";
      case 5: return "Excellent";
      default: return "";
    }
  }

  Widget _field(TextEditingController c, String label, IconData icon, {int maxLines = 1, String? helper}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20),
          labelText: label,
          helperText: helper,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  // --- LOGIC ---

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = ProjectReviewRequest(
      rating: rating,
      review: reviewCtrl.text.trim(),
      pros: prosCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      cons: consCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      reviewType: reviewType,
    );

    final provider = context.read<ProjectProvider>();
    await provider.createReview(widget.projectId, request);

    if (!mounted) return;

    if (provider.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted successfully!")),
      );
      Navigator.pop(context);
    }
  }
}