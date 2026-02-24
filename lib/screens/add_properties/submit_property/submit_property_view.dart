import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/common/common_widget/progress_bar.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';

import 'submit_property_provider.dart';

class SubmitPropertyView extends StatefulWidget {
  final String propertyId;

  const SubmitPropertyView({super.key, required this.propertyId});

  @override
  State<SubmitPropertyView> createState() => _SubmitPropertyViewState();
}

class _SubmitPropertyViewState extends State<SubmitPropertyView> {
  late final SubmitPropertyProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = SubmitPropertyProvider();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.submitProperty,
          onPressed: () => Navigator.pop(context),
        ),
        body: Consumer<SubmitPropertyProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                PropertyProgressBar(
                  progress: 8 / 8, // 0.125
                  label: "Step 8 of 8 • Review & Submit",
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: Colors.green,
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Your property is ready!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Submit your property for admin approval. "
                        "Once approved, it will be visible to users.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),

                      const Spacer(),

                      if (provider.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            provider.error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      PrimaryButton(
                        title: provider.loading ? "Submitting..." : "Submit",
                        onPressed: provider.loading
                            ? null
                            : () async {
                                final success = await provider.submit(
                                  widget.propertyId,
                                );

                                if (!mounted) return;

                                if (success && provider.response != null) {
                                  _showSuccessDialog(
                                    context,
                                    provider.response!,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        provider.error ??
                                            "Submission failed. Please check all required fields.",
                                      ),
                                    ),
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Submitted Successfully 🎉"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Status: ${response.status}"),
            const SizedBox(height: 6),
            Text("Approval Time: ${response.estimatedApprovalTime}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const BottomBarView()),
                (route) => false,
              );
            },
            child: const Text("Go to Home"),
          ),
        ],
      ),
    );
  }
}
