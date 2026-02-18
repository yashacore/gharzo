import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/room/toggle_room/toggle_model.dart';
import 'package:gharzo_project/model/room/toggle_room/toggle_room_model.dart';


class ToggleRoomStatusProvider extends ChangeNotifier {
  bool isLoading = false;
  ToggleRoomStatusResponseModel? response;
  String? errorMessage;

  Future<void> toggleStatus({
    required String roomId,
    required String status, // Available | Under-Maintenance | Blocked
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      response = await RoomApiService.toggleRoomStatus(
        roomId: roomId,
        body: ToggleRoomStatusRequestModel(status: status),
      );
    } catch (e) {
      errorMessage = e.toString();
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
