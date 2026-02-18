import 'package:flutter/material.dart';
import 'package:gharzo_project/common/lanloard_api_method/lanloard_api_method.dart';
import 'package:gharzo_project/data/room_api_service/room_api_service.dart';
import 'package:gharzo_project/model/lanloard/single_property_model.dart';

import '../../../model/room/get_room_model/get_room_model.dart';

class SinglePropertyProvider extends ChangeNotifier {
  bool isLoading = false;
  SinglePropertyModel? propertyDetail;

  int selectedImageIndex = 0;
  int selectedTabIndex = 0;

  final List<String> categories = [
    'Details',
    'Room',
    'Tenant',
    'TenantDues',
    'Commercial',
    'Banquets',
  ];

  Future<void> getPropertyDetail(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      propertyDetail = await LanloardApiService.fetchPropertyDetail(id);
    } catch (e) {
      debugPrint("Error fetching property detail: $e");
      propertyDetail = null;
    }

    isLoading = false;
    notifyListeners();
  }

  void setImageIndex(int index) {
    selectedImageIndex = index;
    notifyListeners();
  }

  void setTab(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  bool isLoadingBtn = false;
  RoomDetail? roomDetail;

  Future<void> fetchRoomDetail(String roomId, String token) async {
    isLoading = true;
    notifyListeners();

    try {
      final response =
      await RoomApiService().getRoomById(roomId, token);

      roomDetail = response as RoomDetail?;
    } catch (e) {
      debugPrint("Room detail error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

}
