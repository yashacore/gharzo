import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:http_parser/http_parser.dart';

class AnnouncementProvider extends ChangeNotifier {
  final String baseUrl = "https://api.gharzoreality.com/api";

  bool loading = false;
  bool creating = false;

  // ================= ANNOUNCEMENTS =================
  List<dynamic> announcements = [];

  // ================= PROPERTIES =================
  List<dynamic> properties = [];
  final Set<String> selectedPropertyIds = {};

  // ================= TARGET AUDIENCE =================
  String targetAudience = "All Tenants";

  // ================= FETCH ANNOUNCEMENTS =================
  Future<void> fetchAnnouncements() async {
    loading = true;
    notifyListeners();

    final token = await PrefService.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/announcements/my-announcements"),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    announcements = body['data'] ?? [];

    loading = false;
    notifyListeners();
  }

  // ================= FETCH PROPERTIES =================
  Future<void> fetchProperties() async {
    final token = await PrefService.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/v2/properties/my-properties"),
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(res.body);
    properties = body['data'] ?? [];
    notifyListeners();
  }

  void toggleProperty(String id) {
    selectedPropertyIds.contains(id)
        ? selectedPropertyIds.remove(id)
        : selectedPropertyIds.add(id);
    notifyListeners();
  }

  void clearPropertySelection() {
    selectedPropertyIds.clear();
    notifyListeners();
  }

  // ================= CREATE ANNOUNCEMENT =================
  Future<bool> createAnnouncement({
    required String title,
    required String message,
    required String type,
    required String priority,
    required bool isPinned,
    required bool visibleToLandlord,
    required DateTime scheduledFor,
    required DateTime expiresAt,
    File? attachment,
  }) async {
    creating = true;
    notifyListeners();

    final token = await PrefService.getToken();

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/announcements/create"),
    );

    request.headers['Authorization'] = "Bearer $token";

    // ===== TEXT FIELDS =====
    request.fields.addAll({
      "title": title,
      "message": message,
      "targetAudience": targetAudience,
      "type": type,
      "priority": priority,
      "isPinned": isPinned.toString(),
      "visibleToLandlord": visibleToLandlord.toString(),
      "scheduledFor": scheduledFor.toIso8601String(),
      "expiresAt": expiresAt.toIso8601String(),
    });

    if (targetAudience == "Specific Properties") {
      for (final id in selectedPropertyIds) {
        request.fields.putIfAbsent("targetProperties[]", () => id);
      }
    }

    // ===== ATTACHMENT (🔥 THIS IS THE KEY FIX) =====
    if (attachment != null) {
      final ext = attachment.path.split('.').last.toLowerCase();

      final mimeType = {
        "jpg": "image/jpeg",
        "jpeg": "image/jpeg",
        "png": "image/png",
        "pdf": "application/pdf",
        "doc": "application/msword",
        "docx":
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      }[ext];

      debugPrint("📎 Adding attachment: ${attachment.path}");
      debugPrint("📎 MIME TYPE: $mimeType");

      request.files.add(
        await http.MultipartFile.fromPath(
          "attachments", // ✅ MUST BE THIS
          attachment.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    debugPrint("📡 STATUS: ${response.statusCode}");
    debugPrint("📡 BODY: $body");

    creating = false;
    notifyListeners();

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
