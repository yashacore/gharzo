import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/payments/create_payment_sceeen.dart';
import 'package:provider/provider.dart';

import 'package:gharzo_project/providers/landlord/payment_dashboard_provider.dart';
import 'package:gharzo_project/model/payment_model/payment_dashboard_model.dart';
import 'package:gharzo_project/screens/payments/payment_details_screen.dart';

import '../landloard/annoucment/announcement_list_screen.dart';

enum PaymentViewType { all, overdue, analytics }

class PaymentDashboardScreen extends StatefulWidget {
  const PaymentDashboardScreen({super.key});

  @override
  State<PaymentDashboardScreen> createState() =>
      _PaymentDashboardScreenState();
}

class _PaymentDashboardScreenState extends State<PaymentDashboardScreen> {
  PaymentViewType _viewType = PaymentViewType.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PaymentDashboardProvider>();
      provider.fetchPayments();
      provider.fetchOverduePayments();
      provider.fetchPaymentAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentDashboardProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Create",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GenerateRentPaymentScreen ()),
          );
        },
      ),

      appBar: CommonWidget.gradientAppBar(
        title: "Payment Overview",
        onPressed: () => Navigator.pop(context),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : Column(
        children: [
          _paymentToggle(provider),

          if (_viewType != PaymentViewType.analytics &&
              provider.stats != null)
            _summary(provider.stats!),

          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  // ================= BODY SWITCH =================

  Widget _buildBody(PaymentDashboardProvider provider) {
    if (_viewType == PaymentViewType.analytics) {
      return _analyticsView(provider);
    }

    final list = _viewType == PaymentViewType.overdue
        ? provider.overduePayments
        : provider.payments;

    if (list.isEmpty) return _emptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => _paymentCard(list[i]),
    );
  }

  // ================= TOGGLE =================

  Widget _paymentToggle(PaymentDashboardProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _toggleButton(
              'All',
              _viewType == PaymentViewType.all,
                  () => setState(() => _viewType = PaymentViewType.all),
            ),
            _toggleButton(
              'Overdue ₹${provider.totalOverdueAmount.toStringAsFixed(0)}',
              _viewType == PaymentViewType.overdue,
                  () => setState(() => _viewType = PaymentViewType.overdue),
            ),
            _toggleButton(
              'Analytics',
              _viewType == PaymentViewType.analytics,
                  () => setState(() => _viewType = PaymentViewType.analytics),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(
      String title, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= ANALYTICS VIEW =================

  Widget _analyticsView(PaymentDashboardProvider provider) {
    final analytics = provider.analytics;
    if (analytics == null) {
      return const Center(child: Text('No analytics available'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Revenue Analytics ${analytics.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${analytics.collectionRate.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const Text(
                        'Collection Rate',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// MONTHLY BARS
              ...analytics.monthlyData.map(_monthlyBar),

              const SizedBox(height: 20),

              /// STATS
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2,
                children: [
                  _statTile(
                      'Total Expected',
                      analytics.overallStats.totalExpected),
                  _statTile(
                      'Total Collected',
                      analytics.overallStats.totalCollected),
                  _statTile(
                      'Pending',
                      analytics.overallStats.totalPending),
                  _statTile(
                      'Avg Rent',
                      analytics.overallStats.averageRent),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _monthlyBar(MonthlyAnalytics m) {
    final percent =
    m.totalExpected == 0 ? 0 : m.totalCollected / m.totalExpected;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_monthName(m.month)),
              Text('₹${m.totalCollected} / ₹${m.totalExpected}'),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent.toDouble(),
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor:
              const AlwaysStoppedAnimation(Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PAYMENT CARD =================

  Widget _paymentCard(RentPayment payment) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentDetailsScreen(payment: payment),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(payment.tenant.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  _statusChip(payment.status),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₹${payment.amounts.finalAmount}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                    '${payment.billingPeriod.month}/${payment.billingPeriod.year}',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              const Divider(height: 24),
              _row('Payment No', payment.paymentNumber),
              _row('Property', payment.property.title),
              _row('Room', payment.room.roomNumber),
              _row(
                'Due Date',
                payment.dates.dueDate.toString().substring(0, 10),
              ),
              if (payment.amounts.lateFee > 0)
                Text(
                  'Late Fee: ₹${payment.amounts.lateFee}',
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _summary(PaymentStats stats) => Padding(
    padding: const EdgeInsets.all(16),
    child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _summaryTile('Total', stats.total, Colors.blue),
        _summaryTile('Pending', stats.pending, Colors.orange),
        _summaryTile('Overdue', stats.overdue, Colors.red),
        _summaryTile('Collected', stats.totalCollected, Colors.green),
      ],
    ),
  );

  Widget _summaryTile(String t, num v, Color c) => Container(
    padding: const EdgeInsets.all(14),
    decoration:
    BoxDecoration(color: c.withOpacity(.12), borderRadius: BorderRadius.circular(14)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(v.toString(),
          style:
          TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: c)),
      const SizedBox(height: 6),
      Text(t, style: TextStyle(color: c, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _statTile(String t, num v) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('₹${v.toStringAsFixed(0)}',
          style:
          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Text(t, style: const TextStyle(color: Colors.grey)),
    ]),
  );

  Widget _row(String t, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Expanded(flex: 3, child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600))),
      Expanded(flex: 5, child: Text(v)),
    ]),
  );

  Widget _statusChip(String s) {
    Color c = Colors.grey;
    if (s == 'Pending') c = Colors.orange;
    if (s == 'Paid') c = Colors.green;
    if (s == 'Overdue') c = Colors.red;
    return Chip(
      label: Text(s),
      backgroundColor: c.withOpacity(.15),
      labelStyle: TextStyle(color: c),
    );
  }

  Widget _emptyState() => const Center(
    child: Text('No payments found',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
  );

  String _monthName(int m) => const [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ][m];

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 12,
          offset: const Offset(0, 6))
    ],
  );
}