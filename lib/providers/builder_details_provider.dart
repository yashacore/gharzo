import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:intl/intl.dart';

class BuilderDetailsProvider extends ChangeNotifier {
  bool loading = false;
  String? error;

  // ================= CONTROLLERS =================
  final nameCtrl = TextEditingController();
  final reraCtrl = TextEditingController();
  final projectCtrl = TextEditingController();
  final totalUnitsCtrl = TextEditingController();
  final totalTowersCtrl = TextEditingController();
  final totalFloorsCtrl = TextEditingController();
  final tokenAmountCtrl = TextEditingController();

  DateTime? possessionDate;
  DateTime? launchDate;

  // ================= LOAN FACILITY =================
  bool loanAvailable = false;
  List<String> approvedBanks = [];

  // ================= BOOKING PROCESS =================
  List<String> documentsRequired = [];

  final allBanks = ["HDFC", "SBI", "ICICI", "Axis", "PNB"];
  final allDocuments = ["Aadhar", "PAN", "Address Proof"];

  // ================= DATE PICKER =================
  Future<void> pickDate(BuildContext context, bool isPossession) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (isPossession) {
        possessionDate = picked;
      } else {
        launchDate = picked;
      }
      notifyListeners();
    }
  }

  // ================= SUBMIT =================
  Future<bool> submit(String propertyId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final body = {
        "builder": {
          "name": nameCtrl.text,
          "reraId": reraCtrl.text,
          "projectName": projectCtrl.text,
          "possessionDate": _fmt(possessionDate),
          "totalUnits": int.tryParse(totalUnitsCtrl.text),
          "totalTowers": int.tryParse(totalTowersCtrl.text),
          "totalFloors": int.tryParse(totalFloorsCtrl.text),
          "launchDate": _fmt(launchDate),
          "loanFacility": {
            "available": loanAvailable,
            "approvedBanks": approvedBanks,
          },
          "bookingProcess": {
            "tokenAmount": int.tryParse(tokenAmountCtrl.text),
            "documentsRequired": documentsRequired,
          },
        },
      };

      debugPrint("🟡 UPDATE OWNERSHIP / BUILDER API CALL");
      debugPrint("🆔 Property ID: $propertyId");
      debugPrint("📤 Request Body: ${jsonEncode(body)}");

      final res = await ApiServiceMethod.updateOwnershipDetails(
        propertyId,
        body,
      );

      debugPrint("📥 Response: $res");

      if (res['success'] == true) {
        debugPrint("✅ Builder details saved successfully");
        return true;
      } else {
        error = res['message'] ?? "Save failed";
        debugPrint("❌ API Error Message: $error");
        return false;
      }
    } catch (e, s) {
      debugPrint("🔥 Exception while saving builder details");
      debugPrint("🔥 Error: $e");
      debugPrint("🔥 StackTrace: $s");
      error = "Failed to save builder details";
      return false;
    } finally {
      loading = false;
      notifyListeners();
      debugPrint("🟢 UPDATE BUILDER DETAILS END");
    }
  }

  String? _fmt(DateTime? d) =>
      d == null ? null : DateFormat("yyyy-MM-dd").format(d);
}
