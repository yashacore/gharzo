import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:gharzo_project/model/add_property_type/submit_property_model.dart';

class SubmitPropertyProvider extends ChangeNotifier {
  bool loading = false;
  String? error;

  SubmitPropertyResponseModel? response;

  Future<bool> submit(String propertyId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await ApiServiceMethod.submitProperty(propertyId);

      debugPrint("📤 SUBMIT RESPONSE RAW => $res");

      if (res['success'] == true) {
        response = SubmitPropertyResponseModel.fromJson(res['data']);

        debugPrint("🏠 Property Submitted:");
        debugPrint("ID: ${response!.propertyId}");
        debugPrint("Title: ${response!.title}");
        debugPrint("Status: ${response!.status}");
        debugPrint("Completion: ${response!.completionPercentage}");
        debugPrint("Published At: ${response!.publishedAt}");
        debugPrint("Estimated Approval Time: ${response!.estimatedApprovalTime}");

        return true;
      } else {
        error = res['message'] ?? "Submit failed";
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
