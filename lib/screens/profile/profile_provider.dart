import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import '../../model/model/profile_model.dart';
import '../login/login_view.dart';

class ProfileProvider extends ChangeNotifier {
  User? _user;
  bool isLoading = false;

  User? get user => _user;

  String get userName => _user?.name ?? '';
  String get role => _user?.role ?? '';
  String? get profileImage => _user?.profileImageUrl;

  bool get isLandlord => _user?.role == 'landlord';

  // -------------------------------
  // FETCH PROFILE (API ONLY)
  // -------------------------------
  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await PrefService.getToken(); // token only
      if (token == null) return;

      final res = await http.get(
        Uri.parse("https://api.gharzoreality.com/api/auth/me"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final decoded = jsonDecode(res.body);

      if (res.statusCode == 200 && decoded['success'] == true) {
        _user = User.fromJson(decoded['data']['user']);
        debugPrint("✅ PROFILE FETCHED FROM API");
        debugPrint("🖼️ Image => ${_user?.profileImageUrl}");
      }
    } catch (e) {
      debugPrint("❌ Fetch profile error => $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------
  // LOGOUT
  // -------------------------------
  Future<void> clickOnLogoutBtn() async {

  }
}