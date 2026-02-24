import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/model/my_visit_model.dart';
import 'package:gharzo_project/model/model/user_model/visit_details_model.dart';
import 'package:http/http.dart' as http;

class VisitService {
  static const String baseUrl =
      "https://api.gharzoreality.com/api/visits/create";

  // ================= CREATE VISIT =================
  static Future<bool> createVisit(Map<String, dynamic> data) async {
    try {
      final token = await PrefService.getToken();

      debugPrint("🟡 CREATE VISIT API");
      debugPrint("➡️ URL: $baseUrl");
      debugPrint("➡️ TOKEN: $token");
      debugPrint("➡️ PAYLOAD: ${jsonEncode(data)}");

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      debugPrint("⬅️ STATUS CODE: ${response.statusCode}");
      debugPrint("⬅️ RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("❌ CREATE VISIT EXCEPTION: $e");
      return false;
    }
  }

  // ================= FETCH MY VISITS =================
  static Future<MyVisitResponse?> fetchMyVisits() async {
    final token = await PrefService.getToken();
    const url = "https://api.gharzoreality.com/api/visits/my-requests";

    debugPrint("🟡 FETCH MY VISITS");
    debugPrint("➡️ URL: $url");
    debugPrint("➡️ TOKEN: $token");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    debugPrint("⬅️ STATUS CODE: ${response.statusCode}");
    debugPrint("⬅️ RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MyVisitResponse.fromJson(data);
    }

    return null;
  }

  // ================= FETCH VISIT DETAIL =================
  static Future<VisitDetailModel?> fetchVisitDetail(String visitId) async {
    final token = await PrefService.getToken();
    final url = "https://api.gharzoreality.com/api/visits/$visitId";

    debugPrint("🟡 FETCH VISIT DETAIL");
    debugPrint("➡️ URL: $url");
    debugPrint("➡️ TOKEN: $token");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    debugPrint("⬅️ STATUS CODE: ${response.statusCode}");
    debugPrint("⬅️ RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return VisitDetailModel.fromJson(body['data']);
    }

    return null;
  }

  // ================= CANCEL VISIT =================
  static Future<bool> cancelVisit({
    required String visitId,
    required String reason,
  }) async {
    final token = await PrefService.getToken();
    final url = "https://api.gharzoreality.com/$visitId/cancel";

    debugPrint("🟡 CANCEL VISIT");
    debugPrint("➡️ URL: $url");
    debugPrint("➡️ TOKEN: $token");
    debugPrint("➡️ REASON: $reason");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"reason": reason}),
    );

    debugPrint("⬅️ STATUS CODE: ${response.statusCode}");
    debugPrint("⬅️ RESPONSE: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    debugPrint("❌ CANCEL VISIT FAILED");
    return false;
  }

  // ================= RATE VISIT =================
  static Future<bool> rateVisit({
    required String visitId,
    required int rating,
    required String review,
    required List<String> liked,
    required List<String> disliked,
    required bool interestedInBuying,
  }) async {
    final token = await PrefService.getToken();
    final url = "https://api.gharzoreality.com/api/visits/$visitId/rate";

    debugPrint("🟡 RATE VISIT");
    debugPrint("➡️ URL: $url");
    debugPrint("➡️ TOKEN: $token");
    debugPrint(
      "➡️ PAYLOAD: ${jsonEncode({"rating": rating, "review": review, "liked": liked, "disliked": disliked, "interestedInBuying": interestedInBuying})}",
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "rating": rating,
        "review": review,
        "liked": liked,
        "disliked": disliked,
        "interestedInBuying": interestedInBuying,
      }),
    );

    debugPrint("⬅️ STATUS CODE: ${response.statusCode}");
    debugPrint("⬅️ RESPONSE: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    debugPrint("❌ RATE VISIT FAILED");
    return false;
  }
}
