import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/room/delete_model/delete_room_model.dart';

class DeleteRoomProvider extends ChangeNotifier {
  bool isLoading = false;
  DeleteRoomResponseModel? response;
  String? errorMessage;

  Future<bool> deleteRoom(String roomId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      response = await RoomApiService.deleteRoom(roomId);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    response = null;
    errorMessage = null;
    notifyListeners();
  }
}
