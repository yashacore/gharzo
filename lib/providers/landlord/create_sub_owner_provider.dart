import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:http/http.dart' as http;

class SubOwnerProvider extends ChangeNotifier {
  final String baseUrl = "https://api.gharzoreality.com/api";
  // ================= PERMISSIONS =================
  List<dynamic> permissions = [];
  final Set<String> selectedPermissionIds = {};
  bool permissionsLoading = false;
  List<dynamic> properties = [];
  final Set<String> selectedPropertyIds = {};

  bool loading = false;

  // 🔹 Fetch landlord properties
  Future<void> fetchProperties() async {
    loading = true;
    notifyListeners();

    final token = await PrefService.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/v2/properties/my-properties"),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    properties = body['data'] ?? [];

    loading = false;
    notifyListeners();
  }

  // 🔹 Toggle checkbox
  void toggleProperty(String propertyId) {
    if (selectedPropertyIds.contains(propertyId)) {
      selectedPropertyIds.remove(propertyId);
    } else {
      selectedPropertyIds.add(propertyId);
    }
    notifyListeners();
  }

  // 🔹 Build sub-owner payload
  Map<String, dynamic> buildPayload({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? notes,
  }) {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "notes": notes ?? "",
      "hasFullPropertyAccess": false,
      "assignedProperties": selectedPropertyIds.toList(),
      "permissions": [],
    };
  }

  Future<bool> createSubOwner({
    required String name,
    required String email,
    required String phone,
    required String password,
    String notes = "",
  }) async {
    debugPrint("🟢 CREATE SUB-OWNER STARTED");

    if (selectedPropertyIds.isEmpty) {
      debugPrint("❌ NO PROPERTIES SELECTED");
      return false;
    }

    loading = true;
    notifyListeners();

    final token = await PrefService.getToken();

    final payload = {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "notes": notes,
      "hasFullPropertyAccess": false,
      "assignedProperties": selectedPropertyIds.toList(),
      "permissions": selectedPermissionIds.toList(), // ✅ FIXED
    };

    debugPrint("📦 SUB-OWNER PAYLOAD:");
    payload.forEach((k, v) => debugPrint("➡️ $k : $v"));

    final res = await http.post(
      Uri.parse("$baseUrl/subowners/create"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    debugPrint("📡 STATUS CODE: ${res.statusCode}");
    debugPrint("📡 RESPONSE BODY: ${res.body}");

    loading = false;
    notifyListeners();

    final success = res.statusCode == 200 || res.statusCode == 201;

    debugPrint(
      success
          ? "🎉 SUB-OWNER CREATED SUCCESSFULLY"
          : "❌ SUB-OWNER CREATION FAILED",
    );

    return success;
  }

  // 🔹 Check if all properties are selected
  bool get isAllSelected {
    if (properties.isEmpty) return false;
    return selectedPropertyIds.length == properties.length;
  }

  // 🔹 Select all properties
  void selectAllProperties() {
    selectedPropertyIds.clear();
    for (final p in properties) {
      selectedPropertyIds.add(p['_id'].toString());
    }
    notifyListeners();
  }

  // 🔹 Clear all selections
  void clearAllProperties() {
    selectedPropertyIds.clear();
    notifyListeners();
  }

  Future<void> fetchPermissions() async {
    permissionsLoading = true;
    notifyListeners();

    final token = await PrefService.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/permissions"),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    permissions = body['data'] ?? [];

    permissionsLoading = false;
    notifyListeners();
  }

  void togglePermission(String permissionId) {
    if (selectedPermissionIds.contains(permissionId)) {
      selectedPermissionIds.remove(permissionId);
    } else {
      selectedPermissionIds.add(permissionId);
    }
    notifyListeners();
  }

  bool get isAllPermissionsSelected {
    if (permissions.isEmpty) return false;
    return selectedPermissionIds.length == permissions.length;
  }

  void selectAllPermissions() {
    selectedPermissionIds.clear();
    for (final p in permissions) {
      selectedPermissionIds.add(p['_id'].toString());
    }
    notifyListeners();
  }

  void clearAllPermissions() {
    selectedPermissionIds.clear();
    notifyListeners();
  }

  Future<bool> editSubOwner({
    required String subOwnerId,
    required String name,
    required String email,
    required String phone,
    String notes = "",
    bool hasFullPropertyAccess = false,
  }) async {
    debugPrint("🟢 EDIT SUB-OWNER STARTED");
    debugPrint("🆔 SubOwner ID: $subOwnerId");

    loading = true;
    notifyListeners();

    final token = await PrefService.getToken();
    debugPrint("🔐 Token fetched: ${token != null}");

    final payload = {
      "name": name,
      "email": email,
      "phone": phone,
      "notes": notes,
      "hasFullPropertyAccess": hasFullPropertyAccess,
      "assignedProperties": selectedPropertyIds.toList(),
      "permissions": selectedPermissionIds.toList(),
    };

    debugPrint("📦 EDIT SUB-OWNER PAYLOAD:");
    payload.forEach((k, v) => debugPrint("➡️ $k : $v"));

    final url = "$baseUrl/subowners/$subOwnerId";
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

    loading = false;
    notifyListeners();

    final success = res.statusCode == 200 || res.statusCode == 201;

    debugPrint(
      success
          ? "🎉 SUB-OWNER UPDATED SUCCESSFULLY"
          : "❌ SUB-OWNER UPDATE FAILED",
    );

    debugPrint("🟢 EDIT SUB-OWNER FINISHED");

    return success;
  }

  Future<bool> deleteSubOwner(String subOwnerId) async {
    debugPrint("🗑️ DELETE SUB-OWNER STARTED");

    final token = await PrefService.getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl/subowners/$subOwnerId"),
      headers: {"Authorization": "Bearer $token"},
    );

    debugPrint("📡 STATUS CODE: ${res.statusCode}");
    debugPrint("📡 RESPONSE BODY: ${res.body}");

    final success = res.statusCode == 200 || res.statusCode == 204;

    debugPrint(success ? "✅ SUB-OWNER DELETED" : "❌ DELETE FAILED");

    return success;
  }
}
