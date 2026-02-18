import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/room/update_room_image/update_room_image_model.dart';


class UpdateRoomImagesProvider extends ChangeNotifier {
  bool isLoading = false;
  UpdateRoomImagesResponseModel? response;
  String? errorMessage;

  Future<void> uploadRoomImages({
    required String roomId,
    required List<File> images,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      response = await RoomApiService.updateRoomImages(
        roomId: roomId,
        images: images,
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
