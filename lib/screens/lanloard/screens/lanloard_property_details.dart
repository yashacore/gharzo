import 'package:flutter/material.dart';

import '../../../model/lanloard/single_property_model.dart';
import '../../../utils/theme/colors.dart';
import '../lanloard_basic_details/lanloard_basic_details_provider.dart';

class LanloardPropertyDetails extends StatelessWidget {
  SinglePropertyModel property;
  SinglePropertyProvider provider;

  LanloardPropertyDetails({
    super.key,
    required this.property,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= Property Title & Status =================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                property.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D1E),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppThemeColors().backgroundLeft),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Active',
                style: TextStyle(color: AppThemeColors().backgroundLeft),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ================= IMAGE (ONLY HERE) =================
        _buildImageSlider(property, provider),

        const SizedBox(height: 20),

        // ================= Info Cards =================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoCard(Icons.home, "Type", property.propertyType),
            _infoCard(
              Icons.straighten,
              "Area",
              "${property.area['carpet'] ?? '-'} ${property.area['unit'] ?? ''}",
            ),
            _infoCard(Icons.meeting_room, "Rooms", "${property.bhk}"),
          ],
        ),

        const SizedBox(height: 24),

        // ================= Property Details =================
        Text(
          "Property Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppThemeColors().backgroundLeft,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            _detailRow("Property Type", property.propertyType),
            _detailRow("BHK", "${property.bhk}"),
            _detailRow("Bathrooms", "${property.bathrooms}"),
            _detailRow(
              "Area",
              "${property.area['carpet'] ?? '-'} ${property.area['unit'] ?? ''}",
            ),
            _detailRow("Listing Type", property.listingType),
            _detailRow("Status", property.status),
            _detailRow("Verification", property.verificationStatus),
            _detailRow("Property Age", property.propertyAge),
          ],
        ),

        const SizedBox(height: 24),

        // ================= Owner Info =================
        Text(
          "Owner Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppThemeColors().backgroundLeft,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${property.owner['name'] ?? '-'}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text("Phone: ${property.owner['phone'] ?? '-'}"),
          ],
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildImageSlider(
      SinglePropertyModel property, SinglePropertyProvider provider) {
    if (property.images.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.home_outlined, size: 100),
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: PageView.builder(
            itemCount: property.images.length,
            onPageChanged: provider.setImageIndex,
            itemBuilder: (context, index) {
              return Image.network(
                property.images[index]['url'] ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 50),
              );
            },
          ),
        ),

        // Indicator
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              property.images.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: provider.selectedImageIndex == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: provider.selectedImageIndex == index
                      ? AppThemeColors().backgroundLeft
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppThemeColors().backgroundLeft),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
