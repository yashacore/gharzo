import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactInquiryProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<void> submitInquiry({
    required String fullName,
    required String email,
    required String phone,
    required String subject,
    required String message,
    required String inquiryType,
  }) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      "https://api.gharzoreality.com/api/contact-inquiries/create",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "fullName": fullName,
          "email": email,
          "phone": phone,
          "subject": subject,
          "message": message,
          "inquiryType": inquiryType,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw data["message"] ?? "Something went wrong";
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
