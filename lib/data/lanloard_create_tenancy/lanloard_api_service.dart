import 'dart:convert';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TenancyApiService {
  static const String baseUrl = 'https://api.gharzoreality.com/api/tenancies';



  static Future<http.Response> createTenancy(Map<String, dynamic> data) async {
    final token = await PrefService.getToken();

    final url = Uri.parse('$baseUrl/create');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    return await http.post(
        url,
        headers: headers,
        body: jsonEncode(data)
    );
  }


  static Future<http.Response> approveTenancy(String tenancyId, Map<String, dynamic> data) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/approve');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    return await http.patch(
        url,
        headers: headers,
        body: jsonEncode(data)
    );
  }
  static Future<http.Response> getTenancyDetails(String tenancyId) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/details');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
    return await http.get(url, headers: headers);
  }

  static Future<http.Response> updateTenancy(String tenancyId, Map<String, dynamic> data) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    return await http.put(
        url,
        headers: headers,
        body: jsonEncode(data)
    );
  }

  static Future<http.Response> getLandlordTenancies() async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/landlord/my-tenancies');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    return await http.get(url, headers: headers);
  }

  static Future<http.Response> rateTenant(String tenancyId, Map<String, dynamic> data) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/rate-tenant');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    return await http.post(
        url,
        headers: headers,
        body: jsonEncode(data)
    );
  }

  static Future<http.Response> getTenantTenancies() async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/tenant/my-tenancies');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    return await http.get(url, headers: headers);
  }

  static Future<http.Response> rateLandlord(String tenancyId, Map<String, dynamic> data) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/rate-landlord');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    return await http.post(
        url,
        headers: headers,
        body: jsonEncode(data)
    );
  }


  ///--------------------Lanloard give notice to tenant and tenant give notice lanloard
  static Future<http.Response> sendNotice(String tenancyId, Map<String, dynamic> data) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/notice');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    return await http.post(
        url,
        headers: headers,
        body: jsonEncode(data)
    );
  }

  static Future<http.StreamedResponse> moveIn(
      String tenancyId,
      String checklistJson,
      List<XFile> images
      ) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/move-in');

    final request = http.MultipartRequest('PATCH', url);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['checklist'] = checklistJson;

    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath('moveInPhotos', image.path),
      );
    }
    return await request.send();
  }

  static Future<http.StreamedResponse> moveOut(
      String tenancyId,
      String checklistJson,
      List<XFile> images
      ) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/move-out');

    final request = http.MultipartRequest('PATCH', url);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['checklist'] = checklistJson;

    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath('moveInPhotos', image.path),
      );
    }

    return await request.send();
  }

  static Future<http.Response> renewTenancy(String tenancyId, Map<String, dynamic> data) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/renew');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    return await http.post(
        url,
        headers: headers,
        body: jsonEncode(data)
    );
  }

  static Future<http.Response> rejectTenancy(String tenancyId, String reason) async {
    final token = await PrefService.getToken();
    final url = Uri.parse('$baseUrl/$tenancyId/reject');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "reason": reason,
    });

    return await http.patch(url, headers: headers, body: body);
  }
}
