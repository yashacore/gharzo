import 'dart:convert';
import 'dart:io';
import 'package:gharzo_project/common/api_constant/api_constant.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:http/http.dart' as http;



class ApiServiceMethod {
  static Future<Map<String, dynamic>> createDraft({
    required String category,
    required String propertyType,
    required String listingType,
  }) async {
    final token = await PrefService.getToken();

    final response = await http.post(
      Uri.parse(ApiConstant.createDraft),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "category": category,
        "propertyType": propertyType,
        "listingType": listingType,
      }),
    );

    return jsonDecode(response.body);
  }

  //-----------------BAsic details
  static Future<Map<String, dynamic>> updateBasicDetails(
      String propertyId,
      Map<String, dynamic> body,
      ) async {
    final token = await PrefService.getToken();

    final response = await http.put(
      Uri.parse(
          "https://api.gharzoreality.com/api/v2/properties/$propertyId/basic-details"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  //-------------------------------Update features
  static Future<Map<String, dynamic>> updateFeatures(
      String propertyId,
      Map<String, dynamic> body,
      ) async {
    final token = await PrefService.getToken();

    final response = await http.put(
      Uri.parse(
          "https://api.gharzoreality.com/api/v2/properties/$propertyId/features"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }
 //-----------------------------Update Location
  static Future<Map<String, dynamic>> updateLocation(
      String propertyId,
      Map<String, dynamic> body,
      ) async {
    final token = await PrefService.getToken();

    final response = await http.put(
      Uri.parse(
          "https://api.gharzoreality.com/api/v2/properties/$propertyId/location"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }


  //--------------------------Upload Photo
  static Future<Map<String, dynamic>> uploadPhotos(
      String propertyId,
      List<File> images,
      ) async {
    final token = await PrefService.getToken();

    final uri = Uri.parse(
        "https://api.gharzoreality.com/api/v2/properties/$propertyId/upload-photos");

    final request = http.MultipartRequest("POST", uri);

    request.headers['Authorization'] = 'Bearer $token';

    for (final image in images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image.path,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response =
    await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body);
  }

  //----------------------------Contact Information
  static Future<Map<String, dynamic>> updateContactInfo(
      String propertyId,
      Map<String, dynamic> body,
      ) async {
    final token = await PrefService.getToken();

    final response = await http.put(
      Uri.parse(
          "https://api.gharzoreality.com/api/v2/properties/$propertyId/contact-info"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }

  //--------------------------------Submit Property
  static Future<Map<String, dynamic>> submitProperty(
      String propertyId) async {
    final token = await PrefService.getToken();

    final response = await http.post(
      Uri.parse("https://api.gharzoreality.com/api/v2/properties/$propertyId/submit"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }
}