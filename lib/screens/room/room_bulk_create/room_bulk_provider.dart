import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/room/bulk_create_room_model/room_buik_create_model.dart';

class RoomsProvider with ChangeNotifier {
  final RoomApiService _apiService = RoomApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BulkCreateRoomResponse? _response;
  BulkCreateRoomResponse? get response => _response;

  Future<void> bulkCreateRooms(
      BulkCreateRoomRequestModel request,
      String token,
      ) async {
    try {
      _isLoading = true;
      notifyListeners();

      _response = await _apiService.bulkCreateRooms(request, token);

    } catch (e) {
      debugPrint("Bulk Create Error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
