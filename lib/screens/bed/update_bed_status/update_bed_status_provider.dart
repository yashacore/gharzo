import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/update_bed_status/update_bed_status_model.dart';


class UpdateBedStatusProvider with ChangeNotifier {
  final BedApiService _apiService = BedApiService();

  bool _isLoading = false;
  String? _error;
  UpdateBedStatusResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  UpdateBedStatusResponse? get response => _response;

  Future<bool> updateStatus({
    required String token,
    required String bedId,
    required String status,
    required String notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _response = await _apiService.updateBedStatus(
        token: token,
        bedId: bedId,
        status: status,
        notes: notes,
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
