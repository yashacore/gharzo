import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/model/login_model/login_model.dart';
import 'package:gharzo_project/model/add_property_type/update_profile_request_model.dart';
import 'package:gharzo_project/model/add_property_type/update%20_profile_responce_model.dart';

class TenantService {
  // -------- GET PROFILE
  static Future<LoginModel> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('https://api.gharzoreality.com/api/auth/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return LoginModel.fromJson(jsonDecode(response.body));
  }

  // -------- UPDATE PROFILE
  static Future<UpdateProfileResponse> updateProfile({
    required String token,
    String? name,
    String? phone,
    Address? address,
  }) async {
    final request = UpdateProfileRequestModel(
      name: name,
      phone: phone,
      address: address,
    );

    final response = await http.put(
      Uri.parse('https://api.gharzoreality.com/api/auth/update_profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    return UpdateProfileResponse.fromJson(jsonDecode(response.body));
  }

  // -------- LOGOUT
  static Future<void> logout(String token) async {
    await http.post(
      Uri.parse('https://api.gharzoreality.com/api/auth/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
