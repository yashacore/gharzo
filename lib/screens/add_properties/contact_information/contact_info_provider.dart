import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';

class ContactProvider extends ChangeNotifier {
  bool loading = false;
  String? error;

  String name = "";
  String phone = "";
  String alternatePhone = "";
  String email = "";
  String preferredCallTime = "Morning (9AM-12PM)";

  // ---------------- VALIDATION ----------------
  bool validate() {
    if (name.isEmpty) return _err("Contact name required");
    if (phone.length < 10) return _err("Valid phone number required");
    if (email.isNotEmpty && !email.contains("@")) return _err("Invalid email");
    return true;
  }

  bool _err(String msg) {
    error = msg;
    notifyListeners();
    return false;
  }

  // ---------------- SUBMIT ----------------
  Future<bool> submit(String propertyId) async {
    if (!validate()) return false;

    loading = true;
    error = null;
    notifyListeners();

    final body = {
      "contactName": name,
      "phone": phone,
      "alternatePhone": alternatePhone,
      "email": email,
      "preferredCallTime": preferredCallTime,
    };

    try {
      final response = await ApiServiceMethod.updateContactInfo(
        propertyId,
        body,
      );

      debugPrint("Contact Info :: $response");

      if (response['success'] == true) {
        return true;
      } else {
        error = response['message'] ?? "Failed to save contact";
        return false;
      }
    } catch (e) {
      error = "Failed to save contact";
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }


}
