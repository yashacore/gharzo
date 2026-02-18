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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼 Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: image != null && image.isNotEmpty
                ? Image.network(
              image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
                : _placeholder(),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🏷 Service Name
                Text(
                  service.serviceName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                /// 🏢 Provider
                Text(
                  service.provider.companyName,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 8),

                /// 📍 Location
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      service.provider.city,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 📝 Description
                Text(
                  service.shortDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 14),

                /// 💰 Price + CTA
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '₹${service.pricing.amount} ${service.pricing.type}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => ServicesProvider(),
                              child:  ServiceDetailsScreen(service: service),
                            ),
                          ),
                        );
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeColors().primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(fontSize: 12),
                      ),
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

  Widget _placeholder() {
    return Container(
      height: 180,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );
  }
}
