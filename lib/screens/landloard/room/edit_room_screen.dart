import 'package:flutter/material.dart';
import 'package:gharzo_project/model/user_room_details_model.dart';
import 'package:gharzo_project/providers/landlord/my_properties_provider.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

final colors = AppThemeColors();

class EditRoomScreen extends StatefulWidget {
  final RoomDetailsModel room;

  const EditRoomScreen({super.key, required this.room});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final roomNumberCtrl = TextEditingController();
  final floorCtrl = TextEditingController();
  final totalBedsCtrl = TextEditingController();
  final rentPerBedCtrl = TextEditingController();
  final depositCtrl = TextEditingController();
  final maintenanceCtrl = TextEditingController();
  final noticeCtrl = TextEditingController();
  final lockInCtrl = TextEditingController();

  // State
  String furnishing = "Unfurnished";
  String genderPreference = "Any";
  String foodType = "Both";

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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  void _prefill() {
    final r = widget.room;

    roomNumberCtrl.text = r.roomNumber;
    floorCtrl.text = r.floor.toString();
    totalBedsCtrl.text = r.capacity.totalBeds.toString();
    rentPerBedCtrl.text = r.pricing.rentPerBed.toString();
    depositCtrl.text = r.pricing.securityDeposit.toString();
    maintenanceCtrl.text = r.pricing.maintenance.amount.toString();
    noticeCtrl.text = r.rules.noticePeriod.toString();
    lockInCtrl.text = r.rules.lockInPeriod.toString();

    furnishing = r.features.furnishing;
    genderPreference = r.rules.genderPreference;
    foodType = r.rules.foodType;

    attachedBath = r.features.hasAttachedBathroom;
    balcony = r.features.hasBalcony;
    ac = r.features.hasAC;
    wardrobe = r.features.hasWardrobe;
    fridge = r.features.hasFridge;

    smoking = r.rules.smokingAllowed;
    pets = r.rules.petsAllowed;
    guests = r.rules.guestsAllowed;

    maintenanceIncluded = r.pricing.maintenance.includedInRent;

    selectedAmenities.addAll(r.features.amenities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      appBar: CommonWidget.gradientAppBar(
        title: "Edit Room",
        onPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section("General"),
              _card([
                _text(roomNumberCtrl, "Room Number"),
                _text(floorCtrl, "Floor", number: true),
                _text(totalBedsCtrl, "Total Beds", number: true),
              ]),
              const SizedBox(height: 24),

              _section("Pricing"),
              _card([
                _text(rentPerBedCtrl, "Rent Per Bed", number: true),
                _text(depositCtrl, "Security Deposit", number: true),
                _text(maintenanceCtrl, "Maintenance", number: true),
                _switch(
                  "Maintenance Included",
                  maintenanceIncluded,
                      (v) => setState(() => maintenanceIncluded = v),
                ),
              ]),
              const SizedBox(height: 24),

              _section("Amenities"),
              _card([_amenitiesWrap()]),
              const SizedBox(height: 24),

              _section("Rules"),
              _card([
                _dropdown(
                  "Gender Preference",
                  genderPreference,
                  ["Male", "Female", "Any"],
                      (v) => setState(() => genderPreference = v!),
                ),
                _dropdown(
                  "Food Type",
                  foodType,
                  ["Veg", "Non-Veg", "Both"],
                      (v) => setState(() => foodType = v!),
                ),
                _switch(
                  "Smoking Allowed",
                  smoking,
                      (v) => setState(() => smoking = v),
                ),
                _switch(
                  "Pets Allowed",
                  pets,
                      (v) => setState(() => pets = v),
                ),
                _switch(
                  "Guests Allowed",
                  guests,
                      (v) => setState(() => guests = v),
                ),
                _text(noticeCtrl, "Notice Period (days)", number: true),
                _text(lockInCtrl, "Lock-in Period (months)", number: true),
              ]),
              const SizedBox(height: 36),

              _submitButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t.toUpperCase(),
      style: TextStyle(
        color: colors.textGrey,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.1,
      ),
    ),
  );

  Widget _card(List<Widget> c) => Container(
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
    child: Column(children: c),
  );

  Widget _text(
      TextEditingController c,
      String l, {
        bool number = false,
      }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: c,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          validator: (v) => v == null || v.isEmpty ? "Required" : null,
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

  Widget _dropdown(
      String l,
      String v,
      List<String> items,
      Function(String?) onChanged,
      ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: DropdownButtonFormField<String>(
          value: v,
          items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
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

  Widget _switch(String t, bool v, Function(bool) onChanged) =>
      SwitchListTile(
        title: Text(t),
        value: v,
        onChanged: onChanged,
        activeColor: colors.primary,
        contentPadding: EdgeInsets.zero,
      );

  Widget _amenitiesWrap() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: amenitiesList.map((a) {
      final s = selectedAmenities.contains(a);
      return FilterChip(
        label: Text(a),
        selected: s,
        onSelected: (v) =>
            setState(() => v ? selectedAmenities.add(a) : selectedAmenities.remove(a)),
        selectedColor: colors.primary.withOpacity(0.15),
      );
    }).toList(),
  );

  Widget _submitButton() => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: isLoading ? null : _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
        "UPDATE ROOM",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.2,
        ),
      ),
    ),
  );

  // ================= SUBMIT =================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final payload = {
      // ================= BASIC INFO =================
      "roomNumber": roomNumberCtrl.text.trim(),
      "roomType": widget.room.roomType, // unchanged
      "floor": _toInt(floorCtrl.text) ?? widget.room.floor,
      "isActive": widget.room.isActive,

      // ================= PRICING =================
      "pricing": {
        "rentPerBed": _toInt(rentPerBedCtrl.text) ?? 0,
        "rentPerRoom": widget.room.pricing.rentPerRoom,
        "securityDeposit": _toInt(depositCtrl.text) ?? 0,
        "electricityCharges": widget.room.pricing.electricityCharges,
        "waterCharges": widget.room.pricing.waterCharges,
        "maintenanceCharges": {
          "amount": _toInt(maintenanceCtrl.text) ?? 0,
          "includedInRent": maintenanceIncluded,
        },
      },

      // ================= CAPACITY =================
      "capacity": {
        "totalBeds": _toInt(totalBedsCtrl.text) ?? widget.room.capacity.totalBeds,
        "occupiedBeds": widget.room.capacity.occupiedBeds,
      },

      // ================= FEATURES =================
      "features": {
        "furnishing": furnishing,
        "hasAttachedBathroom": attachedBath,
        "hasBalcony": balcony,
        "hasAC": ac,
        "hasWardrobe": wardrobe,
        "hasFridge": fridge,
        "amenities": selectedAmenities.toList(),
      },

      // ================= RULES =================
      "rules": {
        "genderPreference": genderPreference,
        "foodType": foodType,
        "smokingAllowed": smoking,
        "petsAllowed": pets,
        "guestsAllowed": guests,
        "noticePeriod": _toInt(noticeCtrl.text) ?? 30,
        "lockInPeriod": _toInt(lockInCtrl.text) ?? 0,
      },

      // ================= AVAILABILITY =================
      "availability": {
        "status": widget.room.availability.status,
      },

      // ================= AREA =================
      "area": {
        "carpet": widget.room.area.carpet,
        "unit": widget.room.area.unit,
      },
    };
    final success = await context
        .read<MyPropertiesProvider>()
        .updateRoom(roomId: widget.room.id, payload: payload);

    if (!mounted) return;

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Room updated successfully" : "Update failed"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) Navigator.pop(context, true);
  }

  int? _toInt(String v) => int.tryParse(v.trim());
}