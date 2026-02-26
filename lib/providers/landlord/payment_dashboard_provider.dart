import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/payment_model/payment_dashboard_model.dart';
import 'package:http/http.dart' as http;

class PaymentDashboardProvider extends ChangeNotifier {
  bool loading = false;
  String? error;
  List<Map<String, dynamic>> tenancies = [];
  PaymentAnalyticsResponse? analytics;

  OverallStats? get overallStats => analytics?.overallStats;

  List<MonthlyAnalytics> get monthlyAnalytics => analytics?.monthlyData ?? [];
  PaymentDashboardResponse? dashboard;
  OverduePaymentsResponse? overdueResponse;

  /// Easy accessors for UI
  List<RentPayment> get payments => dashboard?.data ?? [];

  PaymentStats? get stats => dashboard?.stats;

  List<RentPayment> get overduePayments => overdueResponse?.data ?? [];

  num get totalOverdueAmount => overdueResponse?.totalOverdue ?? 0;

  // ================= FETCH ALL PAYMENTS =================

  Future<void> fetchPayments() async {
    loading = true;
    error = null;
    notifyListeners();

    debugPrint('🔵 [Payments] Fetching ALL payments...');
    try {
      final token = await PrefService.getToken();
      debugPrint('🔑 [Payments] Token => $token');

      final response = await http.get(
        Uri.parse(
          'https://api.gharzoreality.com/api/rent-payments/landlord/my-payments',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📡 [Payments] Status Code => ${response.statusCode}');
      debugPrint('📦 [Payments] Raw Response => ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        dashboard = PaymentDashboardResponse.fromJson(decoded);
        debugPrint(
          '✅ [Payments] Loaded ${dashboard?.data.length ?? 0} payments',
        );
      } else {
        error = decoded['message'] ?? 'Failed to load payments';
        debugPrint('❌ [Payments] Error => $error');
      }
    } catch (e, s) {
      error = e.toString();
      debugPrint('🔥 [Payments] Exception => $e');
      debugPrint('📛 [Payments] StackTrace => $s');
    }

    loading = false;
    notifyListeners();
    debugPrint('🟢 [Payments] Loading finished\n');
  }

  // ================= FETCH OVERDUE PAYMENTS =================

  Future<void> fetchOverduePayments() async {
    loading = true;
    error = null;
    notifyListeners();

    debugPrint('🔴 [Overdue] Fetching OVERDUE payments...');
    try {
      final token = await PrefService.getToken();
      debugPrint('🔑 [Overdue] Token => $token');

      final response = await http.get(
        Uri.parse(
          'https://api.gharzoreality.com/api/rent-payments/landlord/overdue',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📡 [Overdue] Status Code => ${response.statusCode}');
      debugPrint('📦 [Overdue] Raw Response => ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        overdueResponse = OverduePaymentsResponse.fromJson(decoded);
        debugPrint(
          '✅ [Overdue] Loaded ${overdueResponse?.data.length ?? 0} overdue payments',
        );
        debugPrint(
          '💰 [Overdue] Total Overdue Amount => ₹${overdueResponse?.totalOverdue}',
        );
      } else {
        error = decoded['message'] ?? 'Failed to load overdue payments';
        debugPrint('❌ [Overdue] Error => $error');
      }
    } catch (e, s) {
      error = e.toString();
      debugPrint('🔥 [Overdue] Exception => $e');
      debugPrint('📛 [Overdue] StackTrace => $s');
    }

    loading = false;
    notifyListeners();
    debugPrint('🟢 [Overdue] Loading finished\n');
  }

  Future<void> fetchPaymentAnalytics() async {
    loading = true;
    error = null;
    notifyListeners();

    debugPrint('📊 [Analytics] Fetching payment analytics...');
    try {
      final token = await PrefService.getToken();
      debugPrint('🔑 [Analytics] Token => $token');

      final response = await http.get(
        Uri.parse(
          'https://api.gharzoreality.com/api/rent-payments/landlord/analytics',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📡 [Analytics] Status Code => ${response.statusCode}');
      debugPrint('📦 [Analytics] Raw Response => ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        analytics = PaymentAnalyticsResponse.fromJson(decoded);

        debugPrint('✅ [Analytics] Year => ${analytics?.year}');
        debugPrint(
          '📊 [Analytics] Monthly Records => ${analytics?.monthlyData.length}',
        );
        debugPrint(
          '💰 [Analytics] Total Expected => ₹${analytics?.overallStats.totalExpected}',
        );
      } else {
        error = decoded['message'] ?? 'Failed to load analytics';
        debugPrint('❌ [Analytics] Error => $error');
      }
    } catch (e, s) {
      error = e.toString();
      debugPrint('🔥 [Analytics] Exception => $e');
      debugPrint('📛 [Analytics] StackTrace => $s');
    }

    loading = false;
    notifyListeners();
    debugPrint('🟢 [Analytics] Loading finished\n');
  }

  Future<bool> generateRent({required Map<String, dynamic> payload}) async {
    loading = true;
    notifyListeners();

    try {
      final token = await PrefService.getToken();

      final res = await http.post(
        Uri.parse("https://api.gharzoreality.com/api/rent-payments/generate"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📤 Payload => $payload");
      debugPrint("📥 Status => ${res.statusCode}");
      debugPrint("📥 Body => ${res.body}");

      loading = false;
      notifyListeners();

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      loading = false;
      notifyListeners();
      debugPrint("❌ Rent Payment Error => $e");
      return false;
    }
  }

  Future<void> fetchMyTenancies() async {
    loading = true;
    notifyListeners();

    try {
      final token = await PrefService.getToken();

      final res = await http.get(
        Uri.parse(
          "https://api.gharzoreality.com/api/tenancies/landlord/my-tenancies",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("📥 Tenancy Status => ${res.statusCode}");

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        tenancies = List<Map<String, dynamic>>.from(body['data']);
      }
    } catch (e) {
      debugPrint("❌ Tenancy Fetch Error => $e");
    }

    loading = false;
    notifyListeners();
  }
}
