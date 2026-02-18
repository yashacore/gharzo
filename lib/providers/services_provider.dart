import 'package:flutter/material.dart';
import 'package:gharzo_project/data/reels_api_service/services_api.dart';
import 'package:gharzo_project/model/model/services_model.dart';

class ServicesProvider extends ChangeNotifier {
  bool isLoading = false;
  String error = '';
  bool isSuccess = false;

  List<ServiceModel> services = [];
  List<ServiceCategory> categories = [];

  ServicesProvider() {
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      print('🔄 FETCH SERVICES START');

      isLoading = true;
      error = '';
      notifyListeners();

      final response = await ServicesApi.fetchServices();

      print('📦 TOTAL SERVICES → ${response.data.length}');
      print('📂 TOTAL CATEGORIES → ${response.categories.length}');

      services = response.data;
      categories = response.categories;

      print('✅ PROVIDER UPDATED');
    } catch (e, stack) {
      error = e.toString();
      print('❌ ERROR → $e');
      print('📛 STACK → $stack');
    } finally {
      isLoading = false;
      notifyListeners();
      print('🏁 FETCH SERVICES END');
    }
  }

  EnquiryResponse? enquiryResponse;

  Future<void> createEnquiry(ServiceEnquiryRequest request) async {
    try {
      isLoading = true;
      error = '';
      isSuccess = false;
      notifyListeners();

      final rawJson = await ServicesApi.createEnquiry(request);

      enquiryResponse = EnquiryResponse.fromJson(rawJson);

      isSuccess = enquiryResponse?.success == true;

      debugPrint(
        "✅ ENQUIRY CREATED → ${enquiryResponse!.data.enquiry.enquiryNumber}",
      );
    } catch (e) {
      error = e.toString();
      isSuccess = false;
      debugPrint("❌ PROVIDER ERROR → $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void reset() {
    isSuccess = false;
    error = '';
    notifyListeners();
  }
}
