import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_service_method.dart';
import 'package:gharzo_project/model/add_property_type/add_property_type_model.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';

class PropertyDraftProvider extends ChangeNotifier {
  bool loading = false;
  String? error;

  PropertyDraftModel? draft;

  String category = "Residential";
  String? propertyType;
  String? listingType;

  Future<bool> saveDraft() async {
    if (propertyType == null || listingType == null) {
      error = "Please select all fields";
      notifyListeners();
      return false;
    }

    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await ApiServiceMethod.createDraft(
        category: category,
        propertyType: propertyType ?? '',
        listingType: listingType ?? '',
      );

      debugPrint("Add Property :: $res");

      if (res['success'] == true) {
        draft = PropertyDraftModel.fromJson(res['data']);
        return true;
      } else {
        error = res['message'];
        return false;
      }
    } catch (e) {
      error = "Failed to create draft";
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void clickOnBtn(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => BottomBarView()),
          (route) => false,
    );
  }

}
