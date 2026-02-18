// import 'package:flutter/cupertino.dart';
//
// class AddRoomProvider extends ChangeNotifier {
//
//   final formKey = GlobalKey<FormState>();
//
//   // State variables for Single/Bulk mode
//   bool isBulkMode = false;
//
//   // Single Room fields
//   String selectedRoomType = '1 BHK';
//   String selectedAreaUnit = 'Square Feet (sqft)';
//   String selectedElectricity = 'Per-Unit';
//   String selectedWater = 'Included';
//   String selectedFurnishing = 'Unfurnished';
//   String selectedGender = 'Any Gender';
//   String selectedFoodType = 'Both Veg & Non-Veg';
//   bool maintenanceIncluded = true;
//   List<String> selectedAmenities = [];
//
//   final List<String> amenitiesList = [
//     'WiFi', 'Study Table', 'Chair', 'Bed', 'Mattress', 'Pillow', 'Blanket',
//     'Washing Machine', 'Geyser', 'TV', 'Sofa', 'Dining Table', 'Microwave',
//     'Refrigerator', 'Water Purifier', 'Power Backup', 'CCTV', 'Security Guard',
//     'Parking', 'Gym', 'Common Area', 'Garden', 'Lift'
//   ];
//
//   // Bulk Rooms list
//   List<Map<String, dynamic>> bulkRooms = [
//     {
//       "id": 1,
//       "roomNum": "",
//       "type": "Select Type",
//       "floor": "",
//       "beds": "",
//       "rent": "",
//       "deposit": "",
//       "furnishing": "Unfurnished",
//       "gender": "Any",
//       "area": "",
//       "features": {"Bathroom": false, "Balcony": false, "AC": false, "Wardrobe": false, "Fridge": false}
//     }
//   ];
//
//   void addBulkRoom() {
//     bulkRooms.add({
//       "id": DateTime.now().millisecondsSinceEpoch,
//       "roomNum": "",
//       "type": "Select Type",
//       "floor": "",
//       "beds": "",
//       "rent": "",
//       "deposit": "",
//       "furnishing": "Unfurnished",
//       "gender": "Any",
//       "area": "",
//       "features": {"Bathroom": false, "Balcony": false, "AC": false, "Wardrobe": false, "Fridge": false}
//     });
//     notifyListeners();
//   }
//
//   void removeBulkRoom(int index) {
//     if (bulkRooms.length > 1) {
//       bulkRooms.removeAt(index);
//       notifyListeners();
//     }
//   }
//
//
// }
///TODO UI Code -------

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddRoomProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // State variables
  bool isBulkMode = false;
  bool isLoading = false;

  // Single Room fields (Controllers for better data extraction)
  final TextEditingController roomNoController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController totalBedsController = TextEditingController();
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController rentPerBedController = TextEditingController();
  final TextEditingController securityDepositController = TextEditingController();
  final TextEditingController maintenanceController = TextEditingController();
  final TextEditingController noticePeriodController = TextEditingController();
  final TextEditingController lockInController = TextEditingController();

  String selectedRoomType = '1 BHK';
  String selectedAreaUnit = 'Square Feet (sqft)';
  String selectedElectricity = 'Per-Unit';
  String selectedWater = 'Included';
  String selectedFurnishing = 'Unfurnished';
  String selectedGender = 'Any Gender';
  String selectedFoodType = 'Both';
  bool maintenanceIncluded = true;

  // Features (Map for checkboxes)
  Map<String, bool> roomFeatures = {
    "Attached Bathroom": false,
    "Balcony": false,
    "Air Conditioning": false,
    "Wardrobe": false,
    "Refrigerator": false,
  };

  List<String> selectedAmenities = [];

  final List<String> amenitiesList = [
    'WiFi', 'Study Table', 'Chair', 'Bed', 'Mattress', 'Pillow', 'Blanket',
    'Washing Machine', 'Geyser', 'TV', 'Sofa', 'Dining Table', 'Microwave',
    'Refrigerator', 'Water Purifier', 'Power Backup', 'CCTV', 'Security Guard',
    'Parking', 'Gym', 'Common Area', 'Garden', 'Lift'
  ];

  // Bulk Rooms list (Keeping as is per request)
  List<Map<String, dynamic>> bulkRooms = [
    {
      "id": 1,
      "roomNum": "",
      "type": "Select Type",
      "floor": "",
      "beds": "",
      "rent": "",
      "deposit": "",
      "furnishing": "Unfurnished",
      "gender": "Any",
      "area": "",
      "features": {"Bathroom": false, "Balcony": false, "AC": false, "Wardrobe": false, "Fridge": false}
    }
  ];

  // --- API LOGIC ---

  Future<void> createSingleRoom(BuildContext context, String propertyId, String token) async {
    if (isLoading) return;

    setLoading(true);

    final url = Uri.parse('https://api.gharzoreality.com/api/rooms/create');

    final Map<String, dynamic> body = {
      "propertyId": propertyId,
      "roomNumber": roomNoController.text,
      "roomType": selectedRoomType,
      "floor": int.tryParse(floorController.text) ?? 0,
      "capacity": jsonEncode({
        "totalBeds": int.tryParse(totalBedsController.text) ?? 1
      }),
      "pricing": jsonEncode({
        "rentPerBed": double.tryParse(rentPerBedController.text) ?? 0,
        "securityDeposit": double.tryParse(securityDepositController.text) ?? 0,
        "maintenanceCharges": {
          "amount": double.tryParse(maintenanceController.text) ?? 0,
          "includedInRent": maintenanceIncluded
        },
        "electricityCharges": selectedElectricity,
        "waterCharges": selectedWater
      }),
      "rules": jsonEncode({
        "genderPreference": selectedGender,
        "foodType": selectedFoodType,
        "smokingAllowed": false, // Connect to UI if needed
        "petsAllowed": false,
        "guestsAllowed": true,
        "noticePeriod": int.tryParse(noticePeriodController.text) ?? 30,
        "lockInPeriod": int.tryParse(lockInController.text) ?? 0
      }),
      "features": jsonEncode({
        "furnishing": selectedFurnishing,
        "hasAttachedBathroom": roomFeatures["Attached Bathroom"],
        "hasBalcony": roomFeatures["Balcony"],
        "hasAC": roomFeatures["Air Conditioning"],
        "hasWardrobe": roomFeatures["Wardrobe"],
        "hasFridge": roomFeatures["Refrigerator"],
        "amenities": selectedAmenities
      }),
      "area": jsonEncode({
        "carpet": double.tryParse(carpetAreaController.text) ?? 0,
        "unit": selectedAreaUnit == 'Square Feet (sqft)' ? "sqft" : "sqm"
      })
    };

    try {
      final response = await _performPostRequest(url, body, token);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Room Created Successfully!"), backgroundColor: Colors.green),
        );
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Failed to create room");
      }
    } catch (e) {
      print('Error::  $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
      );
    } finally {
      setLoading(false);
    }
  }

  // Helper for API calls with Exponential Backoff
  Future<http.Response> _performPostRequest(Uri url, Map<String, dynamic> body, String token) async {
    int retryCount = 0;
    while (retryCount < 3) {
      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode(body),
        );
        return response;
      } catch (e) {
        retryCount++;
        if (retryCount >= 3) rethrow;
        await Future.delayed(Duration(seconds: retryCount * 2));
      }
    }
    throw Exception("Network Error");
  }

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  // --- EXISTING LOGIC ---

  void addBulkRoom() {
    bulkRooms.add({
      "id": DateTime.now().millisecondsSinceEpoch,
      "roomNum": "",
      "type": "Select Type",
      "floor": "",
      "beds": "",
      "rent": "",
      "deposit": "",
      "furnishing": "Unfurnished",
      "gender": "Any",
      "area": "",
      "features": {"Bathroom": false, "Balcony": false, "AC": false, "Wardrobe": false, "Fridge": false}
    });
    notifyListeners();
  }

  void removeBulkRoom(int index) {
    if (bulkRooms.length > 1) {
      bulkRooms.removeAt(index);
      notifyListeners();
    }
  }

  void toggleFeature(String key, bool val) {
    roomFeatures[key] = val;
    notifyListeners();
  }
}

