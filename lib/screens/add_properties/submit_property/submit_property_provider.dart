import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:gharzo_project/model/add_property_type/submit_property_model.dart';

class SubmitPropertyProvider extends ChangeNotifier {
  bool loading = false;
  String? error;
  SubmitPropertyResponseModel? response;

  /// ✅ REQUIRED STEPS (BACKEND SOURCE OF TRUTH)
  static const List<String> allRequiredSteps = [
    "property-type",
    "basic-details",
    "price-details",
    "property-features",
    "location-details",
    "ownership-details",
    "builder-details",
    "upload-photos",
    "contact-info",
  ];

  /// ✅ USER-FRIENDLY LABELS
  static const Map<String, String> stepLabels = {
    "property-type": "Property Type",
    "basic-details": "Basic Details",
    "price-details": "Price Details",
    "property-features": "Property Features",
    "location-details": "Location",
    "ownership-details": "Ownership Details",
    "builder-details": "Builder Details",
    "upload-photos": "Photos",
    "contact-info": "Contact Information",
  };

  List<String> _getMissingSteps(List<String> completed) {
    return allRequiredSteps.where((step) => !completed.contains(step)).toList();
  }

  Future<bool> submit(String propertyId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await ApiServiceMethod.submitProperty(propertyId);
      final completedSteps = List<String>.from(
        res['data']?['completedSteps'] ?? [],
      );

      debugPrint("📦 completedSteps => $completedSteps");
      debugPrint("📤 SUBMIT RESPONSE RAW => $res");

      if (res['success'] == true) {
        response = SubmitPropertyResponseModel.fromJson(res['data']);
        return true;
      } else {
        final completedSteps = List<String>.from(
          res['data']?['completedSteps'] ?? [],
        );

        final missing = _getMissingSteps(completedSteps);

        final missingLabels = missing.map((e) => stepLabels[e] ?? e).toList();

        error = missingLabels.isNotEmpty
            ? "Please complete:\n• ${missingLabels.join('\n• ')}"
            : res['message'] ?? "Submit failed";

        debugPrint("❌ Missing Steps => $missingLabels");
        return false;
      }
    } catch (e) {
      error = "Submission failed";
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
