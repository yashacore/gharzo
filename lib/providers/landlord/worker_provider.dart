import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/data/db_service/db_service.dart';

class WorkerProvider extends ChangeNotifier {
  final String baseUrl = "https://api.gharzoreality.com/api";

  bool loading = false;
  bool creating = false;
  List<dynamic> properties = [];
  final Set<String> selectedPropertyIds = {};
  bool propertiesLoading = false;
  List<dynamic> workers = [];

  // ================= FETCH WORKERS =================
  Future<void> fetchWorkers() async {
    loading = true;
    notifyListeners();

    final token = await PrefService.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/workers/my-workers"),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    workers = body['data'] ?? [];

    loading = false;
    notifyListeners();
  }

  // ================= CREATE WORKER =================
  Future<bool> createWorker(Map<String, dynamic> payload) async {
    debugPrint("🟢 CREATE WORKER STARTED");

    final token = await PrefService.getToken();

    debugPrint("📦 WORKER JSON PAYLOAD:");
    payload.forEach((k, v) => debugPrint("➡️ $k : $v"));

    final res = await http.post(
      Uri.parse("$baseUrl/workers/create"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    debugPrint("📡 STATUS: ${res.statusCode}");
    debugPrint("📡 BODY: ${res.body}");

    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<void> fetchMyProperties() async {
    propertiesLoading = true;
    notifyListeners();

    final token = await PrefService.getToken();

    final res = await http.get(
      Uri.parse(
        "https://api.gharzoreality.com/api/v2/properties/my-properties",
      ),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    properties = body['data'] ?? [];

    propertiesLoading = false;
    notifyListeners();
  }

  void toggleProperty(String id) {
    if (selectedPropertyIds.contains(id)) {
      selectedPropertyIds.remove(id);
    } else {
      selectedPropertyIds.add(id);
    }
    notifyListeners();
  }

  void clearProperties() {
    selectedPropertyIds.clear();
    notifyListeners();
  }

  Future<Map<String, dynamic>?> fetchWorkerDetail(String workerId) async {
    final token = await PrefService.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/workers/$workerId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body['data'];
    }

    return null;
  }

  Future<bool> deleteWorker(String workerId) async {
    debugPrint("🗑️ DELETE WORKER STARTED: $workerId");

    try {
      final token = await PrefService.getToken();

      final res = await http.delete(
        Uri.parse("$baseUrl/workers/$workerId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 204) {
        debugPrint("✅ WORKER DELETED SUCCESSFULLY");
        return true;
      }

      debugPrint("❌ FAILED TO DELETE WORKER");
      return false;
    } catch (e) {
      debugPrint("🔥 DELETE WORKER ERROR: $e");
      return false;
    }
  }

  Future<bool> toggleWorkerStatus({
    required String workerId,
    required String status, // "Active" | "Inactive"
  }) async {
    debugPrint("🔁 TOGGLE WORKER STATUS STARTED");
    debugPrint("🆔 Worker ID: $workerId");
    debugPrint("📦 Payload: { status: $status }");

    try {
      final token = await PrefService.getToken();

      final res = await http.patch(
        Uri.parse("$baseUrl/workers/$workerId/toggle-status"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "status": status,
        }),
      );

      debugPrint("📡 STATUS CODE: ${res.statusCode}");
      debugPrint("📡 RESPONSE BODY: ${res.body}");

      final success = res.statusCode == 200 || res.statusCode == 201;

      debugPrint(
        success
            ? "✅ WORKER STATUS UPDATED SUCCESSFULLY"
            : "❌ FAILED TO UPDATE WORKER STATUS",
      );

      return success;
    } catch (e, st) {
      debugPrint("💥 ERROR TOGGLING WORKER STATUS: $e");
      debugPrint("📍 STACK TRACE: $st");
      return false;
    }
  }

  Future<bool> updateWorker({
    required String workerId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      debugPrint("🟡 UPDATE WORKER STARTED");
      debugPrint("🆔 Worker ID: $workerId");

      loading = true;
      notifyListeners();

      final token = await PrefService.getToken();
      debugPrint("🔐 Token fetched: ${token != null ? 'YES' : 'NO'}");

      debugPrint("🌐 API URL: $baseUrl/api/workers/$workerId");

      debugPrint("📦 UPDATE WORKER PAYLOAD:");
      payload.forEach((key, value) {
        debugPrint("➡️ $key : $value");
      });

      final res = await http.put(
        Uri.parse("$baseUrl/workers/$workerId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📡 RESPONSE STATUS CODE: ${res.statusCode}");
      debugPrint("📡 RESPONSE BODY: ${res.body}");

      loading = false;
      notifyListeners();

      if (res.statusCode == 200) {
        debugPrint("✅ WORKER UPDATED SUCCESSFULLY");
        return true;
      } else {
        debugPrint("❌ WORKER UPDATE FAILED");
        return false;
      }
    } catch (e, stack) {
      loading = false;
      notifyListeners();

      debugPrint("🔥 EXCEPTION IN UPDATE WORKER");
      debugPrint("❌ ERROR: $e");
      debugPrint("🧵 STACKTRACE: $stack");

      return false;
    }
  }

}
