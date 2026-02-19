import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/model/model/services_model.dart';
import 'package:gharzo_project/screens/services/service_details_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/services_provider.dart';
import '../../utils/theme/colors.dart';


class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: CommonWidget.gradientAppBar(
        title: "Services",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, provider, _) {
          // 🔍 DEBUG PRINT
          debugPrint(
            '🖥 ServicesScreen → '
                'loading=${provider.isLoading}, '
                'services=${provider.services.length}, '
                'categories=${provider.categories.length}, '
                'error=${provider.error}',
          );

          // 🔄 Loading
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (provider.error.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  provider.error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // ⚠️ Empty state
          if (provider.services.isEmpty) {
            return const Center(
              child: Text(
                'No services available',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // ✅ Success UI
          return Column(
            children: [
              /// 🔖 Categories

              /// 📋 Services list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.services.length,
                  itemBuilder: (_, index) {
                    return ServiceCard(
                      service: provider.services[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* ===================== CATEGORIES ===================== */

class _CategoriesBar extends StatelessWidget {
  final List<ServiceCategory> categories;

  const _CategoriesBar({required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final c = categories[index];
          return Chip(
            label: Text('${c.id} (${c.count})'),
            backgroundColor: Colors.white,
            shape: StadiumBorder(
              side: BorderSide(color: Colors.grey.shade300),
            ),
          );
        },
      ),
    );
  }
}

/* ===================== SERVICE CARD ===================== */

class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final String? image =
    service.images.isNotEmpty ? service.images.first.url : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // ================= TOP ROW =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      image != null
                          ? Image.network(
                        image,
                        height: 80,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 80,
                        width: 100,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      ),

                      // IMAGE COUNT / STATUS
                      Positioned(
                        left: 4,
                        bottom: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Updated",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PRICE
                      Text(
                        "₹${service.pricing.amount}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // TITLE
                      Text(
                        service.serviceName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // AREA / TYPE
                      Text(
                        service.shortDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // LOCATION
                      Text(
                        service.provider.city,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ================= ACTION BAR =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // FAVORITE
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 10),

                // GET PHONE
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {

                      },
                      style: OutlinedButton.styleFrom(
                        side:  BorderSide(color:           AppThemeColors().primary,
                      ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Get Phone No.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // CONTACT OWNER
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => ServicesProvider(),
                              child:
                              ServiceDetailsScreen(service: service),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:          AppThemeColors().primary,

                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Contact Owner",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
