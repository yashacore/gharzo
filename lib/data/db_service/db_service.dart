import 'dart:convert';

import 'package:gharzo_project/model/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {

  static const onboardingView = 'onboarding_view';
  static const tokenKey = 'token';
  static const userKey = 'user';

  static Future<void> saveAuthData({
    required String token,
    required String userJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(tokenKey, token);
    await prefs.setString(userKey, userJson);

    print('💾 AUTH DATA STORED');
    print('🔑 token: $token');
    print('👤 user: $userJson');
  }

  static Future<void> saveOnboardingPageViews() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(onboardingView, true);
  }

  static Future<bool> getOnboardingPageViews() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingView) ?? false;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userKey);
  }


  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(userKey);
    return data != null ? jsonDecode(data) : null;
  }


  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(userKey, userJson);
  }
}
