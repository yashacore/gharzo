import 'package:flutter/material.dart';
import 'package:gharzo_project/common/lanloard_api_method/lanloard_api_method.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/lanloard/get_lanloard_property_model.dart';
import 'package:gharzo_project/screens/profile/profile_view.dart';

class DashboardProvider extends ChangeNotifier {
  List<LanloardPropertyModel> _properties = [];
  bool isLoading = false;

  List<LanloardPropertyModel> get properties => _properties;




  final LanloardApiService service = LanloardApiService();

  DashboardProvider() {
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await PrefService.getToken();
      final userData = await PrefService.getUser(); // Get saved user
      final role = userData?['role'] ?? '';

      print("===== DASHBOARD PROVIDER =====");
      print("Token: $token");
      print("User Role: $role");

      if (token != null && token.isNotEmpty && role.toLowerCase() == 'landlord') {
        print("Fetching properties for landlord...");

        final fetchedProperties = await service.fetchMyProperties(token);

        debugPrint("Fetch Lanloard Properties :: $fetchedProperties");

        for (var property in fetchedProperties) {
          print("🏠 Property: ${property.title}, Status: ${property.status}");
        }

        _properties = fetchedProperties;
      } else {
        print("Token not found or user is not a landlord!");
        _properties = [];
      }
    } catch (e) {
      print("Error fetching properties: $e");
      _properties = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void clickOnBtn(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ProfilePage()),
          (route) => false,
    );
  }
}
