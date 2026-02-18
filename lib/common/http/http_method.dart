import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_constant.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/add_property_type/city_model.dart';
import 'package:gharzo_project/model/add_property_type/property_details_model.dart';
import 'package:gharzo_project/model/add_property_type/update%20_profile_responce_model.dart';
import 'package:gharzo_project/model/add_property_type/update_profile_request_model.dart';
import 'package:gharzo_project/model/advertisement/advertisment_model.dart';
import 'package:gharzo_project/model/home/home_model.dart';
import 'package:gharzo_project/model/login_model/login_model.dart';
import 'package:gharzo_project/model/property_model/property_model.dart';
import 'package:gharzo_project/model/send_otp_model/sendotp_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';



class AuthService {

  //========================================Auth

  static Future<SendOtpModel> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse('https://api.gharzoreality.com/api/auth/send-otp'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({"phone": phone}),
    );

    final body = jsonDecode(response.body);

     debugPrint("Body :: $body");
    return SendOtpModel.fromJson(body);
  }

  // ---------------- RESEND OTP
  static Future<SendOtpModel> resendOtp(String phone) async {
    final response = await http.post(
      Uri.parse(ApiConstant.resendOTP),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phone}),
    );

    final body = jsonDecode(response.body);
    return SendOtpModel.fromJson(body);
  }

  // ---------------- VERIFY OTP (LOGIN + REGISTER)
  static Future<LoginModel> verifyOtp({
    required String phone,
    required String otp,
    String? name,
    String? role,
  }) async {
    print('otp::  $otp');
    final response = await http.post(
      Uri.parse('https://api.gharzoreality.com/api/auth/verify-otp'),
      body: {
        'phone': phone,
        'otp': otp,
        if (name != null) 'name': name,
        if (role != null) 'role': role,
      },
    );

    /// 🔥 VERY IMPORTANT DEBUG
    print('🧾 RAW RESPONSE TYPE: ${response.runtimeType}');
    print('🧾 RAW RESPONSE: ${response.body}');

    final json = jsonDecode(response.body);
    return LoginModel.fromJson(json);
  }


  //--------------------------------------Home
  static Future<Home> getFeaturedProperties() async {
    final response = await http.get(
      Uri.parse(ApiConstant.featuredProperties),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    return Home.fromJson(jsonDecode(response.body));
  }

  // ---------------- TRENDING PROPERTIES
  static Future<Home> getTrendingProperties() async {
    final response = await http.get(
      Uri.parse(ApiConstant.trendingProperties),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    return Home.fromJson(jsonDecode(response.body));
  }

  // ---------------- RECENT PROPERTIES
  static Future<Home> getRecentProperties() async {
    final response = await http.get(
      Uri.parse(ApiConstant.recentProperties),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    return Home.fromJson(jsonDecode(response.body));
  }

  //----------------------property category buy hostel and other
  static Future<List<PropertyModel>> getPropertiesByCategory(String category) async {
    final query = ApiConstant.categoryToQuery[category] ?? '';
    final url = "https://api.gharzoreality.com/api/public/properties?$query";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final body = jsonDecode(response.body);

    if (body['success'] == true) {
      return List<PropertyModel>.from(
        body['data'].map((e) => PropertyModel.fromJson(e)),
      );
    } else {
      return [];
    }
  }


  //=================================Advertisement
  static Future<List<AdvertisementModel>> getAds({
    required String placement,
  }) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/v2/advertisements/public/placement"),
      headers: {
        'Accept': 'application/json',
      },
    );

    final json = jsonDecode(response.body);

    if (json['success'] == true) {
      return (json['data'] as List)
          .map((e) => AdvertisementModel.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }



  static Future<PropertyDetailModel> getPropertyDetails(String id) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/public/properties/$id"),
    );


    debugPrint("Get Property details :: $response");
    final body = jsonDecode(response.body);

    if (body['success'] == true) {
      return PropertyDetailModel.fromJson(body['data']['property']);
    } else {
      throw Exception("Failed to fetch property details");
    }
  }


  // ------------------------------------Add Property

  static Future<Map<String, dynamic>> put(
      String path, {
        required Map<String, dynamic> body,
      }) async {
    final token = await PrefService.getToken();

    final response = await http.put(
      Uri.parse("${ApiConstant.baseUrl}$path"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? "API Error");
    }
  }

  static Future<String> postDraftProperty({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      Uri.parse("https://api.gharzoreality.com/api/v2/properties/create-draft"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    final decoded = jsonDecode(response.body);

    debugPrint("📥 CREATE DRAFT RESPONSE: $decoded");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return decoded['data']['propertyId'];
    } else {
      throw Exception(decoded['message'] ?? "Draft failed");
    }
  }


  static Future<List<CityModel>> getCities() async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/master-data/v2/cities"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load cities");
    }

    final decoded = jsonDecode(response.body);

    if (decoded['data'] == null || decoded['data'] is! List) {
      throw Exception("Invalid data format for cities");
    }

    return (decoded['data'] as List)
        .map((e) => CityModel.fromJson(e))
        .toList();
  }




  static Future<List<LocalityModel>> getLocalities(String cityName) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/master-data/localities/$cityName"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load localities");
    }

    final decoded = jsonDecode(response.body);
    final List data = decoded['data'] ?? [];

    return data.map((name) => LocalityModel.fromJson(name)).toList();
  }


  // ------------------------------------Update Location
  // static Future<void> updatePropertyLocation({
  //   required String token,
  //   required String propertyId,
  //   required Map<String, dynamic> location,
  // }) async {
  //   final res = await http.put(
  //     Uri.parse("https://api.gharzoreality.com/api/v2/properties/$propertyId/location"),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //     body: jsonEncode({
  //       "location": location,
  //     }),
  //   );
  //
  //   debugPrint("📍 LOCATION STATUS => ${res.statusCode}");
  //   debugPrint("📍 LOCATION BODY => ${res.body}");
  //
  //   if (res.statusCode != 200 && res.statusCode != 201) {
  //     throw Exception(res.body);
  //   }
  //   return res
  // }

  static Future<Map<String, dynamic>> updatePropertyLocation({
    required String token,
    required String propertyId,
    required Map<String, dynamic> location,
  }) async {
    final res = await http.put(
      Uri.parse("https://api.gharzoreality.com/api/v2/properties/$propertyId/location"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "location": location,
      }),
    );

    final decoded = jsonDecode(res.body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? "Location update failed");
    }
  }


  // ------------------------------------Update Basic Details
  static Future<void> updatePropertyDetails({
    required String propertyId,
    required Map<String, dynamic> body,
  }) async {
    final token = await PrefService.getToken();
    final res = await http.put(
      Uri.parse("https://api.gharzoreality.com/api/v2/properties/$propertyId/basic-details"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    debugPrint("🧩 DETAILS STATUS => ${res.statusCode}");
    debugPrint("🧩 DETAILS BODY => ${res.body}");

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Details update failed");
    }
  }

  // ------------------------------------Update Price (kept same but fixed endpoint)
  static Future<void> updatePropertyPrice({
    required String propertyId,
    required String price,
    required String maintenance,
  }) async {
    final token = await PrefService.getToken();
    final response = await http.put(
      Uri.parse("${ApiConstant.baseUrl}/api/v2/properties/$propertyId/basic-details"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": "Spacious 2BHK Flat in Vijay Nagar",
        "description":
        "Beautiful 2 BHK flat with modern amenities. Perfect for small families. Well-ventilated rooms with natural light. Located in prime location with easy access to schools, hospitals and markets.",
        "bhk": 2,
        "bathrooms": 2,
        "balconies": 1,
        "price": {
          "amount": price,
          "negotiable": true,
          "maintenanceCharges": {
            "amount": maintenance,
            "frequency": "Monthly"
          },
          "securityDeposit": 30000
        },
        "area": {
          "carpet": 950,
          "builtUp": 1100,
          "unit": "sqft"
        },
        "floor": {
          "current": 3,
          "total": 5
        },
        "propertyAge": "1-5 years",
        "availableFrom": "2024-02-01"
      }),
    );

    debugPrint("💰 PRICE STATUS: ${response.statusCode}");
    debugPrint("💰 PRICE BODY: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Price update failed");
    }
  }

  //-------------------Upload Property Images
  static Future<void> uploadPropertyImages({
    required String propertyId,
    required List<File> images,
  }) async {
    final token = await PrefService.getToken();

    final uri = Uri.parse(
      'https://api.gharzoreality.com/api/v2/properties/$propertyId/upload-photos',
    );

    try {
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      for (var image in images) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            image.path,
            filename: basename(image.path),
          ),
        );
      }

      var response = await request.send();

      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Upload successful');
        debugPrint(responseBody);
      } else {
        debugPrint('Upload failed');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint(responseBody);
      }
    } catch (e) {
      debugPrint('Error uploading images: $e');
    }
  }

  //----------------------publish Property
  static Future<void> publishProperty({
    required String propertyId,
  }) async {
    final token = await PrefService.getToken();
    final res = await http.post(
      Uri.parse("${ApiConstant.baseUrl}/api/v2/properties/$propertyId/submit"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    debugPrint("🚀 PUBLISH STATUS => ${res.statusCode}");

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Publish failed");
    }
  }

  // ---------------------- MASTER DATA : GET AMENITIES ----------------------
  static Future<Map<String, dynamic>> getAmenities() async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/master-data/amenities"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final decoded = jsonDecode(response.body);

    debugPrint("🏷️ AMENITIES RESPONSE => $decoded");

    if (decoded['success'] == true) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? "Failed to fetch amenities");
    }
  }

  static Future<UpdateProfileResponse> updateProfile({
    required String token,
    String? name,
    String? phone,
    Address? address,
  }) async {
    final url = Uri.parse(
      'https://api.gharzoreality.com/api/auth/update_profile',
    );

    final request = UpdateProfileRequestModel(
      name: name,
      phone: phone,
      address: address,
    );

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    debugPrint("🌐 UPDATE PROFILE STATUS: ${response.statusCode}");
    debugPrint("🌐 UPDATE PROFILE BODY: ${response.body}");

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UpdateProfileResponse.fromJson(decoded);
    } else {
      throw Exception(decoded['message'] ?? 'Something went wrong');
    }
  }

} 