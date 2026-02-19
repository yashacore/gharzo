import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/banquet_model.dart';
import 'package:http/http.dart' as http;

class   BanquetProvider extends ChangeNotifier {
  bool isLoading = false;
  List<BanquetModel> banquets = [];

  Future<void> fetchBanquets() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.gharzoreality.com/api/banquet-halls'),
        headers: {
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded['data'];

        banquets = list
            .map((e) => BanquetModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Banquet API Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }



  static Future<bool> submitEnquiry({
    required String banquetId,
    required String name,
    required String phone,
    required String email,
    required String message,
  }) async {
    final url = Uri.parse(
      "https://api.gharzoreality.com/api/banquet-halls/$banquetId/enquiry",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "email": email,
          "message": message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint("❌ API Error: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      return false;
    }
  }
}
