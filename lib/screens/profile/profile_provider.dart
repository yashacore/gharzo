import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/main.dart';


import '../login/login_view.dart';

class ProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  String userName = '';
  String profileImage = '';
  String role = '';

  Future<void> fetchProfile() async {
    isLoading = true;
    notifyListeners();

    final user = await PrefService.getUser();
    debugPrint("USER FROM PREF ::: $user");

    if (user != null) {
      userName = user['name'] ?? '';
      debugPrint("User Name::: $userName");
      profileImage = user['image'] ?? '';
      debugPrint("profileimage ::: $profileImage");
      role = user['role'] ?? '';
      debugPrint("User Role ::: $role");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> clickOnLogoutBtn() async {
    await PrefService.clearAuthData();
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => LoginView()),
    );
  }

  bool get isLandlord => role.toLowerCase() == 'landlord';

}
