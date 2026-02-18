import 'dart:convert';
import 'dart:io';
import 'package:gharzo_project/model/bed/bulk_create_beds/bulk_create_bed_response.dart';
import 'package:gharzo_project/model/bed/bulk_create_beds/bulk_create_beds_model.dart';
import 'package:gharzo_project/model/bed/create_bed/create_bed_model.dart';
import 'package:gharzo_project/model/bed/delete_bed/delete_bed_model.dart';
import 'package:gharzo_project/model/bed/get_bed_by_id/get_bed_by_id_model.dart';
import 'package:gharzo_project/model/bed/get_bed_by_room/get_bed_by_room_model.dart';
import 'package:gharzo_project/model/bed/get_my_beds/get_my_beds_model.dart';
import 'package:gharzo_project/model/bed/search_bed/search_bed_model.dart';
import 'package:gharzo_project/model/bed/update_bed/update_bed_model.dart';
import 'package:gharzo_project/model/bed/update_bed_image/update_bed_image_model.dart';
import 'package:gharzo_project/model/bed/update_bed_status/update_bed_status_model.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/common/api_constant/api_constant.dart';

class BedApiService {

  static Future<CreateBedResponseModel> createBed({
    required String token,
    required String roomId,
    required String bedNumber,
    required String bedType,
    required Map<String, dynamic> pricing,
    required Map<String, dynamic> features,
    required Map<String, dynamic> position,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> bedSize,
    required String condition,
    required String notes,
    List<File>? images,
  }) async {
    final uri = Uri.parse("https://api.gharzoreality.com/api/beds/create");
    final request = http.MultipartRequest("POST", uri);

    request.headers.addAll({
      "Authorization": "Bearer $token",
    });

    request.fields['roomId'] = roomId;
    request.fields['bedNumber'] = bedNumber;
    request.fields['bedType'] = bedType;
    request.fields['pricing'] = jsonEncode(pricing);
    request.fields['features'] = jsonEncode(features);
    request.fields['position'] = jsonEncode(position);
    request.fields['preferences'] = jsonEncode(preferences);
    request.fields['bedSize'] = jsonEncode(bedSize);
    request.fields['condition'] = condition;
    request.fields['notes'] = notes;

    if (images != null) {
      for (var img in images) {
        request.files.add(
          await http.MultipartFile.fromPath('bedImages', img.path),
        );
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final body = jsonDecode(response.body);

    if (response.statusCode == 201 && body['success'] == true) {
      return CreateBedResponseModel.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Create bed failed");
    }
  }

  //Get bed by room

  static Future<GetBedsByRoomResponseModel> getBedsByRoom({
    required String token,
    required String roomId,
  }) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/beds/room/$roomId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return GetBedsByRoomResponseModel.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to fetch beds");
    }
  }

  //Get bed by id
  static Future<GetBedByIdResponseModel> getBedById({
    required String token,
    required String bedId,
  }) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/beds/$bedId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return GetBedByIdResponseModel.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to fetch bed details");
    }
  }

  //Get my beds
  Future<MyBedsResponse> getMyBeds(String token) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/beds/my-beds"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return MyBedsResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to fetch beds");
    }
  }

  //------------------update bed
  Future<UpdateBedResponse> updateBed({
    required String token,
    required String bedId,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.put(
      Uri.parse("https://api.gharzoreality.com/api/beds/$bedId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return UpdateBedResponse.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "Failed to update bed");
    }
  }

  //----------------update bed image
  Future<UpdateBedImagesResponse> updateBedImages({
    required String token,
    required String bedId,
    required List<File> images,
  }) async {
    final uri = Uri.parse("https://api.gharzoreality.com/api/beds/$bedId/images");
    final request = http.MultipartRequest("PUT", uri);

    request.headers['Authorization'] = "Bearer $token";

    for (var image in images) {
      request.files.add(
        await http.MultipartFile.fromPath('images', image.path),
      );
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();
    final data = jsonDecode(responseBody);

    if (streamedResponse.statusCode == 200 && data['success'] == true) {
      return UpdateBedImagesResponse.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "Failed to update bed images");
    }
  }

  // update bed status
  Future<UpdateBedStatusResponse> updateBedStatus({
    required String token,
    required String bedId,
    required String status,
    required String notes,
  }) async {
    final response = await http.patch(
      Uri.parse("https://api.gharzoreality.com/api/beds/$bedId/status"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "status": status,
        "notes": notes,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return UpdateBedStatusResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to update bed status");
    }
  }

  //----------------------delete bed
  Future<DeleteBedResponse> deleteBed({
    required String token,
    required String bedId,
    required String status,
    required String notes,
  }) async {
    final response = await http.delete(
      Uri.parse("https://api.gharzoreality.com/api/beds/$bedId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "status": status,
        "notes": notes,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return DeleteBedResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to delete bed");
    }
  }

  //---------------------search bed
  Future<SearchBedsResponse> searchBeds({
    required String city,
    int? minRent,
    int? maxRent,
    bool? hasAC,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      "city": city,
      if (minRent != null) "minRent": minRent.toString(),
      if (maxRent != null) "maxRent": maxRent.toString(),
      if (hasAC != null) "hasAC": hasAC.toString(),
      "page": page.toString(),
      "limit": limit.toString(),
    };

    final uri = Uri.parse("https://api.gharzoreality.com/api/beds/search").replace(queryParameters: queryParams);

    final response = await http.get(uri);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return SearchBedsResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to search beds");
    }
  }

  //---------------------bulk create
  Future<BulkCreateBedsResponse> bulkCreateBeds(
      BulkCreateBedsRequest request) async {
    final response = await http.post(
      Uri.parse("https://api.gharzoreality.com/api/beds/bulk-create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    final body = jsonDecode(response.body);

    return BulkCreateBedsResponse.fromJson(body);
  }

}
