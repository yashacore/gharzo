import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/screens/lanloard/screens/lanloard_rooms_view/lanloard_all_room_provider.dart';
import '../../../../model/room/get_room_model/get_room_model.dart';

class LanloardPropertyRoomList extends StatefulWidget {
  final String? propertyId;

  const LanloardPropertyRoomList({
    super.key,
    required this.propertyId,
  });

  @override
  State<LanloardPropertyRoomList> createState() => _LanloardPropertyRoomListState();
}

class _LanloardPropertyRoomListState extends State<LanloardPropertyRoomList> {

  @override
  void initState() {
    super.initState();
    // 1. Call the provider to fetch data when the screen initializes
    if (widget.propertyId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AllRoomsProvider>(context, listen: false)
            .getRoomsByPropertyId(widget.propertyId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllRoomsProvider>(
      builder: (context, provider, child) {
        // 2. Loading State
        if (provider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 3. Error State
        if (provider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Error: ${provider.errorMessage}", style: const TextStyle(color: Colors.red)),
            ),
          );
        }

        // 4. Empty State
        if (provider.roomList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No Rooms found for this property"),
            ),
          );
        }

        // 5. Data Loaded State - Render the Table
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                )
              ],
            ),
            child: Column(
              children: [
                _buildHeader(),
                ...provider.roomList.map((room) => _buildRoomRow(room)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- UI Builder Methods (Unchanged from your snippet) ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF004085), // Dark Blue from image
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          _headerItem("Room No.", 80),
          _headerItem("Type", 120),
          _headerItem("Floor", 70),
          _headerItem("Total Beds", 90),
          _headerItem("Occupied", 90),
          _headerItem("Status", 100),
          _headerItem("Rent/Bed", 100),
          _headerItem("Furnishing", 110),
          _headerItem("Active", 70),
          _headerItem("Actions", 150),
        ],
      ),
    );
  }

  Widget _headerItem(String title, double width) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRoomRow(RoomDetail room) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _cellItem(room.roomNumber, 80, isBold: true, color: const Color(0xFF004085)),
          _cellItem(room.roomType, 120),
          _cellItem(room.floor.toString(), 70),
          _cellItem(room.capacity.totalBeds.toString(), 90),
          _cellItem(room.capacity.occupiedBeds.toString(), 90, color: Colors.green, isBold: true),

          // Status Chip
          SizedBox(
            width: 100,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: room.availability.status.toLowerCase() == 'available' ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  room.availability.status,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          _cellItem("₹${room.pricing.rentPerBed}", 100, isBold: true, color: const Color(0xFF004085)),

          // Furnishing Chip
          SizedBox(
            width: 110,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: room.features.furnishing.toLowerCase() == 'fully' ? Colors.blueAccent : Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  room.features.furnishing,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ),

          // Active Dot
          SizedBox(
            width: 70,
            child: Icon(Icons.circle, size: 12, color: room.isActive ? Colors.green : Colors.red),
          ),

          // Actions
          SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionButton(Icons.edit_note, Colors.blue, () {}),
                const SizedBox(width: 8),
                _actionButton(Icons.toggle_on, Colors.green, () {}),
                const SizedBox(width: 8),
                _actionButton(Icons.delete, Colors.red, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cellItem(String text, double width, {bool isBold = false, Color? color}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}