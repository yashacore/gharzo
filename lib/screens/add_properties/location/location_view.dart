import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/model/add_property_type/city_model.dart';
import 'package:gharzo_project/screens/add_properties/add_property_type/add_property_provider.dart';
import 'package:gharzo_project/screens/add_properties/upload_photo/upload_photo_view.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';

class LocationView extends StatelessWidget {
  final String propertyId;

  const LocationView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationProvider()..fetchCities(),
      child: Scaffold(
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.selectLocation,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Consumer<LocationProvider>(
          builder: (context, p, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ---------------- ADDRESS ----------------
                  _textField(
                    label: "Address *",
                    onChanged: (v) => p.address = v,
                  ),

                  // ---------------- CITY ----------------
                  const SizedBox(height: 16),
                  p.cityLoading
                      ? const CircularProgressIndicator()
                      : _dropdown<CityModel>(
                    label: "Select City *",
                    value: p.selectedCity,
                    items: p.cities,
                    itemLabel: (c) => c.name,
                    onChanged: (val) {
                      if (val != null) p.selectCity(val);
                    },
                  ),

                  // ---------------- LOCALITY ----------------
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

                  // ---------------- STATE ----------------
                  const SizedBox(height: 16),
                  _textField(
                    label: "State",
                    initialValue: p.state,
                    onChanged: (v) => p.state = v,
                  ),

                  // ---------------- COORDINATES ----------------
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          label: "Latitude",
                          keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (v) =>
                          p.latitude = double.tryParse(v) ?? 0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _textField(
                          label: "Longitude",
                          keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (v) =>
                          p.longitude = double.tryParse(v) ?? 0,
                        ),
                      ),
                    ],
                  ),

                  // ---------------- PINCODE ----------------
                  const SizedBox(height: 16),
                  _textField(
                    label: "PinCode *",
                    keyboardType: TextInputType.number,
                    onChanged: (v) => p.pinCode = v,
                  ),

                  // ---------------- SUB LOCALITY ----------------
                  const SizedBox(height: 16),
                  _textField(
                    label: "Sub Locality",
                    onChanged: (v) => p.subLocality = v,
                  ),

                  // ---------------- LANDMARK ----------------
                  const SizedBox(height: 16),
                  _textField(
                    label: "Landmark",
                    onChanged: (v) => p.landmark = v,
                  ),

                  // ---------------- ERROR ----------------
                  if (p.error != null) ...[
                    const SizedBox(height: 12),
                    Text(p.error!,
                        style: const TextStyle(color: Colors.red)),
                  ],

                  const SizedBox(height: 20),

                  // ---------------- SAVE BUTTON ----------------
                  CommonWidget.commonElevatedBtn(
                    btnText: "Save & Continue",
                    isLoading: p.loading,
                    onPressed: p.loading
                        ? null
                        : () async {
                      final success = await p.submit(propertyId);
                      if (success && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                UploadPhotoView(propertyId: propertyId),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =================== UI HELPERS ===================

  Widget _textField({
    required String label,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
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
          .map(
            (e) => DropdownMenuItem<T>(
          value: e,
          child: Text(itemLabel(e)),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}
