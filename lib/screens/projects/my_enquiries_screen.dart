import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/user_model/my_enquiry_model.dart';
import 'package:gharzo_project/providers/project_provider.dart';
import 'package:provider/provider.dart';

class MyEnquiriesScreen extends StatefulWidget {
  const MyEnquiriesScreen({super.key});

  @override
  State<MyEnquiriesScreen> createState() => _MyEnquiriesScreenState();
}

class _MyEnquiriesScreenState extends State<MyEnquiriesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProjectProvider>().fetchMyEnquiries());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Enquiries")),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(ProjectProvider provider) {
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty) {
      return Center(child: Text(provider.error));
    }

    if (provider.myEnquiries.isEmpty) {
      return const Center(child: Text("No enquiries found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.myEnquiries.length,
      itemBuilder: (context, index) {
        return _enquiryCard(provider.myEnquiries[index]);
      },
    );
  }

  Widget _enquiryCard(MyEnquiryModel e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Enquiry No", e.enquiryNumber),
          _row("Project", e.projectName),
          _row("Developer", e.developerName),
          _row("Configuration", e.configuration),
          _row(
            "Budget",
            "₹${e.budgetMin ~/ 100000}L - ₹${e.budgetMax ~/ 100000}L",
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _statusChip(e.status),
              const SizedBox(width: 8),
              _priorityChip(e.priority),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Created: ${e.createdAt.toLocal().toString().split(' ').first}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    return Chip(
      label: Text(status),
      backgroundColor: Colors.blue.shade100,
    );
  }

  Widget _priorityChip(String priority) {
    return Chip(
      label: Text(priority),
      backgroundColor: Colors.orange.shade100,
    );
  }
}