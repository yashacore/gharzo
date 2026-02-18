import 'dart:convert';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "https://api.yourdomain.com/api";

  static Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, String>? headers,
      }) async {
    final token = await PrefService.getToken();
    final response = await http.get(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
        ...?headers,
      },
    );

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? headers,
      }) async {
    final token = await PrefService.getToken();
    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
        ...?headers,
      },
      body: jsonEncode(body ?? {}),
    );

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> put(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    final token = await PrefService.getToken();
    final response = await http.put(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body ?? {}),
    );

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await PrefService.getToken();
    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return _processResponse(response);
  }

  static Map<String, dynamic> _processResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Something went wrong");
    }
  }
}
