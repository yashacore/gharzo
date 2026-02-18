import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/create_bed/create_bed_model.dart';


class CreateBedProvider extends ChangeNotifier {
  bool isLoading = false;
  CreateBedResponseModel? responseModel;
  String? error;

  Future<bool> createBed({
    required String token,
    required String roomId,
    required String bedNumber,
    required String bedType,
    required Map<String, dynamic> pricing,
    required Map<String, dynamic> features,
    required Map<String, dynamic> position,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> bedSize,
    required String condition,
    required String notes,
    List<File>? images,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      responseModel = await BedApiService.createBed(
        token: token,
        roomId: roomId,
        bedNumber: bedNumber,
        bedType: bedType,
        pricing: pricing,
        features: features,
        position: position,
        preferences: preferences,
        bedSize: bedSize,
        condition: condition,
        notes: notes,
        images: images,
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
