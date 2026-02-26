import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/tenancy_model.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/data/db_service/db_service.dart';

class TenancyDashboardProvider extends ChangeNotifier {
  final String baseUrl = "https://api.gharzoreality.com/api";

  bool loading = false;
  List<TenancyModel> tenancies = [];

  Future<void> fetchTenancies() async {
    loading = true;
    notifyListeners();

    try {
      final token = await PrefService.getToken();

      debugPrint("🔄 FETCH TENANCIES STARTED");

      final res = await http.get(
        Uri.parse(
          "https://api.gharzoreality.com/api/tenancies/landlord/my-tenancies",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("📡 STATUS: ${res.statusCode}");
      debugPrint("📡 BODY: ${res.body}");

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final List list = body['data'] ?? [];

        tenancies = list.map((e) => TenancyModel.fromJson(e)).toList();

        debugPrint("✅ TENANCIES LOADED: ${tenancies.length}");
      } else {
        debugPrint("❌ FAILED TO LOAD TENANCIES");
      }
    } catch (e) {
      debugPrint("🔥 ERROR FETCHING TENANCIES: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<bool> updateTenancy({
    required String tenancyId,

    required int bedNumber,

    required DateTime agreementStart,
    required DateTime agreementEnd,
    required int durationMonths,
    required bool renewalOption,
    required bool autoRenew,

    required int monthlyRent,
    required int securityDeposit,
    required bool securityDepositPaid,
    DateTime? securityDepositPaidDate,
    required int maintenanceCharges,
    required int rentDueDay,
    required int lateFeePerDay,
    required int gracePeriodDays,

    required String emergencyName,
    required String emergencyPhone,
    required String emergencyRelation,

    required String employmentType,
    String? companyName,
    String? designation,

    required String idProofType,
    required String idProofNumber,

    required bool policeVerified,
    DateTime? policeVerifiedOn,

    required DateTime moveInDate,
    required DateTime moveOutDate,

    required String status,
  }) async {
    debugPrint("🔄 UPDATE TENANCY STARTED");

    final token = await PrefService.getToken();

    final payload = {
      "bedNumber": bedNumber,
      "agreement": {
        "startDate": agreementStart.toIso8601String(),
        "endDate": agreementEnd.toIso8601String(),
        "durationMonths": durationMonths,
        "renewalOption": renewalOption,
        "autoRenew": autoRenew,
      },
      "financials": {
        "monthlyRent": monthlyRent,
        "securityDeposit": securityDeposit,
        "securityDepositPaid": securityDepositPaid,
        "securityDepositPaidDate": securityDepositPaidDate?.toIso8601String(),
        "maintenanceCharges": maintenanceCharges,
        "rentDueDay": rentDueDay,
        "lateFeePerDay": lateFeePerDay,
        "gracePeriodDays": gracePeriodDays,
      },
      "tenantInfo": {
        "emergencyContact": {
          "name": emergencyName,
          "phone": emergencyPhone,
          "relation": emergencyRelation,
        },
        "employmentDetails": {
          "type": employmentType,
          "companyName": companyName,
          "designation": designation,
        },
        "idProof": {"type": idProofType, "number": idProofNumber},
        "policeVerification": {
          "done": policeVerified,
          "verifiedOn": policeVerifiedOn?.toIso8601String(),
        },
      },
      "occupancy": {
        "moveInDate": moveInDate.toIso8601String(),
        "moveOutDate": moveOutDate.toIso8601String(),
      },
      "status": status,
    };

    payload.forEach((k, v) => debugPrint("➡️ $k : $v"));

    final res = await http.put(
      Uri.parse("$baseUrl/tenancies/$tenancyId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    debugPrint("📡 STATUS: ${res.statusCode}");
    debugPrint("📡 BODY: ${res.body}");

    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<bool> rejectTenancy({
    required String tenancyId,
    required String reason,
  }) async {
    debugPrint("⛔ REJECT TENANCY STARTED");
    debugPrint("➡️ tenancyId: $tenancyId");
    debugPrint("➡️ reason: $reason");

    final token = await PrefService.getToken();

    final res = await http.patch(
      Uri.parse("$baseUrl/tenancies/$tenancyId/reject"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"reason": reason}),
    );

    debugPrint("📡 STATUS: ${res.statusCode}");
    debugPrint("📡 BODY: ${res.body}");

    return res.statusCode == 200 || res.statusCode == 201;
  }
}
