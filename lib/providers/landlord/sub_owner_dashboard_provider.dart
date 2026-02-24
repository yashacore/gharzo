import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:http/http.dart' as http;

class SubOwnerDashboardProvider extends ChangeNotifier {
  final String baseUrl = "https://api.gharzoreality.com/api";

  bool loading = false;
  List<dynamic> subOwners = [];

  Future<void> fetchSubOwners({int page = 1, int limit = 10}) async {
    loading = true;
    notifyListeners();

    final token = await PrefService.getToken();

    final res = await http.get(
      Uri.parse(
        "$baseUrl/subowners/my-subowners?status=Active&page=$page&limit=$limit",
      ),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    subOwners = body['data'] ?? [];

    loading = false;
    notifyListeners();
  }

  // ================= EDIT PERMISSIONS =================

  bool updatingPermissions = false;
  List<dynamic> allPermissions = []; // from /api/permissions
  final Set<String> tempSelectedPermissionCodes = {};

  Future<void> fetchAllPermissions() async {
    final token = await PrefService.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/permissions"),
      headers: {"Authorization": "Bearer $token"},
    );
    final body = jsonDecode(res.body);
    allPermissions = body['data'] ?? [];
    notifyListeners();
  }

  void initPermissionSelection(List<dynamic> currentPermissions) {
    tempSelectedPermissionCodes.clear();
    for (final p in currentPermissions) {
      tempSelectedPermissionCodes.add(p['code']);
    }
    notifyListeners();
  }

  void toggleTempPermission(String code) {
    if (tempSelectedPermissionCodes.contains(code)) {
      tempSelectedPermissionCodes.remove(code);
    } else {
      tempSelectedPermissionCodes.add(code);
    }
    notifyListeners();
  }

  bool get isAllTempSelected =>
      allPermissions.isNotEmpty &&
      tempSelectedPermissionCodes.length == allPermissions.length;

  void selectAllTempPermissions() {
    tempSelectedPermissionCodes.clear();
    for (final p in allPermissions) {
      tempSelectedPermissionCodes.add(p['code']);
    }
    notifyListeners();
  }

  void clearAllTempPermissions() {
    tempSelectedPermissionCodes.clear();
    notifyListeners();
  }

  Future<bool> updateSubOwnerPermissions({required String subOwnerId}) async {
    debugPrint("🟢 UPDATE SUB-OWNER PERMISSIONS STARTED");
    debugPrint("🆔 SubOwner ID: $subOwnerId");

    updatingPermissions = true;
    notifyListeners();
    debugPrint("⏳ updatingPermissions = true");

    final token = await PrefService.getToken();
    debugPrint("🔐 Token fetched: ${token != null}");

    final payload = {"permissions": tempSelectedPermissionCodes.toList()};

    debugPrint("📦 PERMISSIONS PAYLOAD:");
    for (final p in tempSelectedPermissionCodes) {
      debugPrint("➡️ $p");
    }

    final url = "$baseUrl/subowners/$subOwnerId/permissions";
    debugPrint("🌐 PUT URL: $url");

    final res = await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    debugPrint("📡 STATUS CODE: ${res.statusCode}");
    debugPrint("📡 RESPONSE BODY: ${res.body}");

    updatingPermissions = false;
    notifyListeners();
    debugPrint("✅ updatingPermissions = false");

    final success = res.statusCode == 200 || res.statusCode == 201;

    debugPrint(
      success
          ? "🎉 PERMISSIONS UPDATED SUCCESSFULLY"
          : "❌ FAILED TO UPDATE PERMISSIONS",
    );

    debugPrint("🟢 UPDATE SUB-OWNER PERMISSIONS FINISHED");

    return success;
  }

  Future<bool> toggleSubOwnerStatus({
    required String subOwnerId,
    required bool makeActive,
  }) async {
    debugPrint("🔁 TOGGLE SUB-OWNER STATUS STARTED");

    final token = await PrefService.getToken();

    final payload = {"status": makeActive ? "Active" : "Inactive"};

    debugPrint("📦 TOGGLE PAYLOAD: $payload");

    final res = await http.patch(
      Uri.parse(
        "https://api.gharzoreality.com/api/subowners/$subOwnerId/toggle-status",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    debugPrint("📡 STATUS CODE: ${res.statusCode}");
    debugPrint("📡 RESPONSE BODY: ${res.body}");

    final success = res.statusCode == 200 || res.statusCode == 201;

    debugPrint(
      success ? "✅ STATUS UPDATED SUCCESSFULLY" : "❌ STATUS UPDATE FAILED",
    );

    return success;
  }
}
