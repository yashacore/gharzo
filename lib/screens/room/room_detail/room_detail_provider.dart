import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/room/room_detail_model/room_detail_model.dart';

class RoomDetailProvider extends ChangeNotifier {
  RoomDetailModel? property;
  bool isLoading = false;

  Future<void> fetchRoomDetail(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      property = await RoomApiService.getPropertyById(id);
    } catch (e) {
      debugPrint("Room detail error: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
