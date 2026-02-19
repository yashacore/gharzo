import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/property_wishlist_model.dart';
import 'package:gharzo_project/screens/property_details/property_details_provider.dart';

class SavedPropertyProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = "";
  bool isClearing = false;

  int currentPage = 1;
  int totalPages = 1;

  final List<SavedPropertyModel> properties = [];

  Future<void> fetchSavedProperties({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      properties.clear();
      currentPage = 1;
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await SavedPropertyService.fetchSavedProperties(
        page: currentPage,
      );

      properties.addAll(response.data);
      totalPages = response.totalPages;
      currentPage++;

      debugPrint("❤️ Saved loaded: ${properties.length}");
    } catch (e) {
      error = e.toString();
      debugPrint("❌ Error: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearAllSaved({String? note}) async {
    if (properties.isEmpty) return;

    isClearing = true;
    notifyListeners();

    debugPrint("⚠️ Clearing ${properties.length} saved properties");

    final success = await SavedPropertyService.clearAllSavedProperties(
      note: note,
    );

    if (success) {
      properties.clear();
      debugPrint("✅ All saved properties cleared");
    } else {
      debugPrint("❌ Failed to clear saved properties");
    }

    isClearing = false;
    notifyListeners();
  }

}
