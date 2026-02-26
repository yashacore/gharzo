import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gharzo_project/model/user_model/user_model.dart';
import 'package:gharzo_project/screens/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static const onboardingView = 'onboarding_view';
  static const tokenKey = 'token';
  static const userKey = 'user';
  static const roleKey = 'role';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveAuthData({
    required String token,
    required String userJson,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(tokenKey, token);
    await prefs.setString(userKey, userJson);
    await prefs.setString(roleKey, role);

    print('💾 AUTH DATA STORED');
    print('🔑 token: $token');
    print('👤 user: $userJson');
    print('👤 user: $role');
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

  static const _fcmTokenKey = "fcm_token";

  static Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, token);
    debugPrint("✅ FCM Token saved: $token");
  }

  /// 📤 GET FCM TOKEN
  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_fcmTokenKey);
    final role = prefs.getString(roleKey);
    debugPrint("📦 FCM Token fetched: $token");
    debugPrint("📦 role fetched: $role");
    return token;
  }

  /// ❌ CLEAR (optional)
  static Future<void> clearFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fcmTokenKey);

    debugPrint("🗑️ FCM Token cleared");
  }

  static String? getRoleSync() {
    return _prefs?.getString(roleKey);
  }
  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    debugPrint('🚪 LOGOUT INITIATED');

    // Optional: get values before clearing (for logs / API)
    final token = prefs.getString(tokenKey);
    final role = prefs.getString(roleKey);
    final fcm = prefs.getString(_fcmTokenKey);

    debugPrint('🔑 Token before logout: $token');
    debugPrint('👤 Role before logout: $role');
    debugPrint('📲 FCM before logout: $fcm');

    // 🔥 Clear all auth-related data
    await prefs.remove(tokenKey);
    await prefs.remove(userKey);
    await prefs.remove(roleKey);
    await prefs.remove(_fcmTokenKey);

    debugPrint('🗑️ Auth + FCM data cleared');

    // 🔁 Navigate to Login (replace all routes)
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }

    debugPrint('✅ Logout completed');
  }
}
