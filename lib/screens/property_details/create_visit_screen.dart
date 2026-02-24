import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/data/property_api_service/visit_api_service.dart';
import 'package:gharzo_project/screens/property_details/my_visit_screen.dart';

class CreateVisitScreen extends StatefulWidget {
  final String propertyId;

  const CreateVisitScreen({super.key, required this.propertyId});

  @override
  State<CreateVisitScreen> createState() => _CreateVisitScreenState();
}

class _CreateVisitScreenState extends State<CreateVisitScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController messageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String preferredTimeSlot = "Morning (9AM-12PM)";
  String visitType = "Physical";
  String purpose = "Rent";
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  int numberOfVisitors = 1;

  bool isLoading = false;

  Future<void> submitVisit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    Map<String, dynamic> data = {
      "propertyId": widget.propertyId,
      "preferredDate": "${selectedDate.toLocal()}".split(' ')[0],
      "preferredTimeSlot": preferredTimeSlot,
      "visitType": visitType,
      "numberOfVisitors": numberOfVisitors,
      "purpose": purpose,
      "message": messageController.text,
      "visitorDetails": [
        {
          "name": nameController.text,
          "relation": "Self",
          "phone": phoneController.text,
        },
      ],
    };

    /// 🔎 DEBUG PRINTS
    print("========== CREATE VISIT ==========");
    print("Payload: $data");

    bool success = await VisitService.createVisit(data);

    print("API Result: $success");
    print("==================================");

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // ⏱️ DISMISS AFTER 5 SECONDS
          duration: const Duration(seconds: 5),

          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20), // Deep emerald green
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // 🎊 Animated-style icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All set!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Visit created successfully 🎉",
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // ⚡ Action Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyVisitRequestsScreen(),
                      ),
                    );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyVisitsScreen()));
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "VIEW",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text("Failed to Create Visit ❌"),
        ),
      );
    }
  }

  Future<void> pickDate() async {
    final DateTime now = DateTime.now();

    // Tomorrow (removes time part)
    final DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);

    DateTime? picked = await showDatePicker(
      context: context,

      // initialDate must be >= firstDate
      initialDate: selectedDate.isBefore(tomorrow) ? tomorrow : selectedDate,

      // ❌ disables today & all previous dates
      firstDate: tomorrow,

      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      print("Selected Date: $selectedDate");
    }
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF2457D7);
    const accentColor = Color(0xFFE8EEFF);

    // Helper for consistent input styling
    InputDecoration modernDecoration(String label, IconData icon) =>
        InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: themeColor, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: themeColor, width: 2),
          ),
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF), // Soft designer white
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Schedule Visit",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: themeColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // 🗓️ DATE & TIME SECTION
            _buildSectionHeader("Visit Details"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    tileColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    leading: const Icon(
                      Icons.calendar_month,
                      color: themeColor,
                    ),
                    title: const Text(
                      "Selected Date",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    subtitle: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    trailing: const Icon(Icons.edit_calendar, size: 20),
                    onTap: pickDate,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    value: preferredTimeSlot,
                    decoration: modernDecoration(
                      "Preferred Time Slot",
                      Icons.access_time_rounded,
                    ),
                    items:
                        [
                              "Morning (9AM-12PM)",
                              "Afternoon (12PM-3PM)",
                              "Evening (3PM-6PM)",
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) =>
                        setState(() => preferredTimeSlot = val!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ⚙️ LOGISTICS SECTION
            _buildSectionHeader("Preferences"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: visitType,
                    decoration: modernDecoration(
                      "Type",
                      Icons.person_pin_circle,
                    ),
                    items: ["Physical", "Virtual"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setState(() => visitType = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: "1",
                    keyboardType: TextInputType.number,
                    decoration: modernDecoration("Visitors", Icons.groups),
                    onChanged: (val) =>
                        numberOfVisitors = int.tryParse(val) ?? 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: purpose,
              decoration: modernDecoration(
                "Purpose of Visit",
                Icons.assignment_outlined,
              ),
              items: [
                "Rent",
                "Buy",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => purpose = val!),
            ),

            const SizedBox(height: 24),

            // 👤 VISITOR DETAILS SECTION
            _buildSectionHeader("Your Information"),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameController,
              decoration: modernDecoration("Full Name", Icons.person_outline),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: modernDecoration("Phone Number", Icons.phone_android),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: messageController,
              maxLines: 2,
              decoration: modernDecoration(
                "Special Message (Optional)",
                Icons.chat_bubble_outline,
              ),
            ),

            const SizedBox(height: 40),
            PrimaryButton(
              title: "Submit",
              onPressed: isLoading ? null : submitVisit,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper for section titles
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: Colors.grey.shade600,
        letterSpacing: 1.2,
      ),
    );
  }
}
