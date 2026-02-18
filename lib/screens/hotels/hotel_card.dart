import 'package:flutter/material.dart';
import 'package:gharzo_project/model/user_model/hotel_model.dart';
import 'package:gharzo_project/screens/hotels/hotel_details_screen.dart';
import 'package:gharzo_project/utils/theme/colors.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors();
    final images = hotel.images ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: images.isNotEmpty
                    ? Image.network(
                  images.first.url,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 180,
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.hotel,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),

              /// FEATURED BADGE
              if (hotel.isFeatured == true)
                Positioned(
                  top: 12,
                  left: 12,
                  child: _badge('FEATURED', Colors.orange),
                ),

              /// CATEGORY
              Positioned(
                top: 12,
                right: 12,
                child: _badge(
                  hotel.category ?? '',
                  colors.primary,
                ),
              ),
            ],
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME
                Text(
                  hotel.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                /// LOCATION
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${hotel.location?.city}, ${hotel.location?.state}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// AMENITIES
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: hotel.amenities?.basic
                      ?.take(4)
                      .map(
                        (a) => Chip(
                      label: Text(
                        a,
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor:
                      Colors.grey.shade100,
                    ),
                  )
                      .toList() ??
                      [],
                ),

                const SizedBox(height: 12),

                /// PRICE + CTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// PRICE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${hotel.priceRange?.min} - ₹${hotel.priceRange?.max}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Text(
                          'per night',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    /// BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelDetailsScreen(hotel: hotel),
                          ),
                        );

                      },
                      child: const Text('View',style: TextStyle(fontSize: 12,color: Colors.white),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
