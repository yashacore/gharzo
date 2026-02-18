import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/room/get_room_model/get_room_model.dart';

class RoomDetailProvider with ChangeNotifier {
  final RoomApiService _apiService = RoomApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RoomDetail? _room;
  RoomDetail? get room => _room;

  Future<void> fetchRoomById(String roomId, String token) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.getRoomById(roomId, token);
      _room = response as RoomDetail?;

    } catch (e) {
      debugPrint("Room Detail Error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
