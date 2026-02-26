import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/data/landlord/landlord_api_service.dart';
import 'package:gharzo_project/model/model/lanloard/my_property_model.dart';
import 'package:gharzo_project/model/user_room_details_model.dart';

import '../../model/model/bed/bed_model_user.dart';
import '../../model/my_properties_model.dart';
import 'package:http/http.dart' as http;

class MyPropertiesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<MyProperty> properties = [];
  List<RoomDetailsModel> rooms = [];
  PropertyDetailsModel? property;

  Future<void> loadPropertyDetails(String propertyId) async {
    debugPrint("🟡 loadPropertyDetails($propertyId)");

    isLoading = true;
    notifyListeners();

    property = await MyPropertiesApiService.fetchPropertyDetails(propertyId);

    if (property == null) {
      debugPrint("❌ Property details NULL");
    } else {
      debugPrint("✅ Property loaded: ${property!.title}");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMyProperties() async {
    debugPrint("🟡 loadMyProperties()");

    isLoading = true;
    notifyListeners();

    properties = await MyPropertiesApiService.fetchMyProperties();

    debugPrint("📦 Properties count: ${properties.length}");

    isLoading = false;
    notifyListeners();
  }

  bool creating = false;

  Future<bool> createBed(Map<String, dynamic> payload) async {
    try {
      creating = true;
      notifyListeners();

      final token = await PrefService.getToken();

      debugPrint("🟢 CREATE BED STARTED");
      debugPrint("📦 BED PAYLOAD:");
      payload.forEach((k, v) => debugPrint("➡️ $k : $v"));

      final res = await http.post(
        Uri.parse("https://api.gharzoreality.com/api/beds/create"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      creating = false;
      notifyListeners();

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      creating = false;
      notifyListeners();
      debugPrint("❌ CREATE BED ERROR: $e");
      return false;
    }
  }

  Future<void> fetchRoomsByProperty(String propertyId) async {
    try {
      debugPrint("🟡 fetchRoomsByProperty STARTED");
      debugPrint("➡️ Property ID: $propertyId");

      isLoading = true;
      notifyListeners();
      debugPrint("⏳ isLoading = true");

      // final token = await PrefService.getToken();
      // debugPrint("🔐 Token fetched: ${token != null ? 'YES' : 'NO'}");

      final url =
          "https://api.gharzoreality.com/api/rooms/property/$propertyId";
      debugPrint("🌐 API URL: $url");

      final res = await http.get(
        Uri.parse(url),
        // headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("📡 RESPONSE STATUS: ${res.statusCode}");
      debugPrint("📡 RESPONSE BODY: ${res.body}");

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        debugPrint("✅ JSON DECODE SUCCESS");

        final List list = body['data'] ?? [];
        debugPrint("📦 Rooms raw count: ${list.length}");

        // ✅ CONVERT MAP → MODEL HERE
        rooms = list.map((e) {
          debugPrint("🔄 Mapping room: ${e['_id']}");
          return RoomDetailsModel.fromJson(e);
        }).toList();

        debugPrint("✅ Rooms converted to model: ${rooms.length}");
      } else {
        debugPrint("❌ API FAILED WITH STATUS: ${res.statusCode}");
        rooms = [];
      }
    } catch (e, stack) {
      debugPrint("🔥 EXCEPTION IN fetchRoomsByProperty");
      debugPrint("ERROR: $e");
      debugPrint("STACK TRACE:\n$stack");
      rooms = [];
    }

    isLoading = false;
    notifyListeners();
    debugPrint("⏹ isLoading = false");
    debugPrint("🟢 fetchRoomsByProperty FINISHED");
  }

  Future<Map<String, dynamic>?> fetchBedDetails(String bedId) async {
    try {
      debugPrint("🟢 FETCH BED DETAILS STARTED");
      debugPrint("➡️ Bed ID: $bedId");

      final token = await PrefService.getToken();

      final res = await http.get(
        Uri.parse("https://api.gharzoreality.com/api/beds/$bedId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        debugPrint("✅ BED FETCH SUCCESS");
        return data['data'];
      }

      debugPrint("❌ BED FETCH FAILED");
      return null;
    } catch (e) {
      debugPrint("🔥 ERROR FETCH BED: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchRoomDetails(String roomId) async {
    try {
      debugPrint("🟢 FETCH ROOM DETAILS STARTED");
      debugPrint("➡️ Room ID: $roomId");

      final token = await PrefService.getToken();

      final res = await http.get(
        Uri.parse("https://api.gharzoreality.com/api/rooms/$roomId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        debugPrint("✅ ROOM FETCH SUCCESS");
        return data['data'];
      }

      debugPrint("❌ ROOM FETCH FAILED");
      return null;
    } catch (e) {
      debugPrint("🔥 ERROR FETCH ROOM: $e");
      return null;
    }
  }

  Future<List<BedModel>> fetchBedsByRoomId(String roomId) async {
    try {
      final token = await PrefService.getToken();

      final response = await http.get(
        Uri.parse('https://api.gharzoreality.com/api/beds/room/$roomId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // if needed
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['success'] == true) {
        final List bedsJson = decoded['data'];

        final beds = bedsJson.map((e) => BedModel.fromJson(e)).toList();

        debugPrint("✅ Beds fetched: ${beds.length}");
        return beds;
      } else {
        debugPrint("❌ Failed to fetch beds");
        return [];
      }
    } catch (e) {
      debugPrint("❌ fetchBedsByRoomId error: $e");
      return [];
    }
  }

  Future<bool> deleteRoom(String roomId) async {
    try {
      debugPrint("🗑 DELETE ROOM STARTED");
      debugPrint("➡️ Room ID: $roomId");

      final token = await PrefService.getToken();
      debugPrint("🔐 Token fetched");

      final res = await http.delete(
        Uri.parse("https://api.gharzoreality.com/api/rooms/$roomId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 204) {
        debugPrint("✅ ROOM DELETED SUCCESSFULLY");
        return true;
      }

      debugPrint("❌ ROOM DELETE FAILED");
      return false;
    } catch (e, stack) {
      debugPrint("🔥 DELETE ROOM ERROR: $e");
      debugPrint("STACK TRACE:\n$stack");
      return false;
    }
  }

  Future<bool> updateRoom({
    required String roomId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      debugPrint("🟡 UPDATE ROOM STARTED");
      debugPrint("➡️ Room ID: $roomId");
      debugPrint("📦 PAYLOAD: $payload");

      final token = await PrefService.getToken();

      final res = await http.put(
        Uri.parse("https://api.gharzoreality.com/api/rooms/$roomId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (e) {
      debugPrint("❌ UPDATE ROOM ERROR: $e");
      return false;
    }
  }

  Future<bool> deleteBed(String bedId) async {
    try {
      debugPrint("🗑 DELETE BED STARTED");
      debugPrint("➡️ Bed ID: $bedId");

      final token = await PrefService.getToken();
      debugPrint("🔐 Token fetched");

      final url = "https://api.gharzoreality.com/api/beds/$bedId";
      debugPrint("🌐 API URL: $url");

      final res = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 204) {
        debugPrint("✅ BED DELETED SUCCESSFULLY");
        return true;
      }

      debugPrint("❌ BED DELETE FAILED");
      return false;
    } catch (e, stack) {
      debugPrint("🔥 DELETE BED ERROR: $e");
      debugPrint("STACK TRACE:\n$stack");
      return false;
    }
  }

  Future<bool> updateBedStatus({
    required String bedId,
    required String status,
    String? notes,
  }) async {
    try {
      debugPrint("🔄 UPDATE BED STATUS STARTED");
      debugPrint("➡️ Bed ID: $bedId");
      debugPrint("➡️ Status: $status");
      debugPrint("➡️ Notes: $notes");

      final token = await PrefService.getToken();

      final url = "https://api.gharzoreality.com/api/beds/$bedId/status";
      debugPrint("🌐 API URL: $url");

      final payload = {
        "status": status,
        if (notes != null) "notes": notes,
      };

      debugPrint("📦 PAYLOAD: $payload");

      final res = await http.patch(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      if (res.statusCode == 200) {
        debugPrint("✅ BED STATUS UPDATED");
        return true;
      }

      debugPrint("❌ BED STATUS UPDATE FAILED");
      return false;
    } catch (e, stack) {
      debugPrint("🔥 UPDATE BED STATUS ERROR: $e");
      debugPrint("STACK TRACE:\n$stack");
      return false;
    }
  }
  Future<bool> updateBed({
    required String bedId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      debugPrint("🟡 UPDATE BED STARTED");
      debugPrint("➡️ Bed ID: $bedId");
      debugPrint("📦 PAYLOAD:");
      payload.forEach((k, v) => debugPrint("   $k : $v"));

      final token = await PrefService.getToken();

      final url = "https://api.gharzoreality.com/api/beds/$bedId";
      debugPrint("🌐 API URL: $url");

      final res = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      if (res.statusCode == 200) {
        debugPrint("✅ BED UPDATED SUCCESSFULLY");
        return true;
      }

      debugPrint("❌ BED UPDATE FAILED");
      return false;
    } catch (e, stack) {
      debugPrint("🔥 UPDATE BED ERROR: $e");
      debugPrint("STACK TRACE:\n$stack");
      return false;
    }
  }

  Future<bool> updateRoomStatus({
    required String roomId,
    required String status,
  }) async {
    try {
      debugPrint("🔄 UPDATE ROOM STATUS STARTED");
      debugPrint("➡️ Room ID: $roomId");
      debugPrint("➡️ Status: $status");

      const validRoomStatuses = [
        "Available",
        "Partially-Occupied",
        "Fully-Occupied",
        "Under-Maintenance",
        "Blocked",
      ];

      if (!validRoomStatuses.contains(status)) {
        debugPrint("❌ INVALID ROOM STATUS: $status");
        return false;
      }

      final token = await PrefService.getToken();
      final url =
          "https://api.gharzoreality.com/api/rooms/$roomId/toggle-status";

      final payload = {"status": status};

      debugPrint("🌐 API URL: $url");
      debugPrint("📦 PAYLOAD: $payload");

      final res = await http.patch(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      return res.statusCode == 200;
    } catch (e, stack) {
      debugPrint("🔥 UPDATE ROOM STATUS ERROR: $e");
      debugPrint("STACK TRACE:\n$stack");
      return false;
    }
  }
}
