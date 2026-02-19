import 'package:flutter/material.dart';
import 'package:gharzo_project/model/model/property_wishlist_model.dart';
import 'package:gharzo_project/providers/saved_property_provider.dart';
import 'package:gharzo_project/screens/property_details/property_details_provider.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';

class SavedPropertiesScreen extends StatelessWidget {
  const SavedPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavedPropertyProvider()..fetchSavedProperties(),
      child: Builder( // 🔥 IMPORTANT
        builder: (providerContext) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F6FA),
            appBar: AppBar(
              title: const Text("Saved Properties"),
              backgroundColor:AppThemeColors().primary,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: providerContext,
                      builder: (_) => AlertDialog(
                        title: const Text("Clear all saved?"),
                        content: const Text(
                          "This will remove all saved properties permanently.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Clear"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      debugPrint("🗑️ User confirmed clear all");

                      // ✅ NOW THIS WORKS
                      providerContext
                          .read<SavedPropertyProvider>()
                          .clearAllSaved(
                        note: "Cleared from saved screen",
                      );
                    }
                  },
                ),
              ],
            ),
            body: Consumer<SavedPropertyProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading &&
                    provider.properties.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (provider.properties.isEmpty) {
                  return const Center(
                      child: Text("No saved properties"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.properties.length,
                  itemBuilder: (_, index) {
                    final p = provider.properties[index];
                    return _SavedPropertyCard(p);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
class _SavedPropertyCard extends StatelessWidget {
  final SavedPropertyModel p;
  const _SavedPropertyCard(this.p);

  @override
  Widget build(BuildContext context) {
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
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              p.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(height: 180, color: Colors.grey.shade200),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${p.locality}, ${p.city}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹${p.price} ${p.pricePer}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (p.note != null && p.note!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    "📝 ${p.note}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
