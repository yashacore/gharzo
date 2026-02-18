import 'package:flutter/material.dart';
import 'package:gharzo_project/common/http/http_method.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/add_property_type/city_model.dart';
import 'package:gharzo_project/screens/add_properties/property_feature/property_feture_view.dart';

class LocationProvider extends ChangeNotifier {
  bool loading = false;
  bool cityLoading = false;
  bool localityLoading = false;
  String? error;

  String address = "";
  String pinCode = "";
  String state = "";
  String landmark = "";
  String subLocality = "";
  double latitude = 0;
  double longitude = 0;

  List<CityModel> cities = [];
  List<LocalityModel> localities = [];

  CityModel? selectedCity;
  LocalityModel? selectedLocality;

  // ---------------- FETCH CITIES ----------------
  Future<void> fetchCities() async {
    cityLoading = true;
    error = null;
    notifyListeners();

    try {
      cities = await AuthService.getCities();
    } catch (e) {
      error = "Failed to load cities";
    } finally {
      cityLoading = false;
      notifyListeners();
    }
  }

  // ---------------- SELECT CITY ----------------
  void selectCity(CityModel city) {
    selectedCity = city;
    selectedLocality = null;
    localities.clear();
    state = city.state;
    fetchLocalities(city.name);
    notifyListeners();
  }

  // ---------------- FETCH LOCALITIES ----------------
  Future<void> fetchLocalities(String cityName) async {
    localityLoading = true;
    error = null;
    notifyListeners();

    try {
      localities = await AuthService.getLocalities(cityName);
    } catch (e) {
      error = "Failed to load localities";
    } finally {
      localityLoading = false;
      notifyListeners();
    }
  }

  void selectLocality(LocalityModel loc) {
    selectedLocality = loc;
    notifyListeners();
  }

  // ---------------- VALIDATION ----------------
  bool validate() {
    if (selectedCity == null) return _err("City required");
    if (selectedLocality == null) return _err("Locality required");
    if (address.isEmpty) return _err("Address required");
    if (pinCode.isEmpty) return _err("Pincode required");
    return true;
  }

  bool _err(String msg) {
    error = msg;
    notifyListeners();
    return false;
  }

  // ---------------- SUBMIT ----------------
  Future<bool> submit(String propertyId) async {
    if (!validate()) return false;

    loading = true;
    error = null;
    notifyListeners();

    final body = {
      "address": address,
      "city": selectedCity!.name,
      "locality": selectedLocality!.name,
      "subLocality": subLocality,
      "landmark": landmark,
      "pincode": pinCode,
      "state": state,
      "coordinates": {
        "latitude": latitude,
        "longitude": longitude,
      },
    };

    try {
      final token = await PrefService.getToken();
      if (token == null || token.isEmpty) throw Exception("Token missing");

      final res = await AuthService.updatePropertyLocation(
        token: token,
        propertyId: propertyId,
        location: body,
      );

      debugPrint("📍 LOCATION RESPONSE => $res");

      if (res['success'] == true) {
        return true;
      } else {
        error = res['message'] ?? "Location save failed";
        return false;
      }
    } catch (e) {
      debugPrint("❌ LOCATION ERROR => $e");
      error = "Location save failed";
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void clickOnBtn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PropertyFeatureView(propertyId: '')),
    );
  }
}
