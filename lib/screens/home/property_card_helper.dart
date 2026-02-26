import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gharzo_project/common/common_widget/network_image_helper.dart';

import '../../model/property_model/property_model.dart';
import 'home_provider.dart';

class PropertyCardHelper extends StatelessWidget {
final  PropertyModel property;
final    HomeProvider provider;
  const PropertyCardHelper({super.key,required this.property,required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          /// 🖼 IMAGE SECTION
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: SafeNetworkImage(
                    debugLabel: "Property Card Image",
                    imageUrl: property.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),

                /// Owner badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "User\nOwner",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),

                /// Image count
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "1/11",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 📄 DETAILS
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Price row
                Text(
                  "Ready to Move  •  Price/sq.ft ₹6.03k",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),

                /// Title
                Text(
                  property.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),

                /// Price
                Text(
                  property.formattedPrice,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                /// Location
                Text(
                  property.fullLocation,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          /// 📞 ACTION BUTTONS
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                /// View Number
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "View Number",
                      style: TextStyle(
                        color:  Color(0xFF2563EB),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                /// WhatsApp
                Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: const FaIcon(FontAwesomeIcons.whatsapp,color: Colors.white,))

                ),
                const SizedBox(width: 8),

                /// Call
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color:  Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.call,
                      color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
