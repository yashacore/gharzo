

import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      backgroundColor: softBg,
      appBar: CommonWidget.gradientAppBar(title: "Property Details",onPressed: () {
        Navigator.pop(context);
      },),
      body: Consumer<PropertyDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: themeColor));
          }

          final property = provider.property;
          if (property == null) {
            return const Center(child: Text("No Property Found"));
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= 1. PREMIUM IMAGE SLIDER =================
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: PageView.builder(
                                    itemCount: property.images.length,
                                    onPageChanged: provider.setImageIndex,
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        property.images[index],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                        const Center(child: Icon(Icons.broken_image, size: 50)),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Image Counter Badge
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${provider.selectedImageIndex + 1}/${property.images.length}",
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              // Pagination dots
                              Positioned(
                                bottom: 16,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(property.images.length, (index) {
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      height: 6,
                                      width: provider.selectedImageIndex == index ? 20 : 6,
                                      decoration: BoxDecoration(
                                        color: provider.selectedImageIndex == index
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Thumbnails Row
                          SizedBox(
                            height: 60,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: property.images.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () => provider.setImageIndex(index),
                                child: Container(
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: provider.selectedImageIndex == index ? themeColor : Colors.transparent,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(property.images[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= 2. TITLE & LOCATION CARD =================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                                  const Icon(Icons.share_outlined,
                                      color: Colors.grey, size: 20),
                                  const SizedBox(width: 12),

                                  /// ❤️ SAVE TOGGLE
                                  Consumer<PropertyDetailProvider>(
                                    builder: (context, provider, _) {
                                      return GestureDetector(
                                        onTap: () {
                                          provider.toggleSave();
                                        },
                                        child: Icon(
                                          provider.isSaved
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                          provider.isSaved ? Colors.red : Colors.grey,
                                          size: 22,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            property.title,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A1D1E)),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text("${property.locality}, ${property.city}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Price Box
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Total Price", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text("₹${property.price}",
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: themeColor)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(color: softBg, borderRadius: BorderRadius.circular(10)),
                                  child: Text("₹${property.pricePer}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ================= 3. CORE SPECS GRID =================
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Specifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
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
                            _buildSpecItem(Icons.bed_rounded, "Bedrooms", "${property.bhk} BHK"),
                            _buildSpecItem(Icons.bathtub_rounded, "Bathrooms", "${property.bathrooms} Bath"),
                            _buildSpecItem(Icons.straighten_rounded, "Carpet Area", "${property.carpetArea} ${property.areaUnit}"),
                            _buildSpecItem(Icons.history_rounded, "Property Age", property.propertyAge),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ================= 4. DESCRIPTION =================
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("About this property", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        property.description,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 15, height: 1.6),
                      ),
                    ),

                    const SizedBox(height: 100), // Spacer for bottom FAB
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
          child: const Icon(
            Icons.info,
            color: Color(0xFF2457D7),
            size: 20,
          ),
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
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
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
}



