import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/add_properties/add_property_type/add_property_provider.dart';
import 'package:gharzo_project/screens/add_properties/property_details/property_details_view.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';

class AddPropertyView extends StatelessWidget {
  const AddPropertyView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PropertyDraftProvider(),
      child: Scaffold(
        appBar: CommonWidget.gradientAppBar(
        title: PageConstVar.addProperty,
          onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => BottomBarView(),));
          },
      ),
        body: Consumer<PropertyDraftProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _dropdown(
                    label: "Category",
                    hint: "Select category",
                    value: provider.category,
                    items: const ["Residential", "Commercial"],
                    onChanged: (v) => provider.category = v!,
                  ),
                  _dropdown(
                    label: "Property Type",
                    hint: "Select property type",
                    value: provider.propertyType,
                    items: const [
                      "Flat",
                      "Villa",
                      "Plot",
                      "Shop",
                      "Office",
                      "Warehouse",
                      "Studio",
                      "Independent House",
                      "Builder Floor"
                    ],
                    onChanged: (v) => provider.propertyType = v,
                  ),
                  _dropdown(
                    label: "Listing Type",
                    hint: "Select listing type",
                    value: provider.listingType,
                    items: const ["Rent", "Sale", "PG"],
                    onChanged: (v) => provider.listingType = v,
                  ),

                  if (provider.error != null)
                    Text(provider.error!,
                        style: const TextStyle(color: Colors.red)),

                  const SizedBox(height: 20),

                  SizedBox(width: double.infinity),
                  CommonWidget.commonElevatedBtn(
                    btnText: "Continue",
                    isLoading: provider.loading,
                    onPressed: provider.loading
                        ? null
                        : () async {
                      final success = await provider.saveDraft();
                      debugPrint("🆔 Property ID: ${provider.draft!.propertyId}");

                      if (success && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BasicDetailsView(
                              propertyId: provider.draft!.propertyId,
                              listingType: provider.listingType!,
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
