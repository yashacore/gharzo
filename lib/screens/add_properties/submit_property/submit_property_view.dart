import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';

import 'submit_property_provider.dart';

class SubmitPropertyView extends StatelessWidget {
  final String propertyId;

  const SubmitPropertyView({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubmitPropertyProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.submitProperty,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Consumer<SubmitPropertyProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 80, color: Colors.green),
                  const SizedBox(height: 16),

                  const Text(
                    "Your property is ready!",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
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
                    Text(provider.error!,
                        style:
                        const TextStyle(color: Colors.red)),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: CommonWidget.commonElevatedBtn(
                      btnText: "Submit",
                      isLoading: provider.loading,
                      onPressed: provider.loading
                          ? null
                          : () async {
                        // Call submit function
                        final success = await provider.submit(propertyId);

                        if (success) {
                          // Show success dialog
                          _showSuccessDialog(context, provider.response);
                        } else {
                          // Error is already set in provider
                          if (provider.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(provider.error!)),
                            );
                          }
                        }
                      },
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSuccessDialog(
      BuildContext context,
      response,
      ) {
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
            Text(
                "Approval Time: ${response.estimatedApprovalTime}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .popUntil((route) => route.isFirst);
            },
            child: const Text("Go to Home"),
          ),
        ],
      ),
    );
  }
}
