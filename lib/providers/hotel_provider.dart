import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/model/user_model/hotel_model.dart';
import 'package:http/http.dart' as http;

class HotelProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  int selectedTab = 0;
  String searchQuery = '';

  Timer? _debounce;
  int _searchRequestId = 0;

  List<HotelModel> _allHotels = []; // MASTER LIST
  List<HotelModel> hotels = [];     // UI LIST

  void _log(String msg) {
    debugPrint('🏨 [HotelProvider] $msg');
  }

  /// ================= FETCH HOTELS =================
  Future<void> fetchHotels() async {
    _log('fetchHotels() START');

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.gharzoreality.com/api/hotels'),
      );

      _log('API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded['data'];

        _allHotels = list.map((e) => HotelModel.fromJson(e)).toList();
        hotels = List.from(_allHotels);

        _log('Hotels fetched: ${_allHotels.length}');
      } else {
        error = 'Failed to load hotels';
      }
    } catch (e) {
      error = e.toString();
      _log('EXCEPTION: $error');
    }

    isLoading = false;
    notifyListeners();
    _log('fetchHotels() END');
  }

  /// ================= SEARCH (API) =================
  Future<void> searchHotels(String value) async {
    searchQuery = value;
    selectedTab = 0; // ✅ RESET TAB
    _log('searchHotels("$value")');

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final requestId = ++_searchRequestId;
      _log('Debounced requestId=$requestId');

      if (value.trim().isEmpty) {
        hotels = List.from(_allHotels);
        notifyListeners();
        _log('Search cleared → restore all');
        return;
      }

      isLoading = true;
      notifyListeners();

      try {
        final uri = Uri.parse(
          'https://api.gharzoreality.com/api/public/properties',
        ).replace(queryParameters: {
          'search': value,
          'limit': '20',
        });

        final response = await http.get(uri);

        if (requestId != _searchRequestId) {
          _log('Ignored outdated response');
          return;
        }

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final List list = decoded['data'];

          hotels = list.map((e) => HotelModel.fromJson(e)).toList();
          _log('Search results: ${hotels.length}');
        }
      } catch (e) {
        error = e.toString();
        _log('SEARCH ERROR: $error');
      }

      isLoading = false;
      notifyListeners();
    });
  }

  /// ================= FILTER TABS =================
  void filterByTab(int index) {
    selectedTab = index;
    _log('filterByTab($index)');

    // 🔥 ALWAYS FILTER FROM MASTER LIST
    List<HotelModel> baseList = List.from(_allHotels);

    switch (index) {
      case 0: // All
        hotels = baseList;
        break;

      case 1: // 5 Star
        hotels = baseList
            .where((h) => h.category.contains('5'))
            .toList();
        break;

      case 2: // Featured
        hotels = baseList.where((h) => h.isFeatured).toList();
        break;
      case 3: // Budget
        hotels = baseList
            .where((h) => h.priceRange.min < 5000)
            .toList();
        break;

    }

    _log('Filtered count: ${hotels.length}');
    notifyListeners();
  }


  Future<bool> submitEnquiry({
    required String hotelId,
    required Map<String, dynamic> data,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("https://api.gharzoreality.com/api/hotels/$hotelId/enquiry"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      isLoading = false;
      notifyListeners();

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
