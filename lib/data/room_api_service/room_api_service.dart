import 'dart:convert';
import 'dart:io';
import 'package:gharzo_project/model/room/bulk_create_room_model/room_buik_create_model.dart';
import 'package:gharzo_project/model/room/delete_model/delete_room_model.dart';
import 'package:gharzo_project/model/room/get_room_model/get_room_model.dart';
import 'package:gharzo_project/model/room/room_detail_model/room_detail_model.dart';
import 'package:gharzo_project/model/room/room_model/room_model.dart';
import 'package:gharzo_project/model/room/search_room_model/search_room_model.dart';
import 'package:gharzo_project/model/room/toggle_room/toggle_model.dart';
import 'package:gharzo_project/model/room/toggle_room/toggle_room_model.dart';
import 'package:gharzo_project/model/room/update_room/update_room_model.dart';
import 'package:gharzo_project/model/room/update_room/update_room_response_model.dart';
import 'package:gharzo_project/model/room/update_room_image/update_room_image_model.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/common/api_constant/api_constant.dart';


class RoomApiService {

  static Future<List<RoomDetail>> getRoomsByPropertyId(
      String propertyId) async {

    final response = await http.get(
      Uri.parse(
          "https://api.gharzoreality.com/api/rooms/property/$propertyId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer Token",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      List data = body['data'];
      return data.map((e) => RoomDetail.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch rooms");
    }
  }


  //------------Create room with image
  static Future<RoomModel> createRoom(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse("https://api.gharzoreality.com/api/rooms/create"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RoomModel.fromJson(body['data']);
    } else {
      throw Exception(body['message'] ?? "Room create failed");
    }
  }

  /* ---------- 2. Bulk Create Rooms ---------- */
  Future<BulkCreateRoomResponse> bulkCreateRooms(
      BulkCreateRoomRequestModel request,
      String token,
      ) async {

    final response = await http.post(
      Uri.parse("https://api.gharzoreality.com/api/rooms/bulk-create"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return BulkCreateRoomResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to create rooms");
    }
  }

  /* ---------- 3. Get Room By ID ---------- */
  Future<RoomDetailResponse> getRoomById(String roomId, String token) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/rooms/$roomId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return RoomDetailResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to fetch room details");
    }
  }

  /* ---------- 4. Get All Rooms of Property ---------- */
  static Future<List<RoomModel>> getRoomsByProperty(String propertyId) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/rooms/property/$propertyId"),
    );

    final body = jsonDecode(response.body);

    if (body['success'] == true) {
      return (body['data'] as List)
          .map((e) => RoomModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to fetch rooms");
    }
  }

  /* ---------- 5. Search Available Rooms and filter rent range ---------- */
  Future<RoomSearchResponse> searchRooms({
    required String city,
    required String roomType,
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      "https://api.gharzoreality.com/api/rooms/available/search?city=$city&roomType=$roomType&page=$page&limit=$limit",
    );

    final response = await http.get(uri);

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return RoomSearchResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to fetch rooms");
    }
  }


  Future<RoomSearchResponse> filterByRentRange({
    String? city,
    String? roomType,
    int? minRent,
    int? maxRent,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      if (city != null) "city": city,
      if (roomType != null) "roomType": roomType,
      if (minRent != null) "minRent": minRent.toString(),
      if (maxRent != null) "maxRent": maxRent.toString(),
      "page": page.toString(),
      "limit": limit.toString(),
    };

    final uri = Uri.parse("https://api.gharzoreality.com/api/rooms/available/search")
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return RoomSearchResponse.fromJson(body);
    } else {
      throw Exception(body['message'] ?? "Failed to fetch rooms");
    }
  }


//----------------filter by gender and furnishing

  Future<RoomSearchResponse> genderByFurnishing({
    String? genderPreference,
    String? furnished,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      if (genderPreference != null)
        "genderPreference": genderPreference,
      if (furnished != null)
        "furnished": furnished,
      "page": page.toString(),
      "limit": limit.toString(),
    };

    final uri = Uri.parse("https://api.gharzoreality.com/api/rooms/available/search")
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        body['success'] == true) {
      return RoomSearchResponse.fromJson(body);
    } else {
      throw Exception(
          body['message'] ?? "Failed to fetch rooms");
    }
  }


  //---------------------combined filter
  Future<RoomSearchResponse> combinedFilters({
    String? city,
    String? locality,
    String? roomType,
    int? minRent,
    int? maxRent,
    String? genderPreference,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      if (city != null && city.isNotEmpty)
        "city": city,
      if (locality != null && locality.isNotEmpty)
        "locality": locality,
      if (roomType != null && roomType.isNotEmpty)
        "roomType": roomType,
      if (minRent != null)
        "minRent": minRent.toString(),
      if (maxRent != null)
        "maxRent": maxRent.toString(),
      if (genderPreference != null &&
          genderPreference.isNotEmpty)
        "genderPreference": genderPreference,
      "page": page.toString(),
      "limit": limit.toString(),
    };

    final uri = Uri.parse(
        "https://api.gharzoreality.com/api/rooms/available/search")
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        body['success'] == true) {
      return RoomSearchResponse.fromJson(body);
    } else {
      throw Exception(
          body['message'] ?? "Failed to fetch rooms");
    }
  }


  //-----------------update room
  static Future<UpdateRoomResponseModel> updateRoom({
    required String roomId,
    required UpdateRoomRequestModel body,
  }) async {
    final response = await http.put(
      Uri.parse("${ApiConstant.baseUrl}/api/rooms/$roomId"),
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer YOUR_TOKEN"
      },
      body: jsonEncode(body.toJson()),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return UpdateRoomResponseModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "Room update failed");
    }
  }


  //-----------------Update room image

  static Future<UpdateRoomImagesResponseModel> updateRoomImages({
    required String roomId,
    required List<File> images,
  }) async {
    final uri = Uri.parse("${ApiConstant.baseUrl}/api/rooms/$roomId/images");
    final request = http.MultipartRequest("POST", uri);

    request.headers.addAll({
      // "Authorization": "Bearer YOUR_TOKEN",
    });

    for (var img in images) {
      request.files.add(
        await http.MultipartFile.fromPath("images", img.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return UpdateRoomImagesResponseModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "Image upload failed");
    }
  }

  /* ---------- 8. Toggle Room Status ---------- */
  static Future<ToggleRoomStatusResponseModel> toggleRoomStatus({
    required String roomId,
    required ToggleRoomStatusRequestModel body,
  }) async {
    final response = await http.patch(
      Uri.parse("${ApiConstant.baseUrl}/api/rooms/$roomId/toggle-status"),
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer YOUR_TOKEN",
      },
      body: jsonEncode(body.toJson()),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return ToggleRoomStatusResponseModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "Room status update failed");
    }
  }

  static Future<DeleteRoomResponseModel> deleteRoom(String roomId) async {
    final response = await http.delete(
      Uri.parse("https://api.gharzoreality.com/api/rooms/$roomId"),
      headers: {
        "Content-Type": "application/json",
        // "Authorization": "Bearer YOUR_TOKEN",
      },
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      return DeleteRoomResponseModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "Room delete failed");
    }
  }


  // get room details
  static Future<RoomDetailModel> getPropertyById(String id) async {
    final response = await http.get(
      Uri.parse("https://api.gharzoreality.com/api/properties/$id"),
    );

    final body = jsonDecode(response.body);

    if (body['success'] == true) {
      return RoomDetailModel.fromJson(body['data']);
    } else {
      throw Exception("Failed to load property details");
    }
  }
}
