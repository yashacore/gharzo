import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/common/common_widget/progress_bar.dart';
import 'package:gharzo_project/model/add_property_type/city_model.dart';
import 'package:gharzo_project/screens/add_properties/builder_details_view.dart';
import 'package:gharzo_project/screens/map_picker_view.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';

class LocationView extends StatelessWidget {
  final String propertyId;

  const LocationView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final p = LocationProvider();
        p.load(propertyId); // 🔥 LOAD EDIT DATA + CITIES
        return p;
      },
      child: Scaffold(
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.selectLocation,
          onPressed: () => Navigator.pop(context),
        ),
        body: Consumer<LocationProvider>(
          builder: (context, p, _) {
            if (p.cityLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  PropertyProgressBar(
                    progress: 4 / 8, // 0.125
                    label: "Step 4 of 8 • Add Location",
                  ),

                  // ================= MAP PICKER =================
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.map_outlined),
                          label: const Text("Select from Map"),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MapPickerView(),
                              ),
                            );

                            if (result != null &&
                                result is Map<String, dynamic>) {
                              p.setFromMap(result); // ✅ PREFILL DATA
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // ================= ADDRESS =================
                        _textField(
                          label: "Address *",
                          controller: p.addressCtrl,
                        ),

                        // ================= CITY =================
                        const SizedBox(height: 16),
                        _dropdown<CityModel>(
                          label: "Select City *",
                          value: p.selectedCity,
                          items: p.cities,
                          itemLabel: (c) => c.name,
                          onChanged: (val) {
                            if (val != null) p.selectCity(val);
                          },
                        ),

                        // ================= LOCALITY =================
                        const SizedBox(height: 16),
                        p.localityLoading
                            ? const CircularProgressIndicator()
                            : _dropdown<LocalityModel>(
                                label: "Select Locality *",
                                value: p.selectedLocality,
                                items: p.localities,
                                itemLabel: (l) => l.name,
                                onChanged: (val) {
                                  if (val != null) p.selectLocality(val);
                                },
                              ),

                        // ================= STATE =================
                        const SizedBox(height: 16),
                        _textField(label: "State", controller: p.stateCtrl),

                        // ================= COORDINATES =================
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _textField(
                                label: "Latitude",
                                controller: p.latCtrl,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _textField(
                                label: "Longitude",
                                controller: p.lngCtrl,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        // ================= PINCODE =================
                        const SizedBox(height: 16),
                        _textField(
                          label: "PinCode *",
                          controller: p.pinCodeCtrl,
                          keyboardType: TextInputType.number,
                        ),

                        // ================= SUB LOCALITY =================
                        const SizedBox(height: 16),
                        _textField(
                          label: "Sub Locality",
                          controller: p.subLocalityCtrl,
                        ),

                        // ================= LANDMARK =================
                        const SizedBox(height: 16),
                        _textField(
                          label: "Landmark",
                          controller: p.landmarkCtrl,
                        ),

                        // ================= ERROR =================
                        const SizedBox(height: 24),

                        // ================= SAVE =================
                        PrimaryButton(
                          title: "Save & Continue",
                          onPressed: p.loading
                              ? null
                              : () async {
                                  final success = await p.submit(propertyId);
                                  if (success && context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BuilderDetailsView(
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _textField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(value: e, child: Text(itemLabel(e))))
          .toList(),
      onChanged: onChanged,
    );
  }
}
