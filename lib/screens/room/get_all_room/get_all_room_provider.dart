import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';

import '../../../model/room/get_all_room/get_all_room_model.dart';


class AllRoomsProvider with ChangeNotifier {
  List<AllRoomModel> _rooms = [];
  bool _isLoading = false;
  String? _error;

  List<AllRoomModel> get rooms => _rooms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRooms(String propertyId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // _rooms = await RoomApiService.getRoomsByProperty(propertyId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
