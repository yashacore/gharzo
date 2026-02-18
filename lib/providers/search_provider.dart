import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/search_property_model.dart';

class PropertySearchProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = '';

  List<PropertyModel> properties = [];

  /// 🔹 Dynamic state
  String city = 'Indore';
  String locality = '';
  String searchQuery = '';

  Timer? _debounce;
  bool get isInitial =>
      searchQuery.isEmpty && properties.isEmpty && !isLoading;



  /// 🔍 Called on each key press
  void updateSearch(String value) {
    searchQuery = value;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchProperties();
    });
  }

  /// 🌐 API CALL
  Future<void> fetchProperties() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      final uri = Uri.https(
        'api.gharzoreality.com',
        '/api/public/properties',
        {
          'limit': '20',
          if (city.isNotEmpty) 'city': city,
          if (locality.isNotEmpty) 'locality': locality,
          if (searchQuery.isNotEmpty) 'search': searchQuery,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data'];

        properties =
            list.map((e) => PropertyModel.fromJson(e)).toList();
      } else {
        error = 'Failed to load properties';
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
