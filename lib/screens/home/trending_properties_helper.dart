import 'package:flutter/material.dart';
import 'package:gharzo_project/common/cached_image_helper.dart';
import 'package:gharzo_project/model/property_model/property_model.dart';
import 'package:provider/provider.dart';

import 'home_provider.dart';


class TrendingPropertyCard extends StatelessWidget {
  final PropertyModel property;
  final HomeProvider provider;

  const TrendingPropertyCard({
    super.key,
    required this.property,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼 IMAGE (FIXED HEIGHT)
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: CachedImage(
                    imageUrl: property.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),

                /// 🔖 TAG
                Positioned(
                  top: 10,
                  left: 10,
                  child: _TagChip(
                    text:
                    property.isFeatured ? "For Sale" : "For Rent",
                    color: property.isFeatured
                        ? Colors.blue
                        : Colors.green,
                  ),
                ),

                /// ❤️ FAVORITE
                Positioned(
                  top: 10,
                  right: 10,
                  child: Consumer<HomeProvider>(
                    builder: (_, provider, __) {
                      final isSaved = provider.isPropertySaved(property.id); // ✅ FIX

                      return GestureDetector(
                        onTap: () => provider.toggleSave(property),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isSaved ? Colors.red : Colors.grey.shade700,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),

          /// 📄 DETAILS (FLEXIBLE → FIXES OVERFLOW)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 💰 PRICE + TYPE
                Row(
                  children: [
                    Text(
                      property.formattedPrice,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _MiniChip(
                      text: property.bhk == 1 ? "Apartment" : "Villa",
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// 🏠 TITLE
                Text(
                  property.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                /// 📍 LOCATION
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.fullLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// 🛏 SPECS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SpecItem(text: "${property.bhk} Beds"),
                    _SpecItem(text: "${property.bathrooms} Baths"),
                    _SpecItem(text: property.areaText),
                  ],
                ),
              ],
            ),
          ),        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  final Color color;

  const _TagChip({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
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

class _MiniChip extends StatelessWidget {
  final String text;

  const _MiniChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.teal,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String text;

  const _SpecItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}