import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/landlord/announcement_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:intl/intl.dart'; // Add this to your pubspec.yaml for cleaner dates

final colors = AppThemeColors();

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final msgCtrl = TextEditingController();

  String type = "General";
  String priority = "Medium";
  bool isPinned = true;
  bool visibleToLandlord = true;

  DateTime? scheduledFor;
  DateTime? expiresAt;
  File? attachment;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AnnouncementProvider>().fetchProperties();
    });
  }

  // ================= DATE PICKERS (Logic preserved) =================

  Future<DateTime?> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<DateTime?> _pickDate() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  // ================= ATTACHMENT (Logic preserved) =================

  Future<void> _pickAttachment() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;
    final ext = file.path.split('.').last.toLowerCase();
    const allowed = ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'];

    if (!allowed.contains(ext)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid file type"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => attachment = File(file.path));
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AnnouncementProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Subtle grey background
      appBar: CommonWidget.gradientAppBar(
        title: "New Announcements",
        onPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildCard(
              title: "Content",
              children: [
                _text(titleCtrl, "Title", Icons.title),
                const SizedBox(height: 16),
                _text(msgCtrl, "Message", Icons.message_outlined, maxLines: 4),
              ],
            ),

            _buildCard(
              title: "Audience",
              children: [
                DropdownButtonFormField<String>(
                  value: p.targetAudience,
                  items: const [
                    DropdownMenuItem(
                      value: "All Tenants",
                      child: Text("All Tenants"),
                    ),
                    DropdownMenuItem(
                      value: "Specific Properties",
                      child: Text("Specific Properties"),
                    ),
                  ],
                  onChanged: (v) {
                    p.targetAudience = v!;
                    p.clearPropertySelection();
                  },
                  decoration: _inputDecoration(
                    "Target Audience",
                    Icons.people_outline,
                  ),
                ),
                if (p.targetAudience == "Specific Properties") ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    children: p.properties.map((prop) {
                      final id = prop['_id'];
                      final title = prop['title'] ?? "Untitled";
                      final selected = p.selectedPropertyIds.contains(id);
                      return FilterChip(
                        label: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            color: selected ? Colors.white : Colors.black87,
                          ),
                        ),
                        selected: selected,
                        selectedColor: colors.primary,
                        onSelected: (_) => p.toggleProperty(id),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),

            _buildCard(
              title: "Scheduling",
              children: [
                _dateTile(
                  label: "Scheduled For",
                  value: scheduledFor,
                  icon: Icons.calendar_today_outlined,
                  onTap: () async {
                    final picked = await _pickDateTime();
                    if (picked != null) setState(() => scheduledFor = picked);
                  },
                ),
                const SizedBox(height: 12),
                _dateTile(
                  label: "Expires At",
                  value: expiresAt,
                  icon: Icons.timer_off_outlined,
                  onTap: () async {
                    final picked = await _pickDate();
                    if (picked != null) setState(() => expiresAt = picked);
                  },
                ),
              ],
            ),

            _buildCard(
              title: "Preferences",
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _dropdown("Type", type, [
                        "General",
                        "Urgent",
                      ], (v) => setState(() => type = v)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown("Priority", priority, [
                        "Low",
                        "Medium",
                        "High",
                      ], (v) => setState(() => priority = v)),
                    ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Pin to top"),
                  secondary: const Icon(Icons.push_pin_outlined),
                  value: isPinned,
                  activeColor: colors.primary,
                  onChanged: (v) => setState(() => isPinned = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Visibility to Landlord"),
                  secondary: const Icon(Icons.visibility_outlined),
                  value: visibleToLandlord,
                  activeColor: colors.primary,
                  onChanged: (v) => setState(() => visibleToLandlord = v),
                ),
              ],
            ),

            _buildCard(
              title: "Media",
              children: [
                if (attachment != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.description, color: Colors.blue),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            attachment!.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => attachment = null),
                          icon: const Icon(Icons.close, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                OutlinedButton.icon(
                  onPressed: _pickAttachment,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text("Upload Attachment"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: p.creating ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: p.creating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "POST ANNOUNCEMENT",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ================= STYLISH HELPERS =================

  void _submit() async {
    final p = context.read<AnnouncementProvider>();
    if (!_formKey.currentState!.validate()) return;
    if (scheduledFor == null || expiresAt == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Set dates first!")));
      return;
    }
    final success = await p.createAnnouncement(
      title: titleCtrl.text,
      message: msgCtrl.text,
      type: type,
      priority: priority,
      isPinned: isPinned,
      visibleToLandlord: visibleToLandlord,
      scheduledFor: scheduledFor!,
      expiresAt: expiresAt!,
      attachment: attachment,
    );
    if (success) Navigator.pop(context, true);
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: colors.primary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _text(
    TextEditingController c,
    String l,
    IconData icon, {
    int maxLines = 1,
  }) => TextFormField(
    controller: c,
    maxLines: maxLines,
    validator: (v) => v == null || v.isEmpty ? "Required" : null,
    decoration: _inputDecoration(l, icon),
  );

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v!),
      decoration: _inputDecoration(label, Icons.layers_outlined),
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: colors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    value == null
                        ? "Select Date"
                        : DateFormat('MMM dd, yyyy  •  hh:mm a').format(value),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.calendar_month, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
