import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gharzo_project/data/landlord/landlord_api_service.dart';

// Assuming your AppThemeColors is available globally or injected
final colors = AppThemeColors();

class CreateRoomScreen extends StatefulWidget {
  final String propertyId;
  const CreateRoomScreen({super.key, required this.propertyId});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final roomNumberCtrl = TextEditingController();
  final floorCtrl = TextEditingController();
  final totalBedsCtrl = TextEditingController();
  final carpetCtrl = TextEditingController();
  final rentPerRoomCtrl = TextEditingController();
  final rentPerBedCtrl = TextEditingController();
  final depositCtrl = TextEditingController();
  final maintenanceCtrl = TextEditingController();
  final noticeCtrl = TextEditingController(text: "30");
  final lockInCtrl = TextEditingController(text: "0");

  // State Variables
  String roomType = "Single";
  String furnishing = "Unfurnished";
  String availabilityStatus = "Available";
  String genderPreference = "Any";
  String foodType = "Both";
  String electricityCharges = "Extra";
  String waterCharges = "Included";
  String areaUnit = "sqft";

  bool attachedBath = false;
  bool balcony = false;
  bool ac = false;
  bool wardrobe = false;
  bool fridge = false;
  bool smoking = false;
  bool pets = false;
  bool guests = true;
  bool maintenanceIncluded = false;

  final List<String> amenitiesList = [
    "WiFi",
    "Study Table",
    "Chair",
    "Bed",
    "Mattress",
    "Washing Machine",
    "Geyser",
    "TV",
    "Sofa",
    "Power Backup",
    "CCTV",
    "Parking",
    "Lift",
  ];
  final Set<String> selectedAmenities = {};

  File? roomImage;
  DateTime availableFrom = DateTime.now().add(const Duration(days: 1));
  bool isLoading = false;

  // Image & Date Pickers (Logically the same as your code)
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => roomImage = File(picked.path));
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: availableFrom,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: colors.primary)),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => availableFrom = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF), // Subtle cool background
      appBar: CommonWidget.gradientAppBar(
        title: "Add New Room",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageHeader(),
              const SizedBox(height: 25),

              _sectionTitle("General Information", Icons.info_outline),
              _buildCard([
                _text(
                  roomNumberCtrl,
                  "Room Number",
                  Icons.door_front_door_outlined,
                ),
                _dropdown("Room Type", roomType, [
                  "Single",
                  "Double Sharing",
                  "Triple Sharing",
                  "Dormitory",
                  "1 BHK",
                ], (v) => setState(() => roomType = v!)),
                Row(
                  children: [
                    Expanded(
                      child: _text(
                        floorCtrl,
                        "Floor",
                        Icons.layers_outlined,
                        number: true,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _text(
                        totalBedsCtrl,
                        "Total Beds",
                        Icons.bed_outlined,
                        number: true,
                      ),
                    ),
                  ],
                ),
              ]),

              const SizedBox(height: 25),
              _sectionTitle("Pricing & Area", Icons.payments_outlined),
              _buildCard([
                _text(
                  rentPerRoomCtrl,
                  "Rent Per Room",
                  Icons.currency_rupee,
                  number: true,
                ),
                _text(
                  rentPerBedCtrl,
                  "Rent Per Bed",
                  Icons.person_outline,
                  number: true,
                ),
                _text(
                  depositCtrl,
                  "Security Deposit",
                  Icons.lock_outline,
                  number: true,
                ),
                _text(
                  maintenanceCtrl,
                  "Maintenance",
                  Icons.build_outlined,
                  number: true,
                ),
                _buildSwitch(
                  "Maintenance Included",
                  maintenanceIncluded,
                  (v) => setState(() => maintenanceIncluded = v),
                ),
              ]),

              const SizedBox(height: 25),
              _sectionTitle("Amenities", Icons.star_outline),
              _buildCard([_buildAmenitiesWrap()]),

              const SizedBox(height: 25),
              _sectionTitle("Availability & Rules", Icons.event_available),
              _buildCard([
                _buildDatePickerTile(),
                const Divider(),
                _dropdown(
                  "Gender Preference",
                  genderPreference,
                  ["Male", "Female", "Any"],
                  (v) => setState(() => genderPreference = v!),
                ),
                _buildSwitch(
                  "Smoking Allowed",
                  smoking,
                  (v) => setState(() => smoking = v),
                ),
                _buildSwitch(
                  "Pets Allowed",
                  pets,
                  (v) => setState(() => pets = v),
                ),
              ]),

              const SizedBox(height: 35),
              _buildSubmitButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.containerWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.primary),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: colors.textGrey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _text(
    TextEditingController c,
    String l,
    IconData icon, {
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        style: TextStyle(
          color: colors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: colors.primary, size: 20),
          labelText: l,
          labelStyle: TextStyle(color: colors.textHint),
          filled: true,
          fillColor: colors.primary.withOpacity(0.03),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _dropdown(
    String l,
    String v,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: v,
        onChanged: onChanged,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        decoration: InputDecoration(
          labelText: l,
          filled: true,
          fillColor: colors.primary.withOpacity(0.03),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(color: colors.textPrimary, fontSize: 14),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: colors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildAmenitiesWrap() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amenitiesList.map((a) {
        final isSelected = selectedAmenities.contains(a);
        return FilterChip(
          label: Text(a),
          selected: isSelected,
          onSelected: (v) => setState(
            () => v ? selectedAmenities.add(a) : selectedAmenities.remove(a),
          ),
          selectedColor: colors.primary.withOpacity(0.15),
          checkmarkColor: colors.primary,
          labelStyle: TextStyle(
            color: isSelected ? colors.primary : colors.textGrey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageHeader() {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.primary.withOpacity(0.1), width: 2),
        ),
        child: roomImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, color: colors.primary, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    "Upload Room Image",
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.file(roomImage!, fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget _buildDatePickerTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        "Available From",
        style: TextStyle(color: colors.textHint, fontSize: 12),
      ),
      subtitle: Text(
        availableFrom.toString().split(" ")[0],
        style: TextStyle(
          color: colors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.calendar_month, color: colors.primary, size: 20),
      ),
      onTap: pickDate,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: isLoading ? null : submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? CircularProgressIndicator(color: colors.textWhite)
            : Text(
                "CREATE ROOM",
                style: TextStyle(
                  color: colors.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }

  Future<void> submit() async {
    debugPrint("🟢 SUBMIT STARTED");

    // 1️⃣ Form validation
    if (!_formKey.currentState!.validate()) {
      debugPrint("❌ FORM VALIDATION FAILED");
      return;
    }
    debugPrint("✅ FORM VALIDATED");

    // 2️⃣ Image check
    if (roomImage == null) {
      debugPrint("❌ ROOM IMAGE NOT SELECTED");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Room image required")));
      return;
    }
    debugPrint("✅ ROOM IMAGE SELECTED: ${roomImage!.path}");

    // 3️⃣ Loader ON
    debugPrint("⏳ SET LOADER TRUE");
    setState(() => isLoading = true);

    try {
      debugPrint("🚀 CALLING CREATE ROOM API");

      debugPrint("📦 PAYLOAD PREVIEW:");
      debugPrint("propertyId: ${widget.propertyId}");
      debugPrint("roomNumber: ${roomNumberCtrl.text}");
      debugPrint("roomType: $roomType");
      debugPrint("floor: ${floorCtrl.text}");
      debugPrint("totalBeds: ${totalBedsCtrl.text}");
      debugPrint("availableFrom: $availableFrom");

      final result = await MyPropertiesApiService.createRoom(
        propertyId: widget.propertyId,
        roomNumber: roomNumberCtrl.text.trim(),
        roomType: roomType,
        floor: _toInt(floorCtrl.text),

        pricing: {
          if (_toInt(rentPerBedCtrl.text) != null)
            "rentPerBed": _toInt(rentPerBedCtrl.text),

          if (_toInt(rentPerRoomCtrl.text) != null)
            "rentPerRoom": _toInt(rentPerRoomCtrl.text),

          "securityDeposit": _toInt(depositCtrl.text) ?? 0,

          if (_toInt(maintenanceCtrl.text) != null)
            "maintenanceCharges": {
              "amount": _toInt(maintenanceCtrl.text),
              "includedInRent": maintenanceIncluded,
            },

          "electricityCharges": electricityCharges,
          "waterCharges": waterCharges,
        },

        capacity: {
          "totalBeds": _toInt(totalBedsCtrl.text) ?? 1,
          "occupiedBeds": 0,
        },

        features: {
          "furnishing": furnishing,
          "hasAttachedBathroom": attachedBath,
          "hasBalcony": balcony,
          "hasAC": ac,
          "hasWardrobe": wardrobe,
          "hasFridge": fridge,
          "amenities": selectedAmenities.toList(),
        },

        rules: {
          "genderPreference": genderPreference,
          "foodType": foodType,
          "smokingAllowed": smoking,
          "petsAllowed": pets,
          "guestsAllowed": guests,
          "noticePeriod": _toInt(noticeCtrl.text) ?? 30,
          "lockInPeriod": _toInt(lockInCtrl.text) ?? 0,
        },

        area: {"carpet": _toInt(carpetCtrl.text) ?? 0, "unit": areaUnit},

        availability: {
          "status": availabilityStatus,
          "availableFrom": availableFrom.toIso8601String().split("T").first,
        },

        roomImage: roomImage!,
      );
      debugPrint("✅ API RESPONSE RECEIVED");
      debugPrint("success: ${result.success}");
      debugPrint("message: ${result.message}");

      if (!mounted) {
        debugPrint("⚠️ WIDGET NOT MOUNTED, STOPPING");
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );

      if (result.success) {
        debugPrint("🎉 ROOM CREATED SUCCESSFULLY, POPPING SCREEN");
        Navigator.pop(context, true);
      } else {
        debugPrint("❌ ROOM CREATION FAILED");
      }
    } catch (e, stack) {
      debugPrint("🔥 EXCEPTION CAUGHT IN SUBMIT");
      debugPrint("ERROR: $e");
      debugPrint("STACK TRACE:\n$stack");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll("Exception:", "").trim()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      debugPrint("🔄 SET LOADER FALSE (FINALLY)");
      if (mounted) {
        setState(() => isLoading = false);
      }
    }

    debugPrint("🟢 SUBMIT FINISHED");
  }

  int? _toInt(String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    return int.tryParse(v);
  }
}
