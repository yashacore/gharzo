import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/add_properties/property_details/property_details_provider.dart';
import 'package:gharzo_project/screens/add_properties/property_feature/property_feture_view.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';

class BasicDetailsView extends StatelessWidget {
  final String propertyId;
  final String listingType;

  const BasicDetailsView({
    super.key,
    required this.propertyId,
    required this.listingType,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BasicDetailsProvider(),
      child: Scaffold(
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.basicDetails,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Consumer<BasicDetailsProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ================= BASIC =================
                  _textField(
                    "Title",
                    "Enter property title",
                        (v) => provider.title = v,
                  ),

                  _textField(
                    "Description",
                    "Enter property description",
                        (v) => provider.description = v,
                    maxLines: 3,
                  ),

                  _numberField(
                    "BHK",
                    "Enter BHK",
                        (v) => provider.bhk = v,
                  ),

                  _numberField(
                    "Bathrooms",
                    "Enter bathrooms",
                        (v) => provider.bathrooms = v,
                  ),

                  _numberField(
                    "Balconies",
                    "Enter balconies",
                        (v) => provider.balconies = v,
                  ),

                  const Divider(),

                  // ================= PRICE =================
                  _numberField(
                    "Price Amount",
                    "Enter price",
                        (v) => provider.price = v,
                  ),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Negotiable"),
                    value: provider.negotiable,
                    onChanged: (v) {
                      provider.negotiable = v;
                      provider.notifyListeners();
                    },
                  ),

                  _numberField(
                    "Maintenance Charges",
                    "Monthly maintenance",
                        (v) => provider.maintenance = v,
                  ),

                  _numberField(
                    "Security Deposit",
                    "Enter security deposit",
                        (v) => provider.securityDeposit = v,
                  ),

                  const Divider(),

                  // ================= AREA =================
                  _numberField(
                    "Carpet Area",
                    "Enter carpet area",
                        (v) => provider.carpetArea = v,
                  ),

                  _numberField(
                    "Built-up Area",
                    "Enter built-up area",
                        (v) => provider.builtUpArea = v,
                  ),

                  _dropdown(
                    "Area Unit",
                    "Select area unit",
                    provider.areaUnit,
                    const ["sqft", "sqm", "sqyd", "acre", "hectare"],
                        (v) {
                      provider.areaUnit = v!;
                      provider.notifyListeners();
                    },
                  ),

                  const Divider(),

                  // ================= PROPERTY AGE =================
                  _dropdown(
                    "Property Age",
                    "Select property age",
                    provider.propertyAge,
                    const [
                      "Under Construction",
                      "0-1 year",
                      "1-5 years",
                      "5-10 years",
                      "10+ years"
                    ],
                        (v) {
                      provider.propertyAge = v!;
                      provider.notifyListeners();
                    },
                  ),

                  const Divider(),

                  // ================= FLOOR =================
                  _numberField(
                    "Current Floor",
                    "Enter current floor",
                        (v) => provider.currentFloor = v,
                  ),

                  _numberField(
                    "Total Floors",
                    "Enter total floors",
                        (v) => provider.totalFloors = v,
                  ),

                  const Divider(),

                  // ================= AVAILABLE FROM =================
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Available From"),
                    subtitle: Text(
                      provider.availableFrom == null
                          ? "Select date"
                          : _formatDate(provider.availableFrom!),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        initialDate: provider.availableFrom ?? DateTime.now(),
                      );
                      if (picked != null) {
                        provider.availableFrom = picked;
                        provider.notifyListeners();
                      }
                    },
                  ),

                  const Divider(),

                  // ================= POSTED BY =================
                  _dropdown(
                    "Posted By",
                    "Select who posted",
                    provider.postedBy,
                    const ["Owner", "Agent", "Builder", "admin", "landlord"],
                        (v) {
                      provider.postedBy = v!;
                      provider.notifyListeners();
                    },
                  ),

                  // ================= ERROR =================
                  if (provider.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        provider.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ================= SAVE BUTTON =================
                  SizedBox(
                    width: double.infinity,
                    child: CommonWidget.commonElevatedBtn(
                      btnText: "Save & Continue",
                      isLoading: provider.loading,
                      onPressed: provider.loading
                          ? null
                          : () async {
                        final success =
                        await provider.submit(propertyId, listingType);

                        if (success && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PropertyFeatureView(
                                propertyId: propertyId,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= COMMON INPUT WIDGETS =================

  Widget _textField(
      String label,
      String hint,
      Function(String) onChanged, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _numberField(
      String label,
      String hint,
      Function(int) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
      ),
    );
  }

  Widget _dropdown(
      String label,
      String hint,
      String? value,
      List<String> items,
      Function(String?) onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
