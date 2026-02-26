import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/property_wishlist_model.dart';
import 'package:http/http.dart' as http;

import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/add_property_type/property_details_model.dart';
import '../../common/http/http_method.dart';

class PropertyDetailProvider extends ChangeNotifier {
  bool isLoading = false;
  PropertyDetailModel? property;
  final List<SavedPropertyModel> properties = [];
  bool isClearing = false;

  int selectedImageIndex = 0;
  bool isFavorite = false;
  bool isSaved = false;

  /// ================= FETCH PROPERTY =================
  Future<void> fetchProperty(String id) async {
    try {
      debugPrint("📥 fetchProperty() called");
      debugPrint("🆔 Property ID: $id");

      isLoading = true;
      notifyListeners();

      property = await AuthService.getPropertyDetails(id);

      debugPrint("✅ Property fetched successfully");
      debugPrint("📦 Property title: ${property?.title}");
      debugPrint("❤️ Is saved (from API if any): ${property?.isSaved}");

      // If backend sends saved flag
      isSaved = property?.isSaved ?? false;
    } catch (e) {
      debugPrint("❌ Error fetching property: $e");
      property = null;
    } finally {
      isLoading = false;
      notifyListeners();
      debugPrint("🔚 fetchProperty() completed");
    }
  }

  /// ================= IMAGE INDEX =================
  void setImageIndex(int index) {
    selectedImageIndex = index;
    debugPrint("🖼 Image index changed: $index");
    notifyListeners();
  }

  /// ================= LOCAL FAVORITE (UI ONLY) =================
  void toggleFavorite() {
    isFavorite = !isFavorite;
    debugPrint("⭐ Local favorite toggled → $isFavorite");
    notifyListeners();
  }

  /// ================= SAVE / UNSAVE =================
  Future<void> toggleSave() async {
    if (property == null) {
      debugPrint("⚠️ toggleSave() aborted → property is null");
      return;
    }

    final oldValue = isSaved;

    debugPrint("🔘 toggleSave() tapped");
    debugPrint("🆔 Property ID: ${property!.id}");
    debugPrint("❤️ Old saved state: $oldValue");

    // Optimistic UI update
    isSaved = !isSaved;
    notifyListeners();

    debugPrint("🚀 Sending save API request...");

    final success = await SavedPropertyService.toggleSaveProperty(
      propertyId: property!.id,
    );

    if (success) {
      debugPrint("✅ Save API success");
      debugPrint("❤️ New saved state: $isSaved");
    } else {
      debugPrint("❌ Save API failed → rolling back");
      isSaved = oldValue;
      notifyListeners();
    }
  }
}

/// =======================================================
/// ================= SAVED PROPERTY API ==================
/// =======================================================

class SavedPropertyService {
  static const String _baseUrl =
      "https://api.gharzoreality.com/api/saved-properties";

  final List<SavedPropertyModel> properties = [];

  /// 🔥 CLEAR ALL

  static Future<SavedPropertyResponse> fetchSavedProperties({
    int page = 1,
    int limit = 20,
  }) async {
    final token = await PrefService.getToken();

    final url = Uri.parse("$_baseUrl?page=$page&limit=$limit");

    debugPrint("📡 GET $url");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    debugPrint("📥 Status: ${response.statusCode}");
    debugPrint("📥 Body: ${response.body}");

    if (response.statusCode == 200) {
      return SavedPropertyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load saved properties");
    }
  }

  static Future<bool> toggleSaveProperty({
    required String propertyId,
    String? note,
  }) async {
    final url = Uri.parse("$_baseUrl/$propertyId");

    try {
      debugPrint("🌐 API URL: $url");

      final token = await PrefService.getToken();

      if (token == null || token.isEmpty) {
        debugPrint("❌ AUTH TOKEN NOT FOUND");
        return false;
      }

      debugPrint("🔐 Token found");
      debugPrint("📝 Note: ${note ?? 'EMPTY'}");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"note": note ?? ""}),
      );

      debugPrint("📡 Response status: ${response.statusCode}");
      debugPrint("📨 Response body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("🔥 Toggle save error: $e");
      return false;
    }
  }

  static Future<bool> clearAllSavedProperties({String? note}) async {
    try {
      final token = await PrefService.getToken();
      final url = Uri.parse("$_baseUrl/clear-all");

      debugPrint("🗑️ CLEAR ALL SAVED → $url");
      debugPrint("📝 Note: $note");

      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"note": note ?? ""}),
      );

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Response: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("❌ Clear all error: $e");
      return false;
    }
  }
}
