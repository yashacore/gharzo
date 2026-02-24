import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/model/user_room_details_model.dart';
import 'package:gharzo_project/providers/landlord/my_properties_provider.dart';
import 'package:gharzo_project/screens/landloard/room/add_room_screen.dart';
import 'package:gharzo_project/screens/landloard/landlord_properties/add_bed_screen.dart';
import 'package:gharzo_project/screens/landloard/room/edit_room_screen.dart';
import 'package:gharzo_project/screens/landloard/room/room_details_screen.dart';
import 'package:gharzo_project/screens/room/add_room/add_room_view.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color themeColor = const Color(0xFF2457D7);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // 👈 rebuild for FAB visibility
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyPropertiesProvider>().loadPropertyDetails(
        widget.propertyId,
      );

      context.read<MyPropertiesProvider>().fetchRoomsByProperty(
        widget.propertyId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFF),

      // ✅ FAB only on 2nd tab (ROOMS)
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              backgroundColor: Color(0xFF2457D7),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Create Room",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CreateRoomScreen(propertyId: widget.propertyId),
                  ),
                );
              },
            )
          : null,

      appBar: CommonWidget.gradientAppBar(
        title: "Property Insights",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          _stylishTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_detailsTab(), _roomsTab(), _reviewsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsTab() {
    return Consumer<MyPropertiesProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator(color: themeColor));
        }

        final p = provider.property;
        if (p == null) {
          return const Center(child: Text("Property not found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(p),
              const SizedBox(height: 24),

              _sectionHeader("Configuration"),
              _buildQuickStats(p),

              const SizedBox(height: 24),

              _sectionHeader("Pricing Details"),
              _buildPriceCard(p),

              const SizedBox(height: 24),

              _sectionHeader("Description"),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  p.description,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.6),
                ),
              ),

              const SizedBox(height: 24),

              _sectionHeader("Property Info"),
              _buildAdditionalInfo(p),

              const SizedBox(height: 16),

              PrimaryButton(
                title: "Add Room",
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateRoomScreen(propertyId: p.id),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _roomsTab() {
    return Consumer<MyPropertiesProvider>(
      builder: (_, p, __) {
        if (p.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (p.rooms.isEmpty) {
          return const Center(child: Text("No rooms added yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: p.rooms.length,
          itemBuilder: (_, i) => _roomCard(p.rooms[i]),
        );
      },
    );
  }

  Widget _reviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _reviewCard("Rahul Sharma", 4.5, "Very clean and well maintained."),
        _reviewCard("Amit Verma", 5.0, "Great location and facilities."),
      ],
    );
  }

  Widget _reviewCard(String name, double rating, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("⭐ $rating"),
          const SizedBox(height: 6),
          Text(comment),
        ],
      ),
    );
  }

  Widget _buildHeader(dynamic p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                p.listingType.toUpperCase(),
                style: TextStyle(
                  color: themeColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              "Status: ${p.status}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          p.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1A1C1E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          p.propertyType,

          style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildQuickStats(dynamic p) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1.1,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _statBox("BHK", "${p.bhk}", Icons.bed_outlined),
        _statBox("Baths", "${p.bathrooms}", Icons.bathtub_outlined),
        _statBox("Balconies", "${p.balconies}", Icons.deck_outlined),
        _statBox("Area", "${p.carpetArea}", Icons.square_foot_outlined),
        _statBox("Age", p.propertyAge, Icons.history_rounded),
        _statBox("Unit", p.areaUnit, Icons.straighten_rounded),
      ],
    );
  }

  Widget _statBox(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: themeColor),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildPriceCard(dynamic p) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [themeColor, const Color(0xFF4B79F5)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _priceItem("Monthly Rent", "₹${p.amount}"),
          Container(width: 1, height: 40, color: Colors.white24),
          _priceItem("Security Deposit", "₹${p.securityDeposit}"),
        ],
      ),
    );
  }

  Widget _priceItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(dynamic p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _infoRow("Negotiable", p.negotiable ? "Yes" : "No"),
          const Divider(),
          _infoRow("Profile Completion", "${p.completionPercentage}%"),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Colors.grey.shade500,
          letterSpacing: 1.1,
        ),
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
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _roomCard(RoomDetailsModel r) {
    final pricing = r.pricing;
    final capacity = r.capacity;
    final features = r.features;
    final availability = r.availability;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomDetailsScreen(roomId: r.id)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
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
                  "Room ${r.roomNumber}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _statusChip(availability.status),
              ],
            ),

            const SizedBox(height: 6),
            Text(r.roomType, style: TextStyle(color: Colors.blue.shade600)),

            const Divider(height: 20),

            // ================= ONE ROW: FLOOR | BEDS | RENT | SECURITY =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniInfo("Floor", r.floor.toString()),
                _miniInfo("Beds", capacity.totalBeds.toString()),
                _miniInfo("Rent/Bed", "₹${pricing.rentPerBed}"),
                _miniInfo("Deposit", "₹${pricing.securityDeposit}"),
              ],
            ),

            const SizedBox(height: 14),

            // ================= AMENITIES =================
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features.amenities.map((a) => _chip(a)).toList(),
            ),

            const SizedBox(height: 14),
            Row(
              children: [
                // DELETE
                _actionButton(
                  icon: Icons.delete_outline,
                  label: "Delete",
                  color: Colors.red,
                  onTap: () => _confirmDeleteRoom(r),
                ),

                const SizedBox(width: 8),

                // EDIT
                _actionButton(
                  icon: Icons.edit_outlined,
                  label: "Edit",
                  color: Colors.blue,
                  onTap: () async{
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditRoomScreen(room: r),
                      ),
                    );

                    if (updated == true && context.mounted) {
                      debugPrint("🔄 Refreshing rooms after update");

                      await context
                          .read<MyPropertiesProvider>()
                          .fetchRoomsByProperty(widget.propertyId);
                    }
                  },
                ),

                const Spacer(),

                // ACTIVE SWITCH
                Row(
                  children: [
                    Text(
                      r.availability.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: r.availability.status == "Available"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Switch(
                      value: r.availability.status == "Available",
                      onChanged: (v) async {
                        final newStatus = v ? "Available" : "Blocked";

                        debugPrint("🔁 TOGGLING ROOM STATUS");
                        debugPrint("➡️ Room ID: ${r.id}");
                        debugPrint("➡️ New Status: $newStatus");

                        final success = await context
                            .read<MyPropertiesProvider>()
                            .updateRoomStatus(
                          roomId: r.id,
                          status: newStatus,
                        );

                        if (success && mounted) {
                          await context
                              .read<MyPropertiesProvider>()
                              .fetchRoomsByProperty(widget.propertyId);
                        }
                      },
                    )                  ],
                ),
              ],
            ),
            // ================= ACTION BUTTON =================
          ],
        ),
      ),
    );
  }

  Widget _miniInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _statusChip(String? status) {
    final color = status == "Available" ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status ?? "", style: TextStyle(color: color, fontSize: 11)),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _stylishTabBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        gradient: LinearGradient(
          colors: [
            AppThemeColors().backgroundLeft,
            AppThemeColors().backgroundRight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Color(0xFF2457D7),
        unselectedLabelColor: Colors.white,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        tabs: const [
          Tab(text: "DETAILS"),
          Tab(text: "ROOMS"),
          Tab(text: "REVIEWS"),
        ],
      ),
    );
  }
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
  Future<void> _confirmDeleteRoom(RoomDetailsModel r) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Room"),
        content: Text(
          "Are you sure you want to delete Room ${r.roomNumber}?\nThis action cannot be undone.",
        ),
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
      await _deleteRoom(r.id);
    }
  }
  Future<void> _deleteRoom(String roomId) async {
    debugPrint("🚀 Calling deleteRoom");

    final success = await context
        .read<MyPropertiesProvider>()
        .deleteRoom(roomId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Room deleted successfully" : "Failed to delete room",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      debugPrint("🔄 Refreshing rooms after delete");

      await context
          .read<MyPropertiesProvider>()
          .fetchRoomsByProperty(widget.propertyId);
    }
  }
}
