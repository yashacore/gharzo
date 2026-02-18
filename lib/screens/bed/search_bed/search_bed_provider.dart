import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/search_bed/search_bed_model.dart';


class SearchBedsProvider with ChangeNotifier {
  final BedApiService _apiService = BedApiService();

  bool _isLoading = false;
  String? _error;
  List<BedSearchItem> _beds = [];
  int _page = 1;
  int _pages = 1;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<BedSearchItem> get beds => _beds;
  int get page => _page;
  int get pages => _pages;

  Future<void> searchBeds({
    required String city,
    int? minRent,
    int? maxRent,
    bool? hasAC,
    bool reset = true,
  }) async {
    if (reset) {
      _beds = [];
      _page = 1;
      _pages = 1;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.searchBeds(
        city: city,
        minRent: minRent,
        maxRent: maxRent,
        hasAC: hasAC,
        page: _page,
      );

      _beds.addAll(response.data);
      _pages = response.pages;
      _page++;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
