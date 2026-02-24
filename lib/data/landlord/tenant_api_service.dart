import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:http/http.dart' as http;

class TenancyApiService {
  static const baseUrl = "https://api.gharzoreality.com/api";

  static Future<List<dynamic>> fetchMyProperties() async {
    final token = await PrefService.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/v2/properties/my-properties"),
      headers: {"Authorization": "Bearer $token"},
    );
    final body = jsonDecode(res.body);
    return body['data'] ?? [];
  }

  static Future<List<dynamic>> fetchRoomsByProperty(String propertyId) async {
    final token = await PrefService.getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/rooms/property/$propertyId"),
      headers: {"Authorization": "Bearer $token"},
    );
    final body = jsonDecode(res.body);
    return body['data'] ?? [];
  }

  static Future<bool> createTenancy(Map<String, dynamic> payload) async {
    debugPrint("📡 CREATE TENANCY API STARTED");

    final token = await PrefService.getToken();
    debugPrint("🔐 TOKEN EXISTS: ${token != null}");

    final res = await http.post(
      Uri.parse("$baseUrl/tenancies/create"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    debugPrint("📡 STATUS CODE: ${res.statusCode}");
    debugPrint("📡 RESPONSE BODY: ${res.body}");

    final success = res.statusCode == 200 || res.statusCode == 201;

    debugPrint("✅ API SUCCESS = $success");

    return success;
  }
}
