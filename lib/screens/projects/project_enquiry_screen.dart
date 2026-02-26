import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/providers/project_provider.dart';
import 'package:gharzo_project/screens/projects/project_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/model/model/user_model/project_enquiry_model.dart';

class ProjectEnquiryScreen extends StatefulWidget {
  final String projectId;
  const ProjectEnquiryScreen({super.key, required this.projectId});

  @override
  State<ProjectEnquiryScreen> createState() => _ProjectEnquiryScreenState();
}

class _ProjectEnquiryScreenState extends State<ProjectEnquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final messageCtrl = TextEditingController();
  final minBudgetCtrl = TextEditingController();
  final maxBudgetCtrl = TextEditingController();

  // State Variables
  String config = "3 BHK";
  String purpose = "Self Use";
  String contact = "WhatsApp";
  String timeSlot = "Evening (5PM-9PM)";
  bool siteVisit = false;
  DateTime? selectedDate;
  String? selectedVisitTime;
  int peopleCount = 1;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final theme = Theme.of(context);

    if (provider.success) return _successView();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CommonWidget.gradientAppBar(
        title: "Project Enquiry",
        onPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader("Personal Information", Icons.person_outline),
              _buildCard([
                _field(nameCtrl, "Full Name", Icons.badge_outlined),
                _field(phoneCtrl, "Phone Number", Icons.phone_android_outlined, isPhone: true),
                _field(emailCtrl, "Email Address (Optional)", Icons.alternate_email_outlined),
              ]),

              _sectionHeader("Requirement Details", Icons.home_work_outlined),
              _buildCard([
                _label("Select Configuration"),
                _chipSelector(["2 BHK", "3 BHK", "4 BHK"], config, (v) => setState(() => config = v)),
                const SizedBox(height: 16),
                _label("Buying Purpose"),
                _chipSelector(["Self Use", "Investment", "Rental"], purpose, (v) => setState(() => purpose = v)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _field(minBudgetCtrl, "Min Budget", Icons.remove, isNumber: true)),
                    const SizedBox(width: 12),
                    Expanded(child: _field(maxBudgetCtrl, "Max Budget", Icons.add, isNumber: true)),
                  ],
                ),
              ]),

              _sectionHeader("Preferences", Icons.tune_rounded),
              _buildCard([
                _dropdown("Preferred Contact", contact, ["Phone", "WhatsApp", "Email", "Any"], (v) => setState(() => contact = v)),
                _dropdown("Best Time to Call", timeSlot, ["Morning (9AM-12PM)", "Afternoon (12PM-5PM)", "Evening (5PM-9PM)", "Anytime"], (v) => setState(() => timeSlot = v)),
                _field(messageCtrl, "Add a message...", Icons.notes, max: 3),
              ]),

              // Modern Site Visit Toggle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: siteVisit ? Colors.indigo.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: siteVisit ? Colors.indigo : Colors.transparent),
                ),
                child: SwitchListTile(
                  secondary: Icon(Icons.directions_car_filled_outlined, color: siteVisit ? Colors.indigo : Colors.grey),
                  title: const Text("Request a Site Visit", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Schedule a physical tour of the property"),
                  value: siteVisit,
                  onChanged: (v) => setState(() => siteVisit = v),
                ),
              ),

              if (siteVisit) _buildSiteVisitDetails(),

              const SizedBox(height: 32),

              provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                  title: "Submit Enquiry",
                  onPressed: _submit
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500))),
    );
  }

  Widget _chipSelector(List<String> options, String selected, Function(String) onSelect) {
    return Wrap(
      spacing: 8,
      children: options.map((option) {
        final isSelected = selected == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) => onSelect(option),
          selectedColor: Colors.indigo,
          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon, {int max = 1, bool isPhone = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        maxLines: max,
        keyboardType: isPhone ? TextInputType.phone : isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isPhone || isNumber ? [FilteringTextInputFormatter.digitsOnly, if (isPhone) LengthLimitingTextInputFormatter(10)] : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20),
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  Widget _buildSiteVisitDetails() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: _buildCard([
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_month, color: Colors.indigo),
              title: Text(selectedDate == null ? "Select Visit Date" : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: _pickDate,
            ),
            const Divider(),
            _dropdown("Preferred Time", selectedVisitTime ?? "Morning (9AM-12PM)", ["Morning (9AM-12PM)", "Afternoon (12PM-5PM)", "Evening (5PM-9PM)"], (v) => setState(() => selectedVisitTime = v)),
            _dropdown("Number of People", peopleCount.toString(), ["1", "2", "3", "4", "5+"], (v) => setState(() => peopleCount = int.parse(v[0]))),
          ]),
        );
      },
    );
  }

  // --- LOGIC ---

  Future<void> _submit() async {
    if (nameCtrl.text.isEmpty || phoneCtrl.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in valid contact details")));
      return;
    }

    final request = ProjectEnquiryRequest(
      projectId: widget.projectId,
      name: nameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.isEmpty ? null : emailCtrl.text.trim(),
      configurationType: config,
      budgetMin: int.tryParse(minBudgetCtrl.text),
      budgetMax: int.tryParse(maxBudgetCtrl.text),
      purposeOfBuying: purpose,
      message: messageCtrl.text.trim(),
      preferredContactMethod: contact,
      preferredTimeSlot: timeSlot,
      siteVisitRequested: siteVisit,
      preferredDate: selectedDate,
      preferredTime: selectedVisitTime,
      numberOfPeople: peopleCount,
    );

    await context.read<ProjectProvider>().createEnquiry(request, context);
    if (mounted && context.read<ProjectProvider>().success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProjectListScreen()));
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Widget _successView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text("Enquiry Sent!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("The developer will contact you shortly.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Back to Project")),
          ],
        ),
      ),
    );
  }
}