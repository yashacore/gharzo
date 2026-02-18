import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/update_bed/update_bed_model.dart';


class UpdateBedProvider with ChangeNotifier {
  final BedApiService _apiService = BedApiService();

  bool _isLoading = false;
  String? _error;
  UpdateBedResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UpdateBedResponse? get response => _response;

  Future<bool> updateBed({
    required String token,
    required String bedId,
    required String bedNumber,
    required String bedType,
    required Pricing pricing,
    required BedFeatures features,
    required String condition,
    required String notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final body = {
      "bedNumber": bedNumber,
      "bedType": bedType,
      "pricing": pricing.toJson(),
      "features": features.toJson(),
      "condition": condition,
      "notes": notes,
    };

    try {
      _response = await _apiService.updateBed(
        token: token,
        bedId: bedId,
        body: body,
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
