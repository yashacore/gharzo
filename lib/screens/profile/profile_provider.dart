import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';
import '../../model/model/profile_model.dart';
import '../login/login_view.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;

  User? _user;
  User? get user => _user;

  /// 🔹 Fetch profile from SharedPref and parse into model
  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    final rawUser = await PrefService.getUser();
    debugPrint("RAW USER FROM PREF => $rawUser");

    if (rawUser != null) {
      _user = User.fromJson(rawUser);
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔹 Logout
  Future<void> clickOnLogoutBtn() async {
    await PrefService.clearAuthData();

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginView()),
      (route) => false,
    );
  }

  /// 🔹 Helper getters for UI
  String get userName => _user?.name ?? '';
  String get phone => _user?.phone ?? '';
  String get role => _user?.role ?? '';
  String? get profileImage => _user?.profileImage;
  bool get isVerified => _user?.isVerified ?? false;
  String get city => _user?.address.city ?? '';
  String get state => _user?.address.state ?? '';

  bool get isLandlord => role.toLowerCase() == 'landlord';
}
