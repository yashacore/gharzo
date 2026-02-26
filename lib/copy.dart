import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/model/property_model/property_model.dart';

class HomeProvider extends ChangeNotifier {
  static const String _baseUrl =
      'https://api.gharzoreality.com/api/public/properties';

  bool isLoading = false;

  List<PropertyModel> _allProperties = [];

  List<PropertyModel> get allProperties => _allProperties;

  /// ✅ ONLY last 24 hours properties
  List<PropertyModel> get propertiesLast24Hours {
    return _allProperties
        .where((p) => p.isUploadedInLast24Hours)
        .toList();
  }

  /// 🔥 DIRECT API METHOD (NO ApiService)
  Future<void> fetchPublicProperties() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List data = decoded['data'] ?? [];

        _allProperties =
            data.map((e) => PropertyModel.fromJson(e)).toList();
      } else {
        debugPrint(
          '❌ API Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('❌ fetchPublicProperties error: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}