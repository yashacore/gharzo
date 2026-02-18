import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/get_my_beds/get_my_beds_model.dart';


class MyBedsProvider with ChangeNotifier {
  final BedApiService _apiService = BedApiService();

  bool _isLoading = false;
  String? _error;
  MyBedsResponse? _response;

  bool get isLoading => _isLoading;
  String? get error => _error;
  MyBedsResponse? get response => _response;

  Future<void> fetchMyBeds(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _response = await _apiService.getMyBeds(token);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
