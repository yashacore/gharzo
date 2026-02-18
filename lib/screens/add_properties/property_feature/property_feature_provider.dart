import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:gharzo_project/common/http/http_method.dart';
import 'package:gharzo_project/model/add_property_type/amenity_model.dart';
import 'package:gharzo_project/screens/add_properties/property_details/property_details_view.dart';

class FeaturesProvider extends ChangeNotifier {
  bool loading = false;
  String? error;

  // ---------------- FURNISHING
  String furnishingType = "Unfurnished";
  List<String> furnishingItems = [];

  // ---------------- PARKING
  int coveredParking = 0;
  int openParking = 0;

  // ---------------- FACING
  String? facing;

  // ---------------- AMENITIES
  List<String> amenitiesList = [];

  // Backend master amenities
  List<AmenityModel> basicAmenities = [];
  List<AmenityModel> societyAmenities = [];
  List<AmenityModel> nearbyAmenities = [];

  // ---------------- PROPERTY RULES
  String powerBackup = "None"; // None / Partial / Full
  String waterSupply = "Both"; // Borewell / Corporation / Both
  bool liftAvailable = false;

  // ---------------- INIT ----------------
  FeaturesProvider() {
    fetchAmenities();
  }

  // ---------------- FETCH MASTER AMENITIES ----------------
  Future<void> fetchAmenities() async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final res = await AuthService.getAmenities();
      final data = res['data'];

      basicAmenities = (data['basic'] as List? ?? [])
          .map((e) => AmenityModel.fromString(e.toString()))
          .toList();

      societyAmenities = (data['society'] as List? ?? [])
          .map((e) => AmenityModel.fromString(e.toString()))
          .toList();

      nearbyAmenities = (data['nearby'] as List? ?? [])
          .map((e) => AmenityModel.fromString(e.toString()))
          .toList();
    } catch (e) {
      error = "Failed to load amenities";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ---------------- TOGGLE ----------------
  void toggleItem(List<String> list, String value) {
    list.contains(value) ? list.remove(value) : list.add(value);
    notifyListeners();
  }

  void toggleAmenity(String value) {
    amenitiesList.contains(value)
        ? amenitiesList.remove(value)
        : amenitiesList.add(value);
    notifyListeners();
  }

  // ---------------- PROPERTY RULES ----------------
  void setPowerBackup(String value) {
    powerBackup = value;
    notifyListeners();
  }

  void setWaterSupply(String value) {
    waterSupply = value;
    notifyListeners();
  }

  void setLiftAvailable(bool value) {
    liftAvailable = value;
    notifyListeners();
  }

  // ---------------- VALIDATION ----------------
  bool validate() {
    if (facing == null || facing!.isEmpty) {
      error = "Facing required";
      notifyListeners();
      return false;
    }
    return true;
  }

  // ---------------- SUBMIT ----------------
  Future<bool> submit(String propertyId) async {
    if (!validate()) return false;

    loading = true;
    error = null;
    notifyListeners();

    final body = {
      "furnishingType": furnishingType,
      "furnishingItems": furnishingItems,
      "coveredParking": coveredParking,
      "openParking": openParking,
      "facing": facing,
      "amenities": amenitiesList,
      "powerBackup": powerBackup,
      "waterSupply": waterSupply,
      "liftAvailable": liftAvailable,
    };

    try {
      final response = await ApiServiceMethod.updateFeatures(propertyId, body);

      debugPrint("Property Feature :: $response");
      if (response['success'] == true) {
        return true;
      } else {
        error = response['message'];
        return false;
      }
    } catch (e) {
      error = "Failed to save features";
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void clickOnBtn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BasicDetailsView(propertyId: '', listingType: '')),
          // (route) => false,
    );
  }

}
