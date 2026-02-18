import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/get_bed_by_room/get_bed_by_room_model.dart';

class GetBedsByRoomProvider extends ChangeNotifier {
  bool isLoading = false;
  GetBedsByRoomResponseModel? responseModel;
  String? error;

  Future<void> fetchBedsByRoom({
    required String token,
    required String roomId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      responseModel = await BedApiService.getBedsByRoom(
        token: token,
        roomId: roomId,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
}
