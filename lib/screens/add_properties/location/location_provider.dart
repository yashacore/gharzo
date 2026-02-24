import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:gharzo_project/common/http/http_method.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/add_property_type/city_model.dart';
import 'package:gharzo_project/screens/add_properties/property_feature/property_feture_view.dart';

class LocationProvider extends ChangeNotifier {
  bool loading = false;
  bool cityLoading = false;
  bool localityLoading = false;
  String? error;

  // 🔥 CONTROLLERS (IMPORTANT)
  final addressCtrl = TextEditingController();
  final pinCodeCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final subLocalityCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lngCtrl = TextEditingController();

  List<CityModel> cities = [];
  List<LocalityModel> localities = [];

  CityModel? selectedCity;
  LocalityModel? selectedLocality;

  String address = "";
  String pinCode = "";
  String state = "";
  String landmark = "";
  String subLocality = "";
  double latitude = 0;
  double longitude = 0;

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
  // bool validate() {
  //   if (selectedCity == null) return _err("City required");
  //   if (selectedLocality == null) return _err("Locality required");
  //   if (address.isEmpty) return _err("Address required");
  //   if (pinCode.isEmpty) return _err("Pincode required");
  //   return true;
  // }

  bool _err(String msg) {
    error = msg;
    notifyListeners();
    return false;
  }

  Future<void> load(String propertyId) async {
    await fetchCities();
    // await loadProperty(propertyId);
  }

  Future<void> loadProperty(String propertyId) async {
    try {
      final res = await ApiServiceMethod.getPropertyById(propertyId);
      if (res['success'] != true) return;

      final loc = res['data']['location'] ?? {};

      addressCtrl.text = loc['address'] ?? "";
      pinCodeCtrl.text = loc['pincode'] ?? "";
      stateCtrl.text = loc['state'] ?? "";
      landmarkCtrl.text = loc['landmark'] ?? "";
      subLocalityCtrl.text = loc['subLocality'] ?? "";

      if (loc['coordinates'] != null) {
        latCtrl.text = loc['coordinates']['latitude']?.toString() ?? "";
        lngCtrl.text = loc['coordinates']['longitude']?.toString() ?? "";
      }

      // City selection
      if (loc['city'] != null) {
        selectedCity = cities.firstWhere((c) => c.name == loc['city']);
        await fetchLocalities(selectedCity!.name);
      }

      // Locality selection
      if (loc['locality'] != null) {
        selectedLocality = localities.firstWhere(
          (l) => l.name == loc['locality'],
        );
      }

      notifyListeners();
    } catch (e) {
      error = "Failed to load location";
    }
  }

  Future<bool> submit(String propertyId) async {
    // if (!validate()) return false;

    loading = true;
    error = null;
    notifyListeners();

    final body = {
      "address": addressCtrl.text,
      "city": selectedCity?.name,
      "locality": selectedLocality?.name,
      "subLocality": subLocalityCtrl.text,
      "landmark": landmarkCtrl.text,
      "pincode": pinCodeCtrl.text,
      "state": stateCtrl.text,
      "coordinates": {
        "latitude": double.tryParse(latCtrl.text),
        "longitude": double.tryParse(lngCtrl.text),
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

  Future<void> setFromMap(Map<String, dynamic> data) async {
    latitude = data['latitude'];
    longitude = data['longitude'];

    latCtrl.text = latitude.toString();
    lngCtrl.text = longitude.toString();

    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        // ✅ ADDRESS
        addressCtrl.text = "${p.street ?? ""}, ${p.subLocality ?? ""}".trim();

        // ✅ STATE
        stateCtrl.text = p.administrativeArea ?? "";

        // ✅ PINCODE
        pinCodeCtrl.text = p.postalCode ?? "";

        // ✅ CITY AUTO SELECT
        final cityName = p.locality ?? p.subAdministrativeArea;

        if (cityName != null) {
          final city = cities.firstWhere(
            (c) => c.name.toLowerCase() == cityName.toLowerCase(),
            orElse: () => cities.first,
          );

          selectedCity = city;
          await fetchLocalities(city.name);
        }

        // ✅ LOCALITY AUTO SELECT
        final localityName = p.subLocality;
        if (localityName != null && localities.isNotEmpty) {
          selectedLocality = localities.firstWhere(
            (l) => l.name.toLowerCase() == localityName.toLowerCase(),
            orElse: () => localities.first,
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Reverse geocoding failed: $e");
    }

    notifyListeners();
  }
}
