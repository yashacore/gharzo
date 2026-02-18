import 'package:flutter/material.dart';
import 'package:gharzo_project/model/add_property_type/property_details_model.dart';
import '../../common/http/http_method.dart';

class PropertyDetailProvider extends ChangeNotifier {
  bool isLoading = false;
  PropertyDetailModel? property;
  int selectedImageIndex = 0;
  bool isFavorite = false;

  Future<void> fetchProperty(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      property = await AuthService.getPropertyDetails(id);

      debugPrint("Property details :: $property");

    } catch (e) {
      debugPrint("Error fetching property: $e");
      property = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setImageIndex(int index) {
    selectedImageIndex = index;
    notifyListeners();
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
