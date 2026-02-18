import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gharzo_project/model/user_model/hotel_model.dart';
import 'package:gharzo_project/screens/hotels/hotel_enquiry_form.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelDetailsScreen extends StatefulWidget {
  final HotelModel hotel;
  const HotelDetailsScreen({super.key, required this.hotel});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final h = widget.hotel;
    final colors = AppThemeColors();

    final phone = "9876543210";

    return Scaffold(
      backgroundColor: const Color(0xffF2F4F8),
      body: Stack(
        children: [

          /// 🔥 FULL IMAGE CAROUSEL
          PageView.builder(
            itemCount: h.images.isEmpty ? 1 : h.images.length,
            onPageChanged: (i) => setState(() => imageIndex = i),
            itemBuilder: (_, i) {
              if (h.images.isEmpty) {
                return Container(color: Colors.grey.shade300);
              }
              return Image.network(
                h.images[i].url,
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),

          /// DARK OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),

          /// BACK BUTTON
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          /// IMAGE INDICATOR
          Positioned(
            top: 60,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${imageIndex + 1}/${h.images.isEmpty ? 1 : h.images.length}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),

          /// CONTENT
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.58,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xffF2F4F8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  children: [

                    /// DRAG HANDLE
                    Center(
                      child: Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// NAME + BADGES
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            h.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (h.isFeatured) _Badge("FEATURED", Colors.orange),
                        if (h.isPremium) _Badge("PREMIUM", Colors.purple),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// CATEGORY
                    Text(
                      "${h.category} • ${h.propertyType}",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),

                    const SizedBox(height: 12),

                    /// LOCATION
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "${h.location.locality}, ${h.location.city}",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// PRICE CARD
                    _LuxuryPriceCard(h),

                    const SizedBox(height: 24),

                    /// ABOUT
                    _LuxurySection(
                      title: "About this place",
                      child: Text(
                        h.description,
                        style: const TextStyle(height: 1.6),
                      ),
                    ),

                    /// ROOMS
                    if (h.roomTypes.isNotEmpty)
                      _LuxurySection(
                        title: "Room Options",
                        child: Column(
                          children: h.roomTypes
                              .map((r) => _RoomLuxuryTile(r))
                              .toList(),
                        ),
                      ),

                    /// AMENITIES
                    if (_hasAmenities(h))
                      _LuxurySection(
                        title: "What this place offers",
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _allAmenities(h)
                              .map((e) => _AmenityLuxuryChip(e))
                              .toList(),
                        ),
                      ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            icon: Icons.call,
                            label: "Call Now",
                            color: colors.success,
                            onTap: () async {
                              final uri = Uri.parse("tel:$phone");
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _actionButtonWithImage(
                            imagePath: "assets/whatsapp.png",
                            label: "WhatsApp",
                            color: const Color(0xFF25D366),
                            onTap: () async {

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

                    /// 🔘 Primary CTA
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HotelEnquiryScreen(
                                hotelId: h.id,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Send Enquiry",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          /// 💎 FLOATING CTA
        ],
      ),
    );
  }

  static bool _hasAmenities(HotelModel h) =>
      h.amenities.basic.isNotEmpty ||
          h.amenities.dining.isNotEmpty ||
          h.amenities.recreation.isNotEmpty ||
          h.amenities.business.isNotEmpty ||
          h.amenities.safety.isNotEmpty ||
          h.amenities.services.isNotEmpty;

  static List<String> _allAmenities(HotelModel h) => [
    ...h.amenities.basic,
    ...h.amenities.dining,
    ...h.amenities.recreation,
    ...h.amenities.business,
    ...h.amenities.safety,
    ...h.amenities.services,
  ];

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _actionButtonWithImage({
    required String imagePath,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

/// ================= LUXURY UI WIDGETS =================

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LuxuryPriceCard extends StatelessWidget {
  final HotelModel h;
  const _LuxuryPriceCard(this.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        // gradient: const LinearGradient(
        //   colors: [Color(0xff00B09B), Color(0xff96C93D)],
        // ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 18,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "₹${h.priceRange.min} - ₹${h.priceRange.max}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),
          const Text(
            "/ night",
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}

class _LuxurySection extends StatelessWidget {
  final String title;
  final Widget child;
  const _LuxurySection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _RoomLuxuryTile extends StatelessWidget {
  final RoomTypeModel r;
  const _RoomLuxuryTile(this.r);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.king_bed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Max ${r.maxOccupancy} • ${r.bedType}"),
              ],
            ),
          ),
          Text(
            "₹${r.basePrice}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenityLuxuryChip extends StatelessWidget {
  final String text;
  const _AmenityLuxuryChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: Colors.white,
      elevation: 4,
      label: Text(text,style: TextStyle(fontSize: 12),),
    );
  }
}


