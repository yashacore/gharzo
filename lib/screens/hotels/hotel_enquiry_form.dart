import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/providers/hotel_provider.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:provider/provider.dart';

class HotelEnquiryScreen extends StatefulWidget {
  final String hotelId;
  const HotelEnquiryScreen({super.key, required this.hotelId});

  @override
  State<HotelEnquiryScreen> createState() => _HotelEnquiryScreenState();
}

class _HotelEnquiryScreenState extends State<HotelEnquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final roomsCtrl = TextEditingController(text: "1");
  final adultsCtrl = TextEditingController(text: "2");
  final childrenCtrl = TextEditingController(text: "0");
  final messageCtrl = TextEditingController();

  DateTime? checkIn;
  DateTime? checkOut;
  String roomType = "Deluxe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: CommonWidget.gradientAppBar(
        title: "Hotel Enquiry",
        onPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _section("Guest Details"),
              _field(nameCtrl, "Full Name"),
              _field(phoneCtrl, "Phone", keyboard: TextInputType.phone),
              _field(emailCtrl, "Email", keyboard: TextInputType.emailAddress),

              const SizedBox(height: 16),
              _section("Stay Details"),
              _datePicker("Check-in Date", checkIn, (d) => setState(() => checkIn = d)),
              _datePicker("Check-out Date", checkOut, (d) => setState(() => checkOut = d)),

              _field(roomsCtrl, "Rooms", keyboard: TextInputType.number),
              _field(adultsCtrl, "Adults", keyboard: TextInputType.number),
              _field(childrenCtrl, "Children", keyboard: TextInputType.number),

              _dropdown(),

              const SizedBox(height: 16),
              _section("Message"),
              _messageField(),

              const SizedBox(height: 30),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Consumer<HotelProvider>(
      builder: (_, provider, __) {
        return PrimaryButton(
          title: "Send Enquiry",
          onPressed: () async {
            await _submit();
          },
        );

      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        checkIn == null ||
        checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final payload = {
      "name": nameCtrl.text,
      "phone": phoneCtrl.text,
      "email": emailCtrl.text,
      "hotelDetails": {
        "checkIn": checkIn!.toIso8601String(),
        "checkOut": checkOut!.toIso8601String(),
        "rooms": int.parse(roomsCtrl.text),
        "adults": int.parse(adultsCtrl.text),
        "children": int.parse(childrenCtrl.text),
        "roomPreference": roomType,
      },
      "message": messageCtrl.text,
    };

    final success = await context
        .read<HotelProvider>()
        .submitEnquiry(
      hotelId: widget.hotelId,
      data: payload,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enquiry sent successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // ✅ Replace stack (BEST PRACTICE)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => BottomBarView()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ---------------- UI helpers ----------------

  Widget _section(String title) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ),
  );

  Widget _field(TextEditingController c, String label,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboard,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: _inputDecoration(label),
      ),
    );
  }

  Widget _messageField() {
    return TextFormField(
      controller: messageCtrl,
      maxLines: 4,
      decoration: _inputDecoration("Message"),
    );
  }

  Widget _dropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: roomType,
        items: ["Deluxe", "Super Deluxe", "Suite"]
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => roomType = v!),
        decoration: _inputDecoration("Room Preference"),
      ),
    );
  }

  Widget _datePicker(String label, DateTime? value, Function(DateTime) onPick) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
          initialDate: DateTime.now(),
        );
        if (date != null) onPick(date);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: _box(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            Text(
              value == null
                  ? "Select"
                  : "${value.day}-${value.month}-${value.year}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

