import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MortgageEnquiryService {
  static const String _url = "https://api.gharzoreality.com/api/mortgage";

  static Future<bool> submitMortgageEnquiry(
    Map<String, dynamic> payload,
  ) async {
    try {
      debugPrint("🔹 [Mortgage API] Request URL: $_url");
      debugPrint("🔹 [Mortgage API] Request Headers:");
      debugPrint(
        const JsonEncoder.withIndent('  ').convert({
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
      );

      debugPrint("🔹 [Mortgage API] Request Body:");
      debugPrint(const JsonEncoder.withIndent('  ').convert(payload));

      final response = await http.post(
        Uri.parse(_url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("🔹 [Mortgage API] Response Status: ${response.statusCode}");
      debugPrint("🔹 [Mortgage API] Response Body:");
      debugPrint(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ [Mortgage API] Enquiry submitted successfully");
        return true;
      } else {
        debugPrint("❌ [Mortgage API] Failed to submit enquiry");
        return false;
      }
    } catch (e, stack) {
      debugPrint("🔥 [Mortgage API] Exception occurred");
      debugPrint("Error: $e");
      debugPrint("StackTrace: $stack");
      return false;
    }
  }
}
