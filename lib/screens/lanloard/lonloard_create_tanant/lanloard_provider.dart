import 'package:flutter/material.dart';
import 'package:gharzo_project/common/lanloard_api_method/lanloard_api_method.dart';
import 'package:gharzo_project/model/lanloard/lanloard_create_tanant_model.dart';

class CreateTenancyProvider extends ChangeNotifier {

  final formKey = GlobalKey<FormState>();

  final TextEditingController propertyIdController = TextEditingController();
  final TextEditingController tenantNameController = TextEditingController();
  final TextEditingController rentController = TextEditingController();

  bool isLoadingBtn = false;
  CreateTenancyResponse? response;

  bool get isLoading => isLoadingBtn;

  Future<bool> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    isLoadingBtn = true;
    notifyListeners();

    final body = {
      "propertyId": int.parse(propertyIdController.text.trim()),
      "tenantName": tenantNameController.text.trim(),
      "rent": double.parse(rentController.text.trim()),
    };


    try {
      response = await LanloardApiService.createTenancy(body: body);
      propertyIdController.clear();
      tenantNameController.clear();
      rentController.clear();
      return true;
    } catch (e) {
      print("Error creating tenancy: $e");
      return false;
    } finally {
      isLoadingBtn = false;
      notifyListeners();
    }
  }

}
