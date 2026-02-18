import 'package:flutter/material.dart';
import 'package:gharzo_project/data/bed_api_service/bed_api_service.dart';
import 'package:gharzo_project/model/bed/get_bed_by_id/get_bed_by_id_model.dart';

class GetBedByIdProvider extends ChangeNotifier {
  bool isLoading = false;
  GetBedByIdResponseModel? responseModel;
  String? error;

  Future<void> fetchBedById({
    required String token,
    required String bedId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      responseModel = await BedApiService.getBedById(
        token: token,
        bedId: bedId,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
    }
  }
}
