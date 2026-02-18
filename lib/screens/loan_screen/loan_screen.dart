import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';

import '../../utils/theme/colors.dart';
import '../../common/common_widget/primary_button.dart';
import 'home_loan_enquiry_screen.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  double loanAmount = 5000000;
  double interest = 8.5;
  int tenure = 20;

  double get emi {
    final r = interest / 12 / 100;
    final n = tenure * 12;
    return (loanAmount * r * pow(1 + r, n)) /
        (pow(1 + r, n) - 1);
  }

  double get totalPayment => emi * tenure * 12;
  double get totalInterest => totalPayment - loanAmount;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors();

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: CommonWidget.gradientAppBar(
        title: "Home Loans",
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🏠 Intro Card
            _infoCard(),

            /// 📊 EMI Calculator
            _section(
              "EMI Calculator",
              [
                _slider(
                  "Loan Amount (₹)",
                  loanAmount,
                  500000,
                  10000000,
                      (v) => setState(() => loanAmount = v),
                ),
                _slider(
                  "Interest Rate (%)",
                  interest,
                  5,
                  15,
                      (v) => setState(() => interest = v),
                ),
                _slider(
                  "Tenure (Years)",
                  tenure.toDouble(),
                  5,
                  30,
                      (v) =>
                      setState(() => tenure = v.toInt()),
                ),
              ],
            ),

            /// 💰 EMI Result
            _emiCard(),

            /// 📈 Payment Breakdown
            _section(
              "Payment Breakdown",
              [
                _breakdownRow("Monthly EMI", emi),
                _breakdownRow(
                    "Total Interest", totalInterest),
                _breakdownRow(
                    "Total Payment", totalPayment),
              ],
            ),

            const SizedBox(height: 24),

            /// 🔘 Primary CTA → Next Screen
            PrimaryButton(
              title: "Apply for Home Loan",
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const HomeLoanEnquiryScreen(),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  /* ---------------- UI SECTIONS ---------------- */

  Widget _infoCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemeColors().primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Home Loan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Calculate EMI & apply for home loan at best interest rates.",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),
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
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _slider(
      String label,
      double value,
      double min,
      double max,
      ValueChanged<double> onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toStringAsFixed(0)}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _emiCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemeColors().primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Monthly EMI",
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            "₹${emi.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            "₹${value.toStringAsFixed(0)}",
            style:
            const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
