import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_constant.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/model/create_tenancy_model.dart';
import 'package:http/http.dart' as http;

class ApiServiceMethod {
  static const _timeout = Duration(seconds: 30);

  // ================= COMMON HELPERS =================

  static Future<Map<String, dynamic>> getNotifications() async {
    debugPrint("══════════════════════════════════");
    debugPrint("🔔 GET NOTIFICATIONS API");

    try {
      final url = "https://api.gharzoreality.com/api/notifications";
      debugPrint("🌐 URL: $url");

      final headers = await _headers();
      debugPrint("📤 Headers: $headers");

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      final parsed = _handleResponse(response);
      debugPrint("✅ Parsed Response: $parsed");

      return parsed;
    } catch (e, s) {
      debugPrint("❌ GET NOTIFICATIONS ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to fetch notifications"};
    }
  }

  static Future<Map<String, String>> _headers({bool json = true}) async {
    debugPrint("══════════════════════════════════");
    debugPrint("🔐 _headers() called");

    final token = await PrefService.getToken();

    debugPrint("🔑 Token: ${token != null ? 'AVAILABLE' : 'NULL'}");
    debugPrint("📦 JSON Header Enabled: $json");

    final headers = {
      if (json) 'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    debugPrint("📤 Headers: $headers");
    return headers;
  }

  // ================= SAFE JSON =================

  static Map<String, dynamic> _safeJsonDecode(String body) {
    debugPrint("🧩 Decoding Response Body");
    debugPrint("📄 Raw Body: $body");

    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      debugPrint("✅ Decoded JSON: $decoded");
      return decoded;
    } catch (e) {
      debugPrint("❌ JSON Decode Error: $e");
      return {"success": false, "message": "Invalid server response"};
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    debugPrint("══════════════════════════════════");
    debugPrint("📥 Handling HTTP Response");
    debugPrint("📊 Status Code: ${response.statusCode}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return _safeJsonDecode(response.body);
    }

    final parsed = _safeJsonDecode(response.body);
    debugPrint("❌ Error Response Parsed: $parsed");

    return {
      "success": false,
      "statusCode": response.statusCode,
      "message": parsed["message"] ?? "Server error (${response.statusCode})",
    };
  }

  // ================= GET AMENITIES =================

  static Future<Map<String, dynamic>> getAmenities() async {
    debugPrint("══════════════════════════════════");
    debugPrint("📡 GET AMENITIES API");

    try {
      final url = "https://api.gharzoreality.com/api/v2/properties/amenities";
      debugPrint("🌐 URL: $url");

      final response = await http
          .get(Uri.parse(url), headers: await _headers())
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      return _handleResponse(response);
    } catch (e, s) {
      debugPrint("❌ GET AMENITIES ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to load amenities"};
    }
  }

  // ================= CREATE DRAFT =================

  static Future<Map<String, dynamic>> createDraft({
    required String category,
    required String propertyType,
    required String listingType,
  }) async {
    debugPrint("══════════════════════════════════");
    debugPrint("📝 CREATE DRAFT");

    final body = {
      "category": category,
      "propertyType": propertyType,
      "listingType": listingType,
    };

    debugPrint("📤 Body: ${jsonEncode(body)}");

    try {
      final response = await http
          .post(
            Uri.parse(ApiConstant.createDraft),
            headers: await _headers(),
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      return _handleResponse(response);
    } catch (e, s) {
      debugPrint("❌ CREATE DRAFT ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to create draft"};
    }
  }

  // ================= BASIC DETAILS =================

  static Future<Map<String, dynamic>> updateBasicDetails(
    String propertyId,
    Map<String, dynamic> body,
  ) async {
    debugPrint("══════════════════════════════════");
    debugPrint("🏠 UPDATE BASIC DETAILS");
    debugPrint("🆔 Property ID: $propertyId");
    debugPrint("📤 Body: ${jsonEncode(body)}");

    try {
      final response = await http
          .put(
            Uri.parse(
              "https://api.gharzoreality.com/api/v2/properties/$propertyId/basic-details",
            ),
            headers: await _headers(),
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      return _handleResponse(response);
    } catch (e, s) {
      debugPrint("❌ BASIC DETAILS ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to update basic details"};
    }
  }

  // ================= FEATURES =================

  static Future<Map<String, dynamic>> updateFeatures(
    String propertyId,
    Map<String, dynamic> body,
  ) async {
    debugPrint("══════════════════════════════════");
    debugPrint("✨ UPDATE FEATURES");
    debugPrint("🆔 Property ID: $propertyId");
    debugPrint("📤 Body: ${jsonEncode(body)}");

    try {
      final response = await http
          .put(
            Uri.parse(
              "https://api.gharzoreality.com/api/v2/properties/$propertyId/features",
            ),
            headers: await _headers(),
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      final parsed = _handleResponse(response);
      debugPrint("✅ Parsed Response: $parsed");

      return parsed;
    } catch (e, s) {
      debugPrint("❌ FEATURES ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to update features"};
    }
  }

  // ================= LOCATION =================

  static Future<Map<String, dynamic>> updateLocation(
    String propertyId,
    Map<String, dynamic> body,
  ) async {
    debugPrint("══════════════════════════════════");
    debugPrint("📍 UPDATE LOCATION");
    debugPrint("🆔 Property ID: $propertyId");
    debugPrint("📤 Body: ${jsonEncode(body)}");

    try {
      final response = await http
          .put(
            Uri.parse(
              "https://api.gharzoreality.com/api/v2/properties/$propertyId/location",
            ),
            headers: await _headers(),
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      return _handleResponse(response);
    } catch (e, s) {
      debugPrint("❌ LOCATION ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to update location"};
    }
  }

  // ================= CONTACT INFO =================

  static Future<Map<String, dynamic>> updateContactInfo(
    String propertyId,
    Map<String, dynamic> body,
  ) async {
    debugPrint("══════════════════════════════════");
    debugPrint("📞 UPDATE CONTACT INFO");
    debugPrint("🆔 Property ID: $propertyId");
    debugPrint("📤 Body: ${jsonEncode(body)}");

    try {
      final response = await http
          .put(
            Uri.parse(
              "https://api.gharzoreality.com/api/v2/properties/$propertyId/contact-info",
            ),
            headers: await _headers(),
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      final parsed = _handleResponse(response);
      debugPrint("✅ Parsed Response: $parsed");

      return parsed;
    } catch (e, s) {
      debugPrint("❌ CONTACT INFO ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to update contact info"};
    }
  }

  // ================= SUBMIT PROPERTY =================

  static Future<Map<String, dynamic>> submitProperty(String propertyId) async {
    debugPrint("══════════════════════════════════");
    debugPrint("🚀 SUBMIT PROPERTY");
    debugPrint("🆔 Property ID: $propertyId");

    try {
      final response = await http
          .post(
            Uri.parse(
              "https://api.gharzoreality.com/api/v2/properties/$propertyId/submit",
            ),
            headers: await _headers(),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      return _handleResponse(response);
    } catch (e, s) {
      debugPrint("❌ SUBMIT ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to submit property"};
    }
  }

  // ================= GET PROPERTY =================

  static Future<Map<String, dynamic>> getPropertyById(String propertyId) async {
    debugPrint("══════════════════════════════════");
    debugPrint("📄 GET PROPERTY BY ID");
    debugPrint("🆔 Property ID: $propertyId");

    try {
      final response = await http
          .get(
            Uri.parse(
              "https://api.gharzoreality.com/api/v2/properties/$propertyId",
            ),
            headers: await _headers(),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      return _handleResponse(response);
    } catch (e, s) {
      debugPrint("❌ GET PROPERTY ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {"success": false, "message": "Failed to fetch property details"};
    }
  }

  static Future<Map<String, dynamic>> updateOwnershipDetails(
    String propertyId,
    Map<String, dynamic> body,
  ) async {
    debugPrint("══════════════════════════════════");
    debugPrint("🏗️ UPDATE OWNERSHIP DETAILS");
    debugPrint("🆔 Property ID: $propertyId");
    debugPrint("📤 Body: ${jsonEncode(body)}");

    try {
      final token = await PrefService.getToken();

      final url =
          "https://api.gharzoreality.com/api/v2/properties/$propertyId/ownership-details";

      debugPrint("🌐 URL: $url");
      debugPrint("🔐 Token: ${token != null ? 'AVAILABLE' : 'NULL'}");

      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      final parsed = _handleResponse(response);
      debugPrint("✅ Parsed Response: $parsed");

      return parsed;
    } catch (e, s) {
      debugPrint("❌ OWNERSHIP DETAILS ERROR");
      debugPrint("❌ Error: $e");
      debugPrint("❌ StackTrace: $s");

      return {
        "success": false,
        "message": "Failed to update ownership details",
      };
    }
  }

  static Future<Map<String, dynamic>> markAllNotificationsRead({
    required String fcmToken,
    required String device,
  }) async {
    try {
      debugPrint("══════════════════════════════════");
      debugPrint("🔔 READ ALL NOTIFICATIONS API");
      debugPrint("📤 Payload: { token: $fcmToken, device: $device }");

      final response = await http
          .post(
            Uri.parse(
              "https://api.gharzoreality.com/api/notifications/read-all",
            ),
            headers: await _headers(),
            body: jsonEncode({"token": fcmToken, "device": device}),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      return _handleResponse(response);
    } catch (e, s) {
      debugPrint("❌ READ ALL ERROR: $e");
      debugPrint("❌ STACKTRACE: $s");

      return {
        "success": false,
        "message": "Failed to mark notifications as read",
      };
    }
  }

  static Future<Map<String, dynamic>> markNotificationRead({
    required String notificationId,
    required String fcmToken,
    required String device,
  }) async {
    try {
      debugPrint("══════════════════════════════════");
      debugPrint("🔔 MARK SINGLE NOTIFICATION READ");
      debugPrint("🆔 Notification ID: $notificationId");
      debugPrint("📤 Payload: { token: $fcmToken, device: $device }");

      final response = await http
          .post(
            Uri.parse(
              "https://api.gharzoreality.com/api/notifications/$notificationId/read",
            ),
            headers: await _headers(),
            body: jsonEncode({"token": fcmToken, "device": device}),
          )
          .timeout(_timeout);

      debugPrint("📥 Status Code: ${response.statusCode}");
      debugPrint("📥 Raw Response: ${response.body}");

      return _handleResponse(response);
    } catch (e, s) {
      debugPrint("❌ MARK SINGLE READ ERROR: $e");
      debugPrint("❌ STACKTRACE: $s");

      return {
        "success": false,
        "message": "Failed to mark notification as read",
      };
    }
  }

  static Future<Map<String, dynamic>> createTenancy(
    CreateTenancyRequest request,
  ) async {
    try {
      final token = await PrefService.getToken();
      final url = "https://api.gharzoreality.com/api/tenancies/create";

      debugPrint("🌐 CREATE TENANCY API");
      debugPrint("🔗 URL: $url");
      debugPrint("🔐 TOKEN: ${token != null ? 'AVAILABLE' : 'NULL'}");
      debugPrint("📤 BODY: ${request.toJson()}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(request.toJson()),
      );

      debugPrint("📥 STATUS CODE: ${response.statusCode}");
      debugPrint("📥 RAW RESPONSE: ${response.body}");

      return jsonDecode(response.body);
    } catch (e, s) {
      debugPrint("❌ CREATE TENANCY ERROR: $e");
      debugPrint("❌ STACKTRACE: $s");

      return {"success": false, "message": "Failed to create tenancy"};
    }
  }
}
