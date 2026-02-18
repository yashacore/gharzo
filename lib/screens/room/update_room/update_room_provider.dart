import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/room/update_room/update_room_model.dart';
import 'package:gharzo_project/model/room/update_room/update_room_response_model.dart';


class UpdateRoomProvider extends ChangeNotifier {
  bool isLoading = false;
  UpdateRoomResponseModel? updatedRoom;
  String? errorMessage;

  Future<void> updateRoom({
    required String roomId,
    required UpdateRoomRequestModel body,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      updatedRoom =
      await RoomApiService.updateRoom(roomId: roomId, body: body);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    updatedRoom = null;
    errorMessage = null;
    notifyListeners();
  }
}
