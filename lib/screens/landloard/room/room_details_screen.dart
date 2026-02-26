import 'package:flutter/material.dart';
import 'package:gharzo_project/model/user_room_details_model.dart';
import 'package:gharzo_project/providers/landlord/my_properties_provider.dart';
import 'package:gharzo_project/screens/landloard/room/edit_bed_screen.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import '../../../model/model/bed/bed_model_user.dart';

class RoomDetailsScreen extends StatefulWidget {
  final String roomId;

  const RoomDetailsScreen({super.key, required this.roomId});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  final Color themeColor = const Color(0xFF2457D7);

  RoomDetailsModel? room;
  List<BedModel> bedList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<MyPropertiesProvider>();

      // 🔹 ROOM (Map → Model)
      final roomJson = await provider.fetchRoomDetails(widget.roomId);

      // 🔹 BEDS (already models)
      final beds = await provider.fetchBedsByRoomId(widget.roomId);

      if (!mounted) return;

      setState(() {
        room = roomJson != null
            ? RoomDetailsModel.fromJson(roomJson)
            : null;
        bedList = beds;
        loading = false;
      });

      debugPrint("✅ Room loaded: ${room?.roomNumber}");
      debugPrint("✅ Beds loaded: ${bedList.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFF),
      appBar: CommonWidget.gradientAppBar(
        title: "Room Details",
        onPressed: () => Navigator.pop(context),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: themeColor))
          : room == null
          ? const Center(child: Text("Failed to load room"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageCarousel(),
            const SizedBox(height: 20),
            _roomHeader(),
            const SizedBox(height: 24),
            _section("Pricing"),
            _pricingCard(),
            const SizedBox(height: 24),
            _section("Capacity"),
            _capacityCard(),
            const SizedBox(height: 24),
            _section("Features"),
            _featuresCard(),
            const SizedBox(height: 24),
            _section("Rules"),
            _rulesCard(),
            const SizedBox(height: 24),
            _section("Beds"),
            _bedsSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ================= IMAGES =================

  Widget _imageCarousel() {
    final images = room!.media.images;

    if (images.isEmpty) return _imagePlaceholder();

    return SizedBox(
      height: 200,
      child: PageView(
        children: images
            .map(
              (img) => ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(img.url, fit: BoxFit.cover),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
    height: 200,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Center(
      child: Icon(Icons.image_not_supported, size: 48),
    ),
  );

  // ================= HEADER =================

  Widget _roomHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Room ${room!.roomNumber}",
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 6),
      Text(
        room!.roomType,
        style: TextStyle(color: themeColor, fontSize: 15),
      ),
      const SizedBox(height: 6),
      _statusChip(room!.availability.status),
    ],
  );

  // ================= ROOM CARDS =================

  Widget _pricingCard() {
    final p = room!.pricing;
    return _card([
      _row("Rent / Bed", "₹${p.rentPerBed}"),
      _row("Rent / Room", "₹${p.rentPerRoom}"),
      _row("Security Deposit", "₹${p.securityDeposit}"),
      _row(
        "Maintenance",
        "₹${p.maintenance.amount} "
            "${p.maintenance.includedInRent ? '(Included)' : ''}",
      ),
    ]);
  }

  Widget _capacityCard() {
    final c = room!.capacity;
    return _card([
      _row("Total Beds", "${c.totalBeds}"),
      _row("Occupied Beds", "${c.occupiedBeds}"),
    ]);
  }

  Widget _featuresCard() {
    final f = room!.features;
    return _card([
      _boolRow("Attached Bathroom", f.hasAttachedBathroom),
      _boolRow("Balcony", f.hasBalcony),
      _boolRow("AC", f.hasAC),
      _boolRow("Wardrobe", f.hasWardrobe),
      _boolRow("Fridge", f.hasFridge),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: f.amenities.map(_chip).toList(),
      ),
    ]);
  }

  Widget _rulesCard() {
    final r = room!.rules;
    return _card([
      _row("Gender", r.genderPreference),
      _row("Food", r.foodType),
      _boolRow("Smoking Allowed", r.smokingAllowed),
      _boolRow("Pets Allowed", r.petsAllowed),
      _row("Notice Period", "${r.noticePeriod} days"),
      _row("Lock-in Period", "${r.lockInPeriod} months"),
    ]);
  }

  // ================= BEDS =================

  Widget _bedsSection() {
    if (bedList.isEmpty) {
      return _card([
        const Text(
          "No beds added yet",
          style: TextStyle(color: Colors.grey),
        ),
      ]);
    }

    return Column(
      children: bedList.map(_bedCard).toList(),
    );
  }


  Widget _bedCard(BedModel b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bed ${b.bedNumber}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _statusChip(b.status),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            b.bedType,
            style: TextStyle(color: Colors.blue),
          ),

          const Divider(height: 20),

          // ================= PRICING =================
          _infoRow("Rent", "₹${b.rent}"),
          _infoRow("Deposit", "₹${b.securityDeposit}"),
          _infoRow("Maintenance", "₹${b.maintenanceCharges}"),

          const SizedBox(height: 16),
          const Divider(height: 24),

          // ================= ACTION BAR =================
          Row(
            children: [
              // ✏️ EDIT BED
              _actionButton(
                icon: Icons.edit_outlined,
                label: "Edit",
                color: Colors.blue,
                onTap: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditBedScreen(bed: b),
                    ),
                  );

                  if (updated == true && mounted) {
                    final beds = await context
                        .read<MyPropertiesProvider>()
                        .fetchBedsByRoomId(widget.roomId);

                    if (!mounted) return;

                    setState(() {
                      bedList = beds;
                    });
                  }
                },
              ),

              const SizedBox(width: 8),

              // 🗑 DELETE BED
              _actionButton(
                icon: Icons.delete_outline,
                label: "Delete",
                color: Colors.red,
                onTap: () => _confirmDeleteBed(b),
              ),

              const Spacer(),

              // 🔘 STATUS SWITCH
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    b.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                      b.status == "Available" ? Colors.green : Colors.grey,
                    ),
                  ),
                  Switch(
                    value: b.status == "Available",
                    activeColor: Colors.green,
                    onChanged: (v) =>
                        _toggleBedStatus(b, v),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  // ================= SMALL WIDGETS =================

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      t.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.grey.shade500,
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(children: children),
  );

  Widget _row(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: TextStyle(color: Colors.grey.shade600)),
        Text(v, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget _boolRow(String l, bool v) => _row(l, v ? "Yes" : "No");

  Widget _chip(String t) => Chip(
    label: Text(t),
    backgroundColor: themeColor.withOpacity(0.1),
    labelStyle: TextStyle(color: themeColor),
  );

  Widget _statusChip(String status) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: status == "Available"
          ? Colors.green.withOpacity(0.15)
          : Colors.orange.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: status == "Available" ? Colors.green : Colors.orange,
      ),
    ),
  );

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _confirmDeleteBed(BedModel b) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Bed"),
        content: Text("Delete Bed ${b.bedNumber}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await context
          .read<MyPropertiesProvider>()
          .deleteBed(b.id);

      if (success && mounted) {
        final beds = await context
            .read<MyPropertiesProvider>()
            .fetchBedsByRoomId(widget.roomId);

        if (!mounted) return;

        setState(() {
          bedList = beds; // ✅ THIS WAS MISSING
        });

        debugPrint("✅ Bed deleted & UI refreshed");
      }
    }  }
  Future<void> _toggleBedStatus(BedModel b, bool available) async {
    // ✅ ONLY ALLOWED VALUES
    final newStatus = available ? "Available" : "Occupied";

    debugPrint("🔁 TOGGLING BED STATUS");
    debugPrint("➡️ Bed ID: ${b.id}");
    debugPrint("➡️ Status Sent: $newStatus");

    final success = await context
        .read<MyPropertiesProvider>()
        .updateBedStatus(
      bedId: b.id,
      status: newStatus,
    );

    if (success && mounted) {
      final beds = await context
          .read<MyPropertiesProvider>()
          .fetchBedsByRoomId(widget.roomId);

      if (!mounted) return;

      setState(() {
        bedList = beds;
      });

      debugPrint("✅ STATUS UPDATED & UI REFRESHED");
    }
  }}