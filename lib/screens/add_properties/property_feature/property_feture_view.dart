import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/common/common_widget/progress_bar.dart';
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
      create: (_) {
        final provider = FeaturesProvider();
        provider.load(propertyId); // ✅ ONLY SOURCE OF TRUTH
        return provider;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CommonWidget.gradientAppBar(
          title: PageConstVar.propertyFeature,
          onPressed: () => Navigator.pop(context),
        ),
        body: Consumer<FeaturesProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PropertyProgressBar(
                    progress: 3 / 8, // 0.125
                    label: "Step 3 of 8 • Property Features",
                  ),
                  // ================= ESSENTIAL SERVICES =================
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _chipSection(
                          icon: Icons.flash_on,
                          title: "Essential Services",
                          items: provider.essentialMaster,
                          selected: provider.essentialSelected,
                          onTap: provider.toggleEssential,
                        ),

                        const SizedBox(height: 24),

                        // ================= NEARBY PLACES =================
                        _chipSection(
                          icon: Icons.location_on_outlined,
                          title: "Nearby Places",
                          items: provider.nearbyMaster,
                          selected: provider.nearbySelected,
                          onTap: provider.toggleNearby,
                        ),

                        const SizedBox(height: 28),

                        // ================= PROPERTY FEATURES =================
                        _sectionTitle("Property Features"),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _dropdown(
                                "Power Backup",
                                provider.powerBackup,
                                ["None", "Partial", "Full"],
                                provider.setPowerBackup,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _dropdown(
                                "Water Supply",
                                provider.waterSupply,
                                ["Corporation", "Borewell", "Both"],
                                provider.setWaterSupply,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _dropdown("Flooring", provider.flooring, [
                                "Marble",
                                "Vitrified Tiles",
                                "Wooden",
                                "Granite",
                                "Ceramic",
                                "Cement",
                                "Other",
                              ], provider.setFlooring),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _dropdown(
                                "Construction Quality",
                                provider.constructionQuality,
                                [
                                  "Standard",
                                  "Above Standard",
                                  "Premium",
                                  "Luxury",
                                ],
                                provider.setConstructionQuality,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: _numberField(
                                "Ceiling Height (ft)",
                                provider.ceilingHeight?.toString(),
                                (v) => provider.ceilingHeight = int.tryParse(v),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _numberField(
                                "Road Width (ft)",
                                provider.widthOfFacingRoad?.toString(),
                                (v) => provider.widthOfFacingRoad =
                                    int.tryParse(v),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _dropdown(
                          "Waste Disposal",
                          provider.wasteDisposal,
                          ["Municipal", "Private", "Biogas Plant", "None"],
                          provider.setWasteDisposal,
                        ),

                        const SizedBox(height: 24),

                        // ================= SWITCHES =================
                        _switchRow(
                          "Gated Security",
                          provider.gatedSecurity,
                          provider.setGatedSecurity,
                          "Lift Available",
                          provider.liftAvailable,
                          provider.setLiftAvailable,
                        ),

                        _switchRow(
                          "Pet Friendly",
                          provider.petFriendly,
                          provider.setPetFriendly,
                          "Bachelors Allowed",
                          provider.bachelorsAllowed,
                          provider.setBachelorsAllowed,
                        ),

                        _switchRow(
                          "Non-Veg Allowed",
                          provider.nonVegAllowed,
                          provider.setNonVegAllowed,
                          "Boundary Wall",
                          provider.boundaryWall,
                          provider.setBoundaryWall,
                        ),

                        const SizedBox(height: 32),

                        // ================= SAVE =================
                        PrimaryButton(
                          title: "Save & Continue",
                          onPressed: provider.loading
                              ? null
                              : () async {
                                  final success = await provider.submit(
                                    propertyId,
                                  );
                                  if (success && context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LocationView(
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

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  );

  Widget _chipSection({
    required IconData icon,
    required String title,
    required List<String> items,
    required List<String> selected,
    required Function(String) onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.deepPurple),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items.map((e) {
            final isSelected = selected.contains(e);
            return InkWell(
              onTap: () => onTap(e),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: isSelected ? Colors.deepPurple : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Colors.deepPurple
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  e,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ],
    );
  }

  Widget _numberField(String label, String? value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _switchRow(
    String t1,
    bool v1,
    Function(bool) c1,
    String t2,
    bool v2,
    Function(bool) c2,
  ) {
    return Row(
      children: [
        Expanded(child: _switch(t1, v1, c1)),
        Expanded(child: _switch(t2, v2, c2)),
      ],
    );
  }

  Widget _switch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
