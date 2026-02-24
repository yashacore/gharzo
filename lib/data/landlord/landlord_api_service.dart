import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/lanloard/my_property_model.dart';
import 'package:gharzo_project/model/my_properties_model.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class MyPropertiesApiService {
  static const String _url =
      "https://api.gharzoreality.com/api/v2/properties/my-properties";

  static Future<List<MyProperty>> fetchMyProperties() async {
    try {
      final token = await PrefService.getToken();

      debugPrint("🟡 Fetch My Properties API");
      debugPrint("➡️ URL: $_url");

      final response = await http.get(
        Uri.parse(_url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("⬅️ Status: ${response.statusCode}");
      debugPrint("⬅️ Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List list = body['data'];
        return list.map((e) => MyProperty.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("❌ My Properties Error: $e");
    }
    return [];
  }

  static Future<PropertyDetailsModel?> fetchPropertyDetails(
    String propertyId,
  ) async {
    try {
      final token = await PrefService.getToken();
      final url =
          "https://api.gharzoreality.com/api/v2/properties/$propertyId/details";

      debugPrint("🟡 Fetch Property Details");
      debugPrint("➡️ URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("⬅️ Status: ${response.statusCode}");
      debugPrint("⬅️ Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return PropertyDetailsModel.fromJson(body['data']);
      }
    } catch (e) {
      debugPrint("❌ Property Details Error: $e");
    }
    return null;
  }

  static const String _burl = "https://api.gharzoreality.com/api/rooms/create";

  static Future<ApiResult> createRoom({
    required String propertyId,
    required String roomNumber,
    required String roomType,
    int? floor,
    required Map<String, dynamic> pricing,
    required Map<String, dynamic> capacity,
    required Map<String, dynamic> features,
    required Map<String, dynamic> rules,
    required Map<String, dynamic> area,
    required Map<String, dynamic> availability,
    required File roomImage,
  }) async {
    try {
      final token = await PrefService.getToken();

      // ---------- IMAGE VALIDATION ----------
      final mimeType = lookupMimeType(roomImage.path);
      if (mimeType == null ||
          !mimeType.startsWith("image/") ||
          ![
            "image/jpeg",
            "image/jpg",
            "image/png",
            "image/webp",
          ].contains(mimeType)) {
        return ApiResult(
          success: false,
          message: "Only image files (jpeg, jpg, png, webp) are allowed",
        );
      }

      final request = http.MultipartRequest('POST', Uri.parse(_burl));

      request.headers.addAll({'Authorization': 'Bearer $token'});

      // ---------- TEXT FIELDS ----------
      request.fields.addAll({
        "propertyId": propertyId,
        "roomNumber": roomNumber,
        "roomType": roomType,
        "pricing": jsonEncode(pricing),
        "capacity": jsonEncode(capacity),
        "features": jsonEncode(features),
        "rules": jsonEncode(rules),
        "area": jsonEncode(area),
        "availability": jsonEncode(availability),
      });

      if (floor != null) {
        request.fields["floor"] = floor.toString();
      }

      // ---------- IMAGE ----------
      request.files.add(
        await http.MultipartFile.fromPath(
          "roomImages", // backend expects this exact key
          roomImage.path,
          contentType: MediaType.parse(mimeType),
          filename: roomImage.path.split('/').last,
        ),
      );

      // ---------- DEBUG LOGS ----------
      debugPrint("🟡 CREATE ROOM API");
      debugPrint("➡️ URL: $_burl");
      debugPrint("➡️ FIELDS:");
      request.fields.forEach((k, v) => debugPrint("   $k : $v"));
      debugPrint("➡️ IMAGE: ${roomImage.path} ($mimeType)");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("⬅️ STATUS: ${response.statusCode}");
      debugPrint("⬅️ RESPONSE: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult(
          success: true,
          message: body['message'] ?? "Room created successfully",
        );
      }

      // ---------- BACKEND ERROR ----------
      return ApiResult(
        success: false,
        message:
            body['message'] ?? "Room creation failed (${response.statusCode})",
      );
    } catch (e) {
      debugPrint("❌ CREATE ROOM ERROR: $e");
      return ApiResult(
        success: false,
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }
}

class ApiResult {
  final bool success;
  final String message;

  ApiResult({required this.success, required this.message});
}
