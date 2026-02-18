import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import '../../../../model/room/get_room_model/get_room_model.dart';


class AllRoomsProvider with ChangeNotifier {
  bool isLoading = false;
  List<RoomDetail> roomList = [];
  String? errorMessage;

  Future<void> getRoomsByPropertyId(String propertyId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Api Service call
      final response = await RoomApiService.getRoomsByPropertyId(propertyId);

      // If API returns RoomDetailResponse object
      roomList = response;

    } catch (e) {
      roomList = [];
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}