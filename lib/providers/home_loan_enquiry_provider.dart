import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


class HomeLoanEnquiryProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSuccess = false;
  String error = '';

  Map<String, dynamic>? response;

  static const String _homeLoanUrl =
      "https://api.gharzoreality.com/api/v2/enquiries/home-loan";

  Future<void> submit(HomeLoanEnquiryRequest request) async {
    try {
      isLoading = true;
      isSuccess = false;
      error = '';
      notifyListeners();

      final httpResponse = await http.post(
        Uri.parse(_homeLoanUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(request.toJson()),
      );

      debugPrint("📥 STATUS → ${httpResponse.statusCode}");
      debugPrint("📥 RESPONSE → ${httpResponse.body}");

      if (httpResponse.statusCode == 200 ||
          httpResponse.statusCode == 201) {
        response = jsonDecode(httpResponse.body);
        isSuccess = true;
      } else {
        error = httpResponse.body;
        isSuccess = false;
      }
    } catch (e) {
      error = e.toString();
      isSuccess = false;
      debugPrint("❌ HOME LOAN PROVIDER ERROR → $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    isLoading = false;
    isSuccess = false;
    error = '';
    response = null;
    notifyListeners();
  }
}

class LoanDetails {
  final double loanAmount;
  final double propertyValue;
  final String employmentType;
  final double monthlyIncome;

  LoanDetails({
    required this.loanAmount,
    required this.propertyValue,
    required this.employmentType,
    required this.monthlyIncome,
  });

  Map<String, dynamic> toJson() {
    return {
      "loanAmount": loanAmount,
      "propertyValue": propertyValue,
      "employmentType": employmentType,
      "monthlyIncome": monthlyIncome,
    };
  }
}
class ContactInfo {
  final String name;
  final String email;
  final String phone;

  ContactInfo({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
    };
  }
}
class HomeLoanEnquiryRequest {
  final ContactInfo contactInfo;
  final LoanDetails loanDetails;
  final String message;
  final String priority;

  HomeLoanEnquiryRequest({
    required this.contactInfo,
    required this.loanDetails,
    required this.message,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      "contactInfo": contactInfo.toJson(),
      "loanDetails": loanDetails.toJson(),
      "message": message,
      "priority": priority,
    };
  }
}
