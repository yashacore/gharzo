import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/providers/landlord/my_properties_provider.dart';
import 'package:gharzo_project/screens/landloard/landlord_properties/my_property_details.dart';
import 'package:provider/provider.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  final Color primaryBlue = const Color(0xFF2457D7);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyPropertiesProvider>().loadMyProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8), // Soft grey-blue background
      appBar: CommonWidget.gradientAppBar(
        title: "My Properties",
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer<MyPropertiesProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryBlue,
                strokeWidth: 2,
              ),
            );
          }

          if (provider.properties.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            itemCount: provider.properties.length,
            itemBuilder: (_, i) => _propertyTile(provider.properties[i]),
          );
        },
      ),
    );
  }

  Widget _propertyTile(dynamic p) {
    bool isActive = p.status.toLowerCase() == 'active';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailsScreen(propertyId: p.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // 1. TOP IMAGE SECTION
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: p.image == null
                      ? Container(
                          height: 160,
                          width: double.infinity,
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey.shade300,
                            size: 40,
                          ),
                        )
                      : Image.network(
                          p.image!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                // Glassmorphic Status Tag
                Positioned(
                  top: 12,
                  right: 12,
                  child: _glassBadge(
                    isActive ? "ACTIVE" : p.status.toUpperCase(),
                    isActive ? Colors.green : Colors.orange,
                  ),
                ),
                // Type Tag
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: _typeTag(p.propertyType),
                ),
              ],
            ),

            // 2. CONTENT SECTION
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          p.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Color(0xFF1A1C1E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.more_vert_rounded, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.layers_outlined, size: 14, color: primaryBlue),
                      const SizedBox(width: 4),
                      Text(
                        p.listingType,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 3. PROGRESS BAR SECTION
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: p.completionPercentage / 100,
                            minHeight: 8,
                            backgroundColor: primaryBlue.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${p.completionPercentage}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Profile Completion",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_home_work_outlined,
              size: 60,
              color: primaryBlue.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Properties Found",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Start by adding your first listing.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
