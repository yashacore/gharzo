import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/search_provider.dart';
import 'package:gharzo_project/screens/property_details/property_details.dart';
import 'package:gharzo_project/screens/property_details/property_details_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

import '../../model/search_property_model.dart';


class PropertySearchScreen extends StatefulWidget {
  const PropertySearchScreen({super.key});

  @override
  State<PropertySearchScreen> createState() =>
      _PropertySearchScreenState();
}

class _PropertySearchScreenState extends State<PropertySearchScreen> {
  double _appBarHeight(BuildContext context) {
    return kToolbarHeight + MediaQuery.of(context).padding.top;
  }
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // context.read<PropertySearchProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: CommonWidget.gradientAppBar(title: "Search Property",onPressed: () {
        Navigator.pop(context);
      },),
      body: Consumer<PropertySearchProvider>(
        builder: (_, provider, __) {
          return Column(
            children: [
              // 🔍 Search bar at top
              Padding(
                padding: const EdgeInsets.all(16),
                child: _searchBar(provider),
              ),

              // 📋 Content below
              Expanded(
                child: provider.isInitial
                    ? const Center(
                  child: Text(
                    'Start typing to search properties',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : _buildBody(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(PropertySearchProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty) {
      return Center(child: Text(provider.error));
    }

    if (provider.properties.isEmpty) {
      return const Center(child: Text('No properties found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.properties.length,
      itemBuilder: (_, index) {
        return PropertyCard(property: provider.properties[index]);
      },
    );
  }

  /// 🔍 MODERN SEARCH BAR
  Widget _searchBar(PropertySearchProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by locality, BHK, amenities...",
                border: InputBorder.none,
              ),
              onChanged: provider.updateSearch,
            ),
          ),
        ],
      ),
    );
  }
  Widget _centeredSearch(PropertySearchProvider provider) {
    final appBarHeight = _appBarHeight(context);

    return Transform.translate(
      offset: Offset(0, appBarHeight / 2),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.home_work_outlined,
                size: 64,
                color: AppThemeColors().primary.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              const Text(
                'Find your perfect property',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Search by city, locality, BHK or amenities',
                style: TextStyle(
                  fontSize: 13,
                  color: AppThemeColors().textGrey,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: _searchBar(provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: property.image.isNotEmpty
                ? Image.network(
              property.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imagePlaceholder(),
            )
                : _imagePlaceholder(),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                Text(
                  property.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                /// LOCATION
                Text(
                  '${property.locality}, ${property.city}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 10),

                /// DETAILS
                Row(
                  children: [
                    _chip('${property.bhk} BHK'),
                    _chip('${property.area} sqft'),
                    _chip(property.propertyType),
                  ],
                ),

                const SizedBox(height: 12),

                /// PRICE
                /// PRICE + VIEW DETAILS
                Row(
                  children: [
                    // 💰 Price (left)
                    Expanded(
                      child: Text(
                        '₹${property.price} / month',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    // 👉 View Details Button (right)
                    ElevatedButton(
                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChangeNotifierProvider(
                                  create: (_) =>
                                      PropertyDetailProvider(),
                                  child: PropertyDetailScreen(
                                    propertyId: property.id,
                                  ),
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeColors().primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
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

  Widget _chip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
  Widget _imagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: Colors.grey,
      ),
    );
  }

}
