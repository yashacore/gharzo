import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/dashboard/dashboardh_view.dart';
import 'package:gharzo_project/screens/lanloard/lonloard_create_tanant/lanloard_provider.dart';
import 'package:gharzo_project/utils/validation/validation.dart';
import 'package:provider/provider.dart';

import '../../../utils/pageconstvar/page_const_var.dart';

class CreateTenantView extends StatefulWidget {
  const CreateTenantView({super.key});

  @override
  State<CreateTenantView> createState() => _CreateTenantViewState();
}

class _CreateTenantViewState extends State<CreateTenantView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTenancyProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.createTenancy,
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => DashboardView(),));
          },
        ),
        body: Form(
          key: value.formKey,
          child: Column(
            children: [
              propertyIdTextFormField(value),
              SizedBox(height: 16),
              tenantNameTextFormField(value),
               SizedBox(height: 16),
              rentAmountTextFormField(value),
               SizedBox(height: 24),
              value.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: CommonWidget.commonElevatedBtn(
                    btnText: "Create Tenant",
                  isLoading: value.isLoadingBtn,
                  onPressed: () {

                  },
                )
              ),
            ],
          ),
        ),
      );
    },);
  }

  Widget propertyIdTextFormField(CreateTenancyProvider value) =>
      CommonWidget.commonTextFormField(
        hint: PageConstVar.propertyId,
        controller: value.propertyIdController,
        keyboardType: TextInputType.number,
        validator: (val) => Validation.numberField(val, fieldName: "Property ID"),
      );

  Widget tenantNameTextFormField(CreateTenancyProvider value) =>
      CommonWidget.commonTextFormField(
        hint: PageConstVar.tenantName,
        controller: value.tenantNameController,
        keyboardType: TextInputType.text,
        validator: (val) => Validation.requiredField(val, fieldName: "Tenant Name"),
      );

  Widget rentAmountTextFormField(CreateTenancyProvider value) =>
      CommonWidget.commonTextFormField(
        hint: PageConstVar.rentAmount,
        controller: value.rentController,
        keyboardType: TextInputType.number,
        validator: (val) => Validation.numberField(val, fieldName: "Rent Amount"),
      );
}

