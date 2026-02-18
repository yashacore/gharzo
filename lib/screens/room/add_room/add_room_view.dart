// import 'package:flutter/material.dart';
// import 'package:gharzo_project/common/common_widget/common_widget.dart';
// import 'package:provider/provider.dart';
//
// import 'add_room_provider.dart';
//
// class AddRoomView extends StatefulWidget {
//   const AddRoomView({super.key});
//
//   @override
//   State<AddRoomView> createState() => _AddRoomViewState();
// }
//
// class _AddRoomViewState extends State<AddRoomView> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AddRoomProvider>(
//       builder: (context, provider, child) => Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.5,
//         title: const Text("Room Management",
//             style: TextStyle(color: Color(0xFF001D3D), fontWeight: FontWeight.bold)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: provider.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeaderToggle(provider),
//               const SizedBox(height: 20),
//               provider.isBulkMode
//                   ? _buildBulkRoomsView(provider)
//                   : _buildSingleRoomView(provider),
//             ],
//           ),
//         ),
//       ),
//     ),
//     );
//   }
//
//   // --- UI COMPONENTS ---
//   Widget _buildHeaderToggle(AddRoomProvider provider) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: Row(
//             children: [
//               _toggleBtn("Single Room", !provider.isBulkMode, provider),
//               _toggleBtn("Bulk Rooms", provider.isBulkMode, provider),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget _toggleBtn(String title, bool isActive, AddRoomProvider provider) {
//     return GestureDetector(
//       onTap: () => setState(() => provider.isBulkMode = (title == "Bulk Rooms")),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: isActive ? const Color(0xFF001D3D) : Colors.transparent,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: isActive ? Colors.white : Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- BULK VIEW ---
//   Widget _buildBulkRoomsView(AddRoomProvider provider) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               flex: 2,
//               child: Row(
//                 children: [
//                   const Icon(Icons.description_outlined, color: Colors.orange),
//                   const SizedBox(width: 8),
//                   Text("Rooms (${provider.bulkRooms.length})",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: CommonWidget.commonElevatedBtn(
//                 maximumSize: const Size(100, 40),
//                 minimumSize: const Size(100, 40),
//                 onPressed: provider.addBulkRoom,
//                 btnText: '+ Add Room',
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 12),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: provider.bulkRooms.length,
//           itemBuilder: (context, index) => _buildBulkCard(index,provider),
//         ),
//         const SizedBox(height: 20),
//         CommonWidget.commonElevatedBtn(
//           onPressed: () {},
//           btnText: 'Create Rooms',
//         ),
//         const SizedBox(height: 40),
//       ],
//     );
//   }
//
//   Widget _buildBulkCard(int index, AddRoomProvider provider) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Room ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//               if (provider.bulkRooms.length > 1)
//                 IconButton(
//                   onPressed: () => provider.removeBulkRoom(index),
//                   icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
//                 ),
//             ],
//           ),
//           const Divider(),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(child: _customInput("Room Number *", "e.g., 101")),
//               const SizedBox(width: 12),
//               Expanded(child: _customDropdown("Room Type *", ["Select Type", "1 BHK", "2 BHK", "Studio"])),
//               const SizedBox(width: 12),
//               Expanded(child: _customInput("Floor", "Floor number")),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _customInput("Total Beds *", "Number of beds")),
//               const SizedBox(width: 12),
//               Expanded(child: _customInput("Rent Per Bed (₹)", "Rent per bed")),
//               const SizedBox(width: 12),
//               Expanded(child: _customInput("Security Deposit (₹) *", "Security deposit")),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _customDropdown("Furnishing", ["Unfurnished", "Semi", "Full"])),
//               const SizedBox(width: 12),
//               Expanded(child: _customDropdown("Gender", ["Any", "Male", "Female"])),
//               const SizedBox(width: 12),
//               Expanded(child: _customInput("Carpet Area", "Area size")),
//             ],
//           ),
//           const SizedBox(height: 16),
//           const Text("Features", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 20,
//             children: [
//               _checkboxItem("Bathroom"),
//               _checkboxItem("Balcony"),
//               _checkboxItem("AC"),
//               _checkboxItem("Wardrobe"),
//               _checkboxItem("Fridge"),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   // --- SINGLE VIEW ---
//   Widget _buildSingleRoomView(AddRoomProvider provider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _sectionTitle("📋", "Basic Information"),
//         _buildCard([
//           Row(
//             children: [
//               Expanded(child: _buildTextField("Room Number *", "201", Icons.format_list_numbered)),
//               const SizedBox(width: 12),
//               Expanded(child: _buildDropdown("Room Type *", provider.selectedRoomType, ['1 BHK', '2 BHK', 'Room'], (val) => setState(() => provider.selectedRoomType = val!))),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _buildTextField("Floor", "2", Icons.layers)),
//               const SizedBox(width: 12),
//               Expanded(child: _buildTextField("Total Beds *", "2", Icons.people)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _buildTextField("Carpet Area", "1254", Icons.straighten)),
//               const SizedBox(width: 12),
//               Expanded(child: _buildDropdown("Area Unit", provider.selectedAreaUnit, ['Square Feet (sqft)', 'Square Meters (sqm)'], (val) => setState(() => provider.selectedAreaUnit = val!))),
//             ],
//           ),
//         ]),
//
//         _sectionTitle("💰", "Pricing"),
//         _buildCard([
//           Row(
//             children: [
//               Expanded(child: _buildTextField("Rent Per Bed (₹)", "5000", Icons.money)),
//               const SizedBox(width: 12),
//               Expanded(child: _buildTextField("Rent Per Room (₹)", "5000", Icons.money)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildTextField("Security Deposit (₹) *", "45678", Icons.security),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _buildTextField("Maintenance Charges (₹)", "5678", Icons.money)),
//               const SizedBox(width: 12),
//               Expanded(child: _buildDropdown("Electricity Charges", provider.selectedElectricity, ['Per-Unit', 'Included', 'Extra'], (val) => setState(() => provider.selectedElectricity = val!))),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildDropdown("Water Charges", provider.selectedWater, ['Included', 'Extra'], (val) => setState(() => provider.selectedWater = val!)),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Checkbox(
//                 value: provider.maintenanceIncluded,
//                 onChanged: (val) => setState(() => provider.maintenanceIncluded = val!),
//                 activeColor: const Color(0xFF001D3D),
//               ),
//               const Text("Maintenance Charges Included in Rent"),
//             ],
//           ),
//         ]),
//
//         _sectionTitle("✨", "Room Features"),
//         _buildCard([
//           const Text("Furnishing", style: TextStyle(fontSize: 12, color: Colors.grey)),
//           _buildDropdown("", provider.selectedFurnishing, ['Unfurnished', 'Semi-Furnished', 'Fully-Furnished'], (val) => setState(() => provider.selectedFurnishing = val!)),
//           const SizedBox(height: 16),
//           Wrap(
//             spacing: 12,
//             runSpacing: 12,
//             children: [
//               _buildCheckboxFeature("Attached Bathroom"),
//               _buildCheckboxFeature("Balcony"),
//               _buildCheckboxFeature("Air Conditioning"),
//               _buildCheckboxFeature("Wardrobe"),
//               _buildCheckboxFeature("Refrigerator"),
//             ],
//           ),
//         ]),
//
//         _sectionTitle("🏠", "Amenities"),
//         _buildCard([
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: provider.amenitiesList.map((e) => _amenityChip(e, provider)).toList(),
//           ),
//         ]),
//
//         _sectionTitle("📋", "Rules & Policies"),
//         _buildCard([
//           Row(
//             children: [
//               Expanded(child: _buildDropdown("Gender Preference", provider.selectedGender, ['Any Gender', 'Male Only', 'Female Only'], (val) => setState(() => provider.selectedGender = val!))),
//               const SizedBox(width: 12),
//               Expanded(child: _buildDropdown("Food Type", provider.selectedFoodType, ['Both Veg & Non-Veg', 'Vegetarian Only', 'Non-Vegetarian Only'], (val) => setState(() => provider.selectedFoodType = val!))),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(child: _buildTextField("Notice Period (days)", "30", Icons.access_time)),
//               const SizedBox(width: 12),
//               Expanded(child: _buildTextField("Lock-in Period (months)", "0", Icons.access_time)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Wrap(
//             spacing: 12,
//             children: [
//               _buildCheckboxFeature("Smoking Allowed"),
//               _buildCheckboxFeature("Pets Allowed"),
//               _buildCheckboxFeature("Guests Allowed"),
//             ],
//           ),
//         ]),
//
//         _sectionTitle("🖼️", "Room Images"),
//         _buildCard([
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Column(
//               children: [
//                 Icon(Icons.image, color: Colors.grey, size: 40),
//                 SizedBox(height: 8),
//                 Text("Choose Files 3 files", style: TextStyle(color: Colors.grey)),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text("New Images", style: TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               _buildImagePlaceholder(),
//               _buildImagePlaceholder(),
//               _buildImagePlaceholder(),
//             ],
//           )
//         ]),
//
//         const SizedBox(height: 32),
//         CommonWidget.commonElevatedBtn(
//           onPressed: () {},
//           btnText: 'Create Room',
//         ),
//         const SizedBox(height: 50),
//       ],
//     );
//   }
//
//   // --- HELPERS ---
//   Widget _sectionTitle(String emoji, String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 20)),
//           const SizedBox(width: 8),
//           Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF001D3D))),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(List<Widget> children) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
//     );
//   }
//
//   Widget _buildTextField(String label, String hint, IconData icon) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
//         const SizedBox(height: 6),
//         TextFormField(
//           initialValue: hint,
//           decoration: InputDecoration(
//             prefixIcon: Icon(icon, size: 20),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label.isNotEmpty) Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
//         if (label.isNotEmpty) const SizedBox(height: 6),
//         DropdownButtonFormField<String>(
//           value: value,
//           isExpanded: true,
//           decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
//           items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCheckboxFeature(String label) {
//     return Container(
//       width: (MediaQuery.of(context).size.width / 2) - 40,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Checkbox(value: false, onChanged: (v) {}, visualDensity: VisualDensity.compact),
//           Flexible(child: Text(label, style: const TextStyle(fontSize: 11))),
//         ],
//       ),
//     );
//   }
//
//   Widget _amenityChip(String label, AddRoomProvider provider) {
//     bool isSelected = provider.selectedAmenities.contains(label);
//     return FilterChip(
//       label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.black87)),
//       selected: isSelected,
//       onSelected: (val) => setState(() => val ? provider.selectedAmenities.add(label) : provider.selectedAmenities.remove(label)),
//       selectedColor: const Color(0xFF001D3D),
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade200)),
//     );
//   }
//
//   Widget _buildImagePlaceholder() {
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       height: 60,
//       width: 80,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[200],
//         image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/80"), fit: BoxFit.cover),
//       ),
//     );
//   }
//
//   Widget _customInput(String label, String hint) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 4),
//         TextField(
//           decoration: InputDecoration(
//             hintText: hint,
//             isDense: true,
//             contentPadding: const EdgeInsets.all(10),
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _customDropdown(String label, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 4),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: items[0],
//               isExpanded: true,
//               items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 11)))).toList(),
//               onChanged: (v) {},
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _checkboxItem(String title) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Checkbox(value: false, onChanged: (v) {}, visualDensity: VisualDensity.compact),
//         Text(title, style: const TextStyle(fontSize: 11)),
//       ],
//     );
//   }
// }

/// TODO UI Code-----

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/db_service/db_service.dart';
import 'add_room_provider.dart';

class AddRoomView extends StatefulWidget {
  const AddRoomView({super.key});

  @override
  State<AddRoomView> createState() => _AddRoomViewState();
}

class _AddRoomViewState extends State<AddRoomView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddRoomProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text("Room Management",
              style: TextStyle(color: Color(0xFF001D3D), fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderToggle(provider),
                    const SizedBox(height: 20),
                    provider.isBulkMode ? _buildBulkRoomsView(provider) : _buildSingleRoomView(provider),
                  ],
                ),
              ),
            ),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xFF001D3D))),
          ],
        ),
      ),
    );
  }

  // Note: Updated _buildSingleRoomView to use controllers and trigger API
  Widget _buildSingleRoomView(AddRoomProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("📋", "Basic Information"),
        _buildCard([
          Row(
            children: [
              Expanded(child: _buildTextField("Room Number *", "201", Icons.format_list_numbered, provider.roomNoController)),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown("Room Type *", provider.selectedRoomType, ['1 BHK', '2 BHK', 'Room'], (val) => setState(() => provider.selectedRoomType = val!))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField("Floor", "2", Icons.layers, provider.floorController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Total Beds *", "2", Icons.people, provider.totalBedsController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField("Carpet Area", "1254", Icons.straighten, provider.carpetAreaController)),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown("Area Unit", provider.selectedAreaUnit, ['Square Feet (sqft)', 'Square Meters (sqm)'], (val) => setState(() => provider.selectedAreaUnit = val!))),
            ],
          ),
        ]),
        _sectionTitle("💰", "Pricing"),
        _buildCard([
          Row(
            children: [
              Expanded(child: _buildTextField("Rent Per Bed (₹)", "5000", Icons.money, provider.rentPerBedController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Rent Per Room (₹)", "5000", Icons.money, TextEditingController())), // Dummy for UI
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField("Security Deposit (₹) *", "45678", Icons.security, provider.securityDepositController),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField("Maintenance Charges (₹)", "5678", Icons.money, provider.maintenanceController)),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown("Electricity Charges", provider.selectedElectricity, ['Per-Unit', 'Included', 'Extra'], (val) => setState(() => provider.selectedElectricity = val!))),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdown("Water Charges", provider.selectedWater, ['Included', 'Extra'], (val) => setState(() => provider.selectedWater = val!)),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: provider.maintenanceIncluded,
                onChanged: (val) => setState(() => provider.maintenanceIncluded = val!),
                activeColor: const Color(0xFF001D3D),
              ),
              const Text("Maintenance Charges Included in Rent"),
            ],
          ),
        ]),
        _sectionTitle("✨", "Room Features"),
        _buildCard([
          const Text("Furnishing", style: TextStyle(fontSize: 12, color: Colors.grey)),
          _buildDropdown("", provider.selectedFurnishing, ['Unfurnished', 'Semi-Furnished', 'Fully-Furnished'], (val) => setState(() => provider.selectedFurnishing = val!)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: provider.roomFeatures.keys.map((feature) {
              return _buildCheckboxFeature(feature, provider.roomFeatures[feature]!, (val) {
                provider.toggleFeature(feature, val!);
              });
            }).toList(),
          ),
        ]),
        _sectionTitle("🏠", "Amenities"),
        _buildCard([
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.amenitiesList.map((e) => _amenityChip(e, provider)).toList(),
          ),
        ]),
        _sectionTitle("📋", "Rules & Policies"),
        _buildCard([
          Row(
            children: [
              Expanded(child: _buildDropdown("Gender Preference", provider.selectedGender, ['Any Gender', 'Male Only', 'Female Only'], (val) => setState(() => provider.selectedGender = val!))),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown("Food Type", provider.selectedFoodType, ['Both', 'Non-Veg', 'Veg'], (val) => setState(() => provider.selectedFoodType = val!))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField("Notice Period (days)", "30", Icons.access_time, provider.noticePeriodController)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField("Lock-in Period (months)", "0", Icons.access_time, provider.lockInController)),
            ],
          ),
        ]),
        const SizedBox(height: 32),
        CommonWidget.commonElevatedBtn(
          onPressed: () async {
            final token = await PrefService.getToken();
            provider.createSingleRoom(context, "6989ad270e6bef9474e1e6cb", token ?? '');
          },
          btnText: provider.isLoading ? 'Processing...' : 'Create Room',
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  // --- REUSED HELPERS (Updated to accept controllers) ---
  Widget _buildTextField(String label, String hint, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxFeature(String label, bool value, Function(bool?) onChanged) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: value, onChanged: onChanged, visualDensity: VisualDensity.compact),
          Flexible(child: Text(label, style: const TextStyle(fontSize: 11))),
        ],
      ),
    );
  }

  Widget _buildHeaderToggle(AddRoomProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              _toggleBtn("Single Room", !provider.isBulkMode, provider),
              _toggleBtn("Bulk Rooms", provider.isBulkMode, provider),
            ],
          ),
        )
      ],
    );
  }

  Widget _toggleBtn(String title, bool isActive, AddRoomProvider provider) {
    return GestureDetector(
      onTap: () => setState(() => provider.isBulkMode = (title == "Bulk Rooms")),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF001D3D) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String emoji, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF001D3D))),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        if (label.isNotEmpty) const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _amenityChip(String label, AddRoomProvider provider) {
    bool isSelected = provider.selectedAmenities.contains(label);
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.black87)),
      selected: isSelected,
      onSelected: (val) => setState(() => val ? provider.selectedAmenities.add(label) : provider.selectedAmenities.remove(label)),
      selectedColor: const Color(0xFF001D3D),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade200)),
    );
  }

  // --- BULK VIEW ---
  Widget _buildBulkRoomsView(AddRoomProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(Icons.description_outlined, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text("Rooms (${provider.bulkRooms.length})",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: CommonWidget.commonElevatedBtn(
                maximumSize: const Size(100, 40),
                minimumSize: const Size(100, 40),
                onPressed: provider.addBulkRoom,
                btnText: '+ Add Room',
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.bulkRooms.length,
          itemBuilder: (context, index) => _buildBulkCard(index,provider),
        ),
        const SizedBox(height: 20),
        CommonWidget.commonElevatedBtn(
          onPressed: () {},
          btnText: 'Create Rooms',
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBulkCard(int index, AddRoomProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Room ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (provider.bulkRooms.length > 1)
                IconButton(
                  onPressed: () => provider.removeBulkRoom(index),
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _customInput("Room Number *", "e.g., 101")),
              const SizedBox(width: 12),
              Expanded(child: _customDropdown("Room Type *", ["Select Type", "1 BHK", "2 BHK", "Studio"])),
              const SizedBox(width: 12),
              Expanded(child: _customInput("Floor", "Floor number")),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _customInput("Total Beds *", "Number of beds")),
              const SizedBox(width: 12),
              Expanded(child: _customInput("Rent Per Bed (₹)", "Rent per bed")),
              const SizedBox(width: 12),
              Expanded(child: _customInput("Security Deposit (₹) *", "Security deposit")),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _customDropdown("Furnishing", ["Unfurnished", "Semi", "Full"])),
              const SizedBox(width: 12),
              Expanded(child: _customDropdown("Gender", ["Any", "Male", "Female"])),
              const SizedBox(width: 12),
              Expanded(child: _customInput("Carpet Area", "Area size")),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Features", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 20,
            children: [
              _checkboxItem("Bathroom"),
              _checkboxItem("Balcony"),
              _checkboxItem("AC"),
              _checkboxItem("Wardrobe"),
              _checkboxItem("Fridge"),
            ],
          )
        ],
      ),
    );
  }

    Widget _customInput(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _customDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items[0],
              isExpanded: true,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 11)))).toList(),
              onChanged: (v) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkboxItem(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: false, onChanged: (v) {}, visualDensity: VisualDensity.compact),
        Text(title, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

}