import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/data/db_service/db_service.dart';

class ComplaintDashboardProvider extends ChangeNotifier {
  final String baseUrl = "https://api.gharzoreality.com/api";

  bool loading = false;

  List<dynamic> complaints = [];
  Map<String, dynamic> stats = {};

  int page = 1;
  int totalPages = 1;
  int totalCount = 0;

  // ================= FETCH COMPLAINTS =================

  Future<void> fetchLandlordComplaints({int page = 1}) async {
    debugPrint("🟢 FETCH LANDLORD COMPLAINTS STARTED");
    debugPrint("➡️ page: $page");

    loading = true;
    notifyListeners();

    final token = await PrefService.getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/complaints/landlord/all-complaints?page=$page"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    debugPrint("📡 STATUS: ${res.statusCode}");
    debugPrint("📡 BODY: ${res.body}");

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      complaints = body['data'] ?? [];
      stats = body['stats'] ?? {};

      this.page = body['page'] ?? 1;
      totalPages = body['pages'] ?? 1;
      totalCount = body['total'] ?? 0;

      debugPrint("✅ COMPLAINTS LOADED: ${complaints.length}");
      debugPrint("📊 STATS: $stats");
    } else {
      debugPrint("❌ FAILED TO FETCH COMPLAINTS");
    }

    loading = false;
    notifyListeners();
  }
}
