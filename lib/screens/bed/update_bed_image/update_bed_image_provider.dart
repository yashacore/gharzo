import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/update_bed_image/update_bed_image_model.dart';


class UpdateBedImagesProvider with ChangeNotifier {
  final BedApiService _apiService = BedApiService();

  bool _isLoading = false;
  String? _error;
  UpdateBedImagesResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UpdateBedImagesResponse? get response => _response;

  Future<bool> updateBedImages({
    required String token,
    required String bedId,
    required List<File> images,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _response = await _apiService.updateBedImages(
        token: token,
        bedId: bedId,
        images: images,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
