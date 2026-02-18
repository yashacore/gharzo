import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/bulk_create_beds/bulk_create_bed_response.dart';
import 'package:gharzo_project/model/bed/bulk_create_beds/bulk_create_beds_model.dart';


class BulkCreateBedsProvider with ChangeNotifier {
  final BedApiService _apiService = BedApiService();

  bool _isLoading = false;
  String? _error;
  BulkCreateBedsResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  BulkCreateBedsResponse? get response => _response;

  Future<bool> bulkCreateBeds(BulkCreateBedsRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _apiService.bulkCreateBeds(request);
      _response = res;

      if (res.success != true) {
        _error = res.message;
      }

      _isLoading = false;
      notifyListeners();
      return res.success;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
