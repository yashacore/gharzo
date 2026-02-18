import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/model/reels/reel_search_model.dart';
import 'package:gharzo_project/model/reels/reels_feed_model.dart';
import 'package:http/http.dart' as http;

class ReelsSearchProvider extends ChangeNotifier {
  List<ReelSearchModel> reels = [];
  bool isLoading = false;
  int totalPages = 1;

  /// Search reels with query parameters
  Future<void> searchReels({
    required String query,
    required String city,
    List<String>? tags,
    int page = 1,
    int limit = 10,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final tagString = tags != null ? tags.join(',') : '';
      final uri = Uri.parse(
          'http://localhost:5000/api/reels/search?q=$query&city=$city&tags=$tagString&page=$page&limit=$limit');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<dynamic> reelsJson = data['reels'] ?? [];
        totalPages = data['totalPages'] ?? 1;

        reels = reelsJson.map((e) => ReelSearchModel.fromJson(e)).toList();
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching reels: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
