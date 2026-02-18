import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/screens/add_properties/add_property_type/add_property_view.dart';

class BasicDetailsProvider extends ChangeNotifier {
  bool loading = false;
  String? error;

  // ---------------- BASIC
  String title = '';
  String description = '';
  int bhk = 0;
  int bathrooms = 0;
  int balconies = 0;

  // ---------------- PRICE
  int price = 0;
  bool negotiable = true;
  int maintenance = 0;
  int securityDeposit = 0;

  // ---------------- AREA
  int carpetArea = 0;
  int builtUpArea = 0;
  String areaUnit = 'sqft';

  // ---------------- FLOOR
  int currentFloor = 1;
  int totalFloors = 1;

  // ---------------- PROPERTY AGE
  String propertyAge = "1-5 years";

  // ---------------- META
  DateTime? availableFrom;
  String postedBy = "Owner";

  // ---------------- PG
  String? roomType;
  int totalBeds = 0;
  int availableBeds = 0;

  // ================= VALIDATION =================
  bool validate() {
    if (title.isEmpty) return _err("Title required");
    if (description.isEmpty) return _err("Description required");
    if (bhk <= 0) return _err("BHK required");
    if (price <= 0) return _err("Price required");
    if (carpetArea <= 0) return _err("Carpet area required");
    return true;
  }

  bool _err(String msg) {
    error = msg;
    notifyListeners();
    return false;
  }

  // ================= SUBMIT =================
  Future<bool> submit(String propertyId, String listingType) async {
    if (!validate()) return false;

    loading = true;
    error = null;
    notifyListeners();

    final payload = {
      "title": title,
      "description": description,
      "bhk": bhk,
      "bathrooms": bathrooms,
      "balconies": balconies,
      "price": {
        "amount": price,
        "negotiable": negotiable,
        "maintenanceCharges": {
          "amount": maintenance,
          "frequency": "Monthly",
        },
        "securityDeposit": securityDeposit,
      },
      "area": {
        "carpet": carpetArea,
        "builtUp": builtUpArea,
        "unit": areaUnit,
      },
      "floor": {
        "current": currentFloor,
        "total": totalFloors,
      },
      "propertyAge": propertyAge,
      "availableFrom": availableFrom?.toIso8601String(),
      "postedBy": postedBy,
      if (listingType == "PG")
        "pgDetails": {
          "roomType": roomType,
          "totalBeds": totalBeds,
          "availableBeds": availableBeds,
        }
    };

    try {
      final token = await PrefService.getToken();
      if (token == null || token.isEmpty) throw Exception("Token missing");

      final response = await ApiServiceMethod.updateBasicDetails(propertyId, payload);

      debugPrint("Basic Details :: $response ");

      return true;
    } catch (e) {
      error = "Failed to save basic details";
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

}
