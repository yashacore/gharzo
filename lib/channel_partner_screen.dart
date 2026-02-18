import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/screens/channel_partner_form.dart';

class ChannelPartnerScreen extends StatelessWidget {
  const ChannelPartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(title: "Add Channel Partner", onPressed: () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChannelPartnerFormView(
                    ),
              ),
            )),
      ),
      backgroundColor: const Color(0xffF5F6FA),
      appBar: CommonWidget.gradientAppBar(
        title: "Channel Partner",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Advantages of Working Together",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _advantageCard(
              icon: Icons.shield_outlined,
              title: "Risk Sharing",
              subtitle:
              "Operating individually in real estate is risky. Working together reduces responsibility and risk.",
            ),
            _advantageCard(
              icon: Icons.lightbulb_outline,
              title: "Knowledge Sharing",
              subtitle:
              "Share expertise, insights, and industry experience with our professional team.",
            ),
            _advantageCard(
              icon: Icons.groups_outlined,
              title: "Exclusive Working on Projects",
              subtitle:
              "Dedicated focus and priority access to premium projects.",
            ),
            _advantageCard(
              icon: Icons.campaign_outlined,
              title: "Media Buying Expertise",
              subtitle:
              "Access to advanced marketing strategies and lead generation.",
            ),
            _advantageCard(
              icon: Icons.payments_outlined,
              title: "Prompt Payments",
              subtitle:
              "Timely commission payouts and transparent accounting.",
            ),
            _advantageCard(
              icon: Icons.support_agent_outlined,
              title: "Unparalleled Customer Service",
              subtitle:
              "Best-in-class support for partners and customers.",
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------------- UI SECTIONS ----------------


  Widget _advantageCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
