import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/primary_button.dart';
import 'package:gharzo_project/model/model/banquet_model.dart';
import 'dart:ui';

import 'package:gharzo_project/screens/banquet/banquet_enquiry_form.dart'; // Required for BackdropFilter

class BanquetDetailsScreen extends StatelessWidget {
  final BanquetModel banquet;

  const BanquetDetailsScreen({super.key, required this.banquet});

  @override
  Widget build(BuildContext context) {
    final imageUrl = banquet.imageUrl.isNotEmpty
        ? banquet.imageUrl
        : 'https://via.placeholder.com/600';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              /// ================= 1. THE ARTISTIC HEADER =================
              SliverAppBar(
                expandedHeight: 450,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(imageUrl, fit: BoxFit.cover),
                      // Soft vignette overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              Colors.white,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// ================= 2. CONTENT BENTO BOXES =================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // Venue Title & Badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              banquet.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                // fontWeight: FontWeight.black,
                              ),
                            ),
                          ),
                          _buildVerifiedBadge(),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Location Pin
                      Row(
                        children: [
                          const Icon(
                            Icons.north_east,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${banquet.city}, ${banquet.state}".toUpperCase(),
                            style: const TextStyle(
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Bento Grid for Stats
                      Row(
                        children: [
                          _bentoBox(
                            flex: 2,
                            title: "Price Range",
                            value: "₹${banquet.minPrice} - ${banquet.maxPrice}",
                            subtitle: "Estimated Cost",
                            color: const Color(0xFFF8F9FF),
                          ),
                          const SizedBox(width: 12),
                          _bentoBox(
                            flex: 1,
                            title: "Type",
                            value: "Banquet",
                            icon: Icons.auto_awesome,
                            color: Colors.black,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _bentoBox(
                            flex: 1,
                            title: "Seating",
                            value: "${banquet.seating}",
                            icon: Icons.chair_alt,
                            color: const Color(0xFFF2F2F2),
                          ),
                          const SizedBox(width: 12),
                          _bentoBox(
                            flex: 1,
                            title: "Floating",
                            value: "${banquet.floating}",
                            icon: Icons.groups_3_outlined,
                            color: const Color(0xFFF2F2F2),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Description Section
                      const Text(
                        "STORY",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        banquet.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.7),
                          height: 1.8,
                        ),
                      ),

                      const SizedBox(height: 120), // Bottom padding for CTA
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// ================= 3. FLOATING GLASS NAVIGATION =================
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: _buildGlassNav(context),
          ),

          /// ================= 4. NEUMORPHIC BOTTOM CTA =================
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildCtaButton(context: context),
          ),
        ],
      ),
    );
  }

  // GLASSMORPHISM TOP BAR
  Widget _buildGlassNav(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: Colors.white.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Text(
                "DETAILS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BENTO BOX HELPER
  Widget _bentoBox({
    required int flex,
    required String title,
    required String value,
    String? subtitle,
    IconData? icon,
    required Color color,
    Color textColor = Colors.black,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon, color: textColor, size: 20),
            if (icon != null) const SizedBox(height: 12),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: textColor.withOpacity(0.6),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // FLOATING CTA BUTTON
  Widget _buildCtaButton({required BuildContext context}) {
    return PrimaryButton(
      title: "Reserve this venue",
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BanquetEnquiryScreen(
              banquetId: banquet.id.toString(),
            ),
          ),
        ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text(
        "PRO",
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
