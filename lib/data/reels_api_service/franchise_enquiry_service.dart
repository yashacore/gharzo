import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class FranchiseEnquiryService {
  static const String _url =
      "https://api.gharzoreality.com/api/v2/enquiries/franchise";

  static Future<bool> submitFranchiseEnquiry(
      Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint("FRANCHISE API ERROR: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("FRANCHISE API EXCEPTION: $e");
      return false;
    }
  }
}
