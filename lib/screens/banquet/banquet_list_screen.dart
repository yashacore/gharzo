import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/banquet/banquet_details_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/banquet_provider.dart';

class BanquetListScreen extends StatefulWidget {
  const BanquetListScreen({super.key});

  @override
  State<BanquetListScreen> createState() => _BanquetListScreenState();
}

class _BanquetListScreenState extends State<BanquetListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<BanquetProvider>().fetchBanquets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: CommonWidget.gradientAppBar(
        title: "Banquet Halls",
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      body: Consumer<BanquetProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.banquets.length,
            itemBuilder: (context, index) {
              final banquet = provider.banquets[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BanquetDetailsScreen(banquet: banquet),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// IMAGE SECTION
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18)),
                            child: Image.network(
                              banquet.imageUrl.isNotEmpty
                                  ? banquet.imageUrl
                                  : "https://via.placeholder.com/400",
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// GRADIENT
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(18)),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.55),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// PRICE TAG
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "₹${banquet.minPrice} - ₹${banquet.maxPrice}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
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
                            Text(
                              banquet.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "${banquet.city}, ${banquet.state}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                _infoChip(
                                  icon: Icons.event_seat,
                                  text:
                                  "${banquet.seating} Seating",
                                ),
                                const SizedBox(width: 10),
                                _infoChip(
                                  icon: Icons.people,
                                  text:
                                  "${banquet.floating} Floating",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
