import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/network_image_helper.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/model/add_property_type/property_details_model.dart';
import 'package:gharzo_project/screens/property_details/create_visit_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'property_details_provider.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PropertyDetailProvider>().fetchProperty(widget.propertyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF2457D7);
    const softBg = Color(0xFFF8F9FE);
    final phone = "9876543210";

    return Scaffold(
      backgroundColor: softBg,
      appBar: CommonWidget.gradientAppBar(
        title: "Property Details",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer<PropertyDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: themeColor),
            );
          }

          final property = provider.property;
          if (property == null) {
            return const Center(child: Text("No Property Found"));
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= 1. IMAGE SLIDER (Full Width) =================
                    _buildImageSlider(property),
                    const SizedBox(height: 16),

                    // ================= 2. TITLE & LOCATION =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "FOR SALE",
                            style: TextStyle(
                              color: themeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.share_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: provider.toggleSave,
                              child: Icon(
                                provider.isSaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: provider.isSaved
                                    ? Colors.red
                                    : Colors.grey,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      property.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D1E),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${property.locality}, ${property.city}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ================= PRICE CARD =================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Price",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "₹${property.price}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: themeColor,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: softBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "₹${property.pricePer}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= SPECIFICATIONS =================
                    const Text(
                      "Specifications",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 2.8,
                        children: [
                          _buildSpecItem(
                            Icons.bed_rounded,
                            "Bedrooms",
                            "${property.bhk} BHK",
                          ),
                          _buildSpecItem(
                            Icons.bathtub_rounded,
                            "Bathrooms",
                            "${property.bathrooms} Bath",
                          ),
                          _buildSpecItem(
                            Icons.straighten_rounded,
                            "Carpet Area",
                            "${property.carpetArea} ${property.areaUnit}",
                          ),
                          _buildSpecItem(
                            Icons.history_rounded,
                            "Property Age",
                            property.propertyAge,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= ACTION BUTTONS =================
                    Row(
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            title: "Call Now",
                            onPressed: () async {
                              final uri = Uri.parse("tel:$phone");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            color: Colors.green,
                            title: "WhatsApp",
                            onPressed: () async {
                              final uri = Uri.parse(
                                "https://wa.me/91$phone", // ✅ country code
                              );

                              try {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } catch (e) {
                                debugPrint("WhatsApp launch failed: $e");
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    PrimaryButton(
                      title: "Schedule Visit",
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateVisitScreen(
                              propertyId: widget.propertyId,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    // ================= DESCRIPTION =================
                    const Text(
                      "About this property",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      property.description,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Improved Spec Item Component
  Widget _buildSpecItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2457D7).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.info, color: Color(0xFF2457D7), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT FIX
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 2), // ✅ controlled spacing
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1A1D1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider(PropertyDetailModel property) {
    if (property.images.isEmpty ||
        property.images.every((e) => e.trim().isEmpty)) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 300,
        child: PageView.builder(
          itemCount: property.images.length,
          itemBuilder: (_, index) {
            return SafeNetworkImage(
              debugLabel: "SubOwnerDashboard > PropertyCard > CoverImage",

              imageUrl: property.images[index],
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
