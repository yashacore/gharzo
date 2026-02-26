// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/common/common_widget/progress_bar.dart';
import 'package:gharzo_project/screens/add_properties/property_feature/property_feture_view.dart';
import 'package:provider/provider.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/add_properties/property_details/property_details_provider.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';

class BasicDetailsView extends StatelessWidget {
  final String propertyId;
  final String listingType;

  const BasicDetailsView({
    super.key,
    required this.propertyId,
    required this.listingType,
  });

  static const _primaryColor = Colors.indigo;
  static final _borderRadius = BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BasicDetailsProvider(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.basicDetails,
          onPressed: () => Navigator.pop(context),
        ),
        body: Consumer<BasicDetailsProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PropertyProgressBar(
                    progress: 2 / 8, // 0.125
                    label: "Step 2 of 8 • Basic Details",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _field(
                          label: "Property Title",
                          hint: "e.g. Spacious 3 BHK in Vijay Nagar",
                          onChanged: (v) => provider.title = v,
                        ),
                        _field(
                          label: "Description",
                          hint: "Describe your property",
                          maxLines: 4,
                          onChanged: (v) => provider.description = v,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _dropdown(
                                label: "Property Age",
                                value: provider.propertyAge,
                                items: const [
                                  "Under Construction",
                                  "0-1 year",
                                  "1-5 years",
                                  "5-10 years",
                                  "10+ years",
                                ],
                                onChanged: (v) {
                                  provider.propertyAge = v!;
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(child: _datePicker(context, provider)),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // ===== CONFIGURATION =====
                        _sectionHeader("Configuration"),
                        _counterGrid(provider),

                        const SizedBox(height: 30),

                        // ===== AREA =====
                        _sectionHeader("Area Details"),
                        Row(
                          children: [
                            Expanded(
                              child: _field(
                                label: "Carpet Area",
                                hint: "Enter value",
                                isNumber: true,
                                onChanged: (v) =>
                                    provider.carpetArea = int.tryParse(v) ?? 0,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _field(
                                label: "Built-up Area",
                                hint: "Enter value",
                                isNumber: true,
                                onChanged: (v) =>
                                    provider.builtUpArea = int.tryParse(v) ?? 0,
                              ),
                            ),
                          ],
                        ),

                        _dropdown(
                          label: "Area Unit",
                          value: provider.areaUnit,
                          items: const ["sqft", "sqm", "sqyd", "acre"],
                          onChanged: (v) {
                            provider.areaUnit = v!;
                            provider.notifyListeners();
                          },
                        ),

                        const SizedBox(height: 30),

                        // ===== PRICING =====
                        _sectionHeader("Pricing"),
                        _field(
                          label: "Price Amount",
                          hint: "₹ Enter amount",
                          isNumber: true,
                          prefixIcon: Icons.currency_rupee,
                          onChanged: (v) =>
                              provider.price = int.tryParse(v) ?? 0,
                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: _borderRadius,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: SwitchListTile(
                            title: const Text("Is Price Negotiable?"),
                            activeColor: _primaryColor,
                            value: provider.negotiable,
                            onChanged: (v) {
                              provider.negotiable = v;
                              provider.notifyListeners();
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        _field(
                          label: "Security Deposit",
                          hint: "₹ Enter amount",
                          isNumber: true,
                          onChanged: (v) =>
                              provider.securityDeposit = int.tryParse(v) ?? 0,
                        ),

                        const SizedBox(height: 40),
                        PrimaryButton(
                          title: "Save & Continue",
                          onPressed: provider.loading
                              ? null
                              : () async {
                                  final success = await provider.submit(
                                    propertyId,
                                    listingType,
                                  );

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
                      ],
                    ),
                  ),

                  // ===== PROPERTY INFO =====

                  // ===== CTA =====
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 15, left: 4),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
        letterSpacing: 1.2,
      ),
    ),
  );

  Widget _field({
    required String label,
    required String hint,
    required Function(String) onChanged,
    int maxLines = 1,
    bool isNumber = false,
    IconData? prefixIcon,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  $label",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: _borderRadius,
              borderSide: const BorderSide(color: _primaryColor),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  $label",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: _borderRadius),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );

  Widget _datePicker(
    BuildContext context,
    BasicDetailsProvider provider,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "  Available From",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      const SizedBox(height: 6),
      InkWell(
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: _borderRadius,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, size: 20, color: _primaryColor),
              const SizedBox(width: 10),
              Text(
                provider.availableFrom == null
                    ? "Select Date"
                    : "${provider.availableFrom!.year}-${provider.availableFrom!.month.toString().padLeft(2, '0')}-${provider.availableFrom!.day.toString().padLeft(2, '0')}",
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _counterGrid(BasicDetailsProvider provider) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: _borderRadius,
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: [
        _counter(
          "BHK",
          provider.bhk,
          Icons.bed,
          () {
            provider.bhk++;
            provider.notifyListeners();
          },
          () {
            if (provider.bhk > 0) provider.bhk--;
            provider.notifyListeners();
          },
        ),
        _counter(
          "Bath",
          provider.bathrooms,
          Icons.bathtub,
          () {
            provider.bathrooms++;
            provider.notifyListeners();
          },
          () {
            if (provider.bathrooms > 0) provider.bathrooms--;
            provider.notifyListeners();
          },
        ),
        _counter(
          "Balcony",
          provider.balconies,
          Icons.balcony,
          () {
            provider.balconies++;
            provider.notifyListeners();
          },
          () {
            if (provider.balconies > 0) provider.balconies--;
            provider.notifyListeners();
          },
        ),
        _counter(
          "Floor",
          provider.currentFloor,
          Icons.layers,
          () {
            provider.currentFloor++;
            provider.notifyListeners();
          },
          () {
            if (provider.currentFloor > 0) provider.currentFloor--;
            provider.notifyListeners();
          },
        ),
      ],
    ),
  );

  Widget _counter(
    String label,
    int value,
    IconData icon,
    VoidCallback add,
    VoidCallback remove,
  ) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: _primaryColor),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: remove, icon: const Icon(Icons.remove)),
          Text(
            "$value",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: add,
            icon: const Icon(Icons.add, color: _primaryColor),
          ),
        ],
      ),
    ],
  );
}
