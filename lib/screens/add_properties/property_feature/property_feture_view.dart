import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/main.dart';
import 'package:gharzo_project/model/add_property_type/amenity_model.dart';
import 'package:gharzo_project/screens/add_properties/add_property_type/add_property_provider.dart';
import 'package:gharzo_project/screens/add_properties/location/location_view.dart';
import 'package:gharzo_project/screens/add_properties/property_feature/property_feature_provider.dart';
import 'package:gharzo_project/utils/pageconstvar/page_const_var.dart';
import 'package:provider/provider.dart';

class PropertyFeatureView extends StatelessWidget {
  final String propertyId;

  const PropertyFeatureView({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeaturesProvider()..fetchAmenities(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.propertyFeature,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: Consumer<FeaturesProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- Furnishing ----------
                  cardWrapper(
                    title: "Furnishing Details",
                    icon: Icons.chair_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dropdownBtn(
                          "Furnishing Type",
                          provider.furnishingType,
                          ["Unfurnished", "Semi-Furnished", "Fully-Furnished"],
                              (v) {
                            provider.furnishingType = v ?? "Unfurnished";
                            provider.notifyListeners();
                          },
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  cardWrapper(
                      title: "Other Details",
                      icon: Icons.info_outline,
                      child: Column(
                        children: [
                          dropdownBtn(
                            "Facing Direction",
                            provider.facing,
                            [
                              "North",
                              "South",
                              "East",
                              "West",
                              "North-East",
                              "North-West",
                              "South-East",
                              "South-West"
                            ],
                                (v) {
                              provider.facing = v;
                              provider.notifyListeners();
                            },
                          ),
                        ],
                      ),
                    ),
                  cardWrapper(
                    title: "Amenities",
                    icon: Icons.pool_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle("Basic Amenities"),
                        amenitiesGrid(provider.basicAmenities, provider),
                         SizedBox(height: 14),
                        sectionTitle("Society Amenities"),
                        amenitiesGrid(provider.societyAmenities, provider),
                         SizedBox(height: 14),
                        sectionTitle("Nearby Places"),
                        amenitiesGrid(provider.nearbyAmenities, provider),
                      ],
                    ),
                  ),

                  // ---------- Property Rules ----------
                  cardWrapper(
                    title: "Property Rules & Facilities",
                    icon: Icons.settings_outlined,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dropdownBtn("Power Backup", provider.powerBackup, ["None","Partial","Full"],
                            provider.setPowerBackup),
                        dropdownBtn("Water Supply", provider.waterSupply, ["Borewell","Corporation","Both"],
                            provider.setWaterSupply),
                        _switch("Lift Available", provider.liftAvailable, provider.setLiftAvailable),
                      ],
                    ),
                  ),

                  if (provider.error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                             Icon(Icons.error_outline, color: Colors.red, size: 20),
                             SizedBox(width: 8),
                            Expanded(
                              child: Text(provider.error!,
                                  style:  TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    ),

                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: CommonWidget.commonElevatedBtn(
                      btnText: "Save Features",
                      isLoading: provider.loading,
                      onPressed: provider.loading
                          ? null
                          : () async {
                        final success = await provider.submit(propertyId);
                        if (success && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LocationView(propertyId: propertyId),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= HELPERS =================
  int responsiveCount(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w > 900) return 4;
    if (w > 600) return 3;
    return 2;
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget amenitiesGrid(List<AmenityModel> amenities, FeaturesProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: amenities.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsiveCount(navigatorKey.currentContext!),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (_, i) {
        final amenity = amenities[i];
        final isSelected = provider.amenitiesList.contains(amenity.name);

        return customToggleChip(
          label: amenity.name,
          emoji: amenity.icon,
          isSelected: isSelected,
          onTap: () => provider.toggleAmenity(amenity.name),
        );
      },
    );
  }

  Widget chipLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500));
  }

  Widget numberField(String label, Function(int) onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter $label",
        labelStyle: const TextStyle(fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
      ),
      onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
    );
  }

  Widget dropdownBtn(String label, String? value, List<String> items, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        hint: Text("Select $label"),
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: "Select $label",
          labelStyle: const TextStyle(fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }

  Widget _switch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget customToggleChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    String? emoji,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
            width: 1.4,
          ),
        ),
        child: Center(child: Text(label)),
      ),
    );
  }

  Widget cardWrapper({required String title, required IconData icon, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}
