import 'package:flutter/material.dart';
import 'package:gharzo_project/data/property_api_service/visit_api_service.dart';
import 'package:gharzo_project/model/model/my_visit_model.dart';

class MyVisitProvider extends ChangeNotifier {
  bool isLoading = false;
  List<MyVisit> visits = [];

  Future<void> loadMyVisits() async {
    debugPrint("🟡 loadMyVisits() called");

    isLoading = true;
    notifyListeners();
    debugPrint("⏳ isLoading = true");

    final response = await VisitService.fetchMyVisits();

    if (response == null) {
      debugPrint("❌ fetchMyVisits() returned NULL");
    } else {
      debugPrint("✅ fetchMyVisits() success");
      debugPrint("➡️ Total visits: ${response.visits.length}");
    }

    visits = response?.visits ?? [];
    debugPrint("📦 visits list updated | count = ${visits.length}");

    isLoading = false;
    notifyListeners();
    debugPrint("✅ isLoading = false");
  }
}
