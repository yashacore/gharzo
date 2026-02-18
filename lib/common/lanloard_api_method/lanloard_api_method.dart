import 'dart:convert';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/lanloard/get_lanloard_property_model.dart';
import 'package:gharzo_project/model/lanloard/lanloard_create_tanant_model.dart';
import 'package:gharzo_project/model/lanloard/single_property_model.dart';
import 'package:http/http.dart' as http;

class LanloardApiService {
  final String baseUrl =
      "https://api.gharzoreality.com/api/v2/properties/my-properties";

  Future<List<LanloardPropertyModel>> fetchMyProperties(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Print the raw response body
    print("===== Lanloard API Response =====");
    print(response.body);
    print("================================");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Optionally print parsed JSON
      print("===== Parsed JSON =====");
      print(data);
      print("=======================");

      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => LanloardPropertyModel.fromJson(json))
            .toList();
      } else {
        print("No data found in response!");
        return [];
      }
    } else {
      print("API call failed: ${response.statusCode}");
      return [];
    }
  }


  static Future<CreateTenancyResponse> createTenancy({
    required Map<String, dynamic> body,
  }) async {
    final token = await PrefService.getToken();
    if (token == null) {
      throw Exception("No token found. Please login first.");
    }

    final response = await http.post(
      Uri.parse("https://api.gharzoreality.com/api/tenancies/create"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return CreateTenancyResponse.fromJson(
          jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to create tenancy: ${response.statusCode} ${response.body}");
    }
  }

  //fetch property details

  static Future<SinglePropertyModel?> fetchPropertyDetail(String id) async {
    final token = await PrefService.getToken();
    if (token == null) throw Exception("No token found");

    final url =
        "https://api.gharzoreality.com/api/v2/properties/$id/details";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return SinglePropertyModel.fromJson(data['data']);
      } else {
        return null;
      }
    } else {
      throw Exception("Failed to fetch property details");
    }
  }
}
