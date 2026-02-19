import 'package:flutter/material.dart';
import 'package:gharzo_project/common/common_widget/common_home_widget/common_home_widget.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/screens/category/category_provider.dart';
import 'package:gharzo_project/screens/property_details/property_details.dart';
import 'package:gharzo_project/screens/property_details/property_details_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/theme/colors.dart';


// child: Container(
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(12),
//     border: Border.all(
//         color: Colors.grey.shade200),
//   ),
//   child: Column(
//     crossAxisAlignment:
//     CrossAxisAlignment.start,
//     children: [
//       Expanded(
//         child: ClipRRect(
//           borderRadius: const BorderRadius
//               .vertical(
//               top: Radius.circular(12)),
//           child: Image.network(
//             property.imageUrl,
//             width: double.infinity,
//             fit: BoxFit.cover,
//             errorBuilder:
//                 (_, __, ___) => SizedBox(
//               width: double.infinity,
//               child: const Icon(
//                 Icons
//                     .image_not_supported,
//                 color: Colors.red,
//                 size: 30,
//               ),
//             ),
//             loadingBuilder:
//                 (BuildContext context,
//                 Widget child,
//                 ImageChunkEvent?
//                 loadingProgress) {
//               if (loadingProgress == null)
//                 return child;
//               return Center(
//                 child:
//                 CircularProgressIndicator(
//                   value: loadingProgress
//                       .expectedTotalBytes !=
//                       null
//                       ? loadingProgress
//                       .cumulativeBytesLoaded /
//                       loadingProgress
//                           .expectedTotalBytes!
//                       : null,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment:
//           CrossAxisAlignment.start,
//           children: [
//             Text(
//               property.title,
//               maxLines: 1,
//               overflow:
//               TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               property.location,
//               style: const TextStyle(
//                   fontSize: 12),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               property.price,
//               style: const TextStyle(
//                 color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),




class CategoryView extends StatefulWidget {
  final String category;
  const CategoryView({super.key, required this.category});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<CategoryProvider>();
      provider.setCategory(widget.category);
      provider.startAutoSlide();
      // provider.preloadAssets(context);
      context.read<CategoryProvider>().fetchAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body:
          Column(
            children: [
              // Gradient Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppThemeColors().backgroundLeft,
                      AppThemeColors().backgroundRight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        iconSize: 26,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonHomeWidgets.searchBarView(),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),

                        // Category list (horizontal)
                        CommonWidget.categoryListView(provider),
                        SizedBox(height: 16),

                        // "Get Started" text
                        Text(
                          "Get Started",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        buildAdSlider(provider),
                        SizedBox(height: 16),
                        CommonHomeWidgets.commonColumn(
                          title: "All ${provider.selectedCategory}",
                          child: Builder(
                            builder: (context) {
                              if (provider.isLoading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (provider.properties.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                      child: Text("No properties found")),
                                );
                              }

                              return GridView.builder(


                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.properties.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.60,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemBuilder: (context, index) {
                                  final property = provider.properties[index];

                                  return GestureDetector(
                                    onTap: (){
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
                                          ));
                                    },
                                    child: PropertyCard(
                                      // IMAGE
                                      imgUrl: property.imageUrl,

                                      // BASIC
                                      price: property.formattedPrice, // "₹120"
                                      title: property.title,
                                      location: property.fullLocation,
                                      postedText: "POSTED",

                                      // PROPERTY INFO
                                      bhk: property.bhk,
                                      bathrooms: property.bathrooms,
                                      area: property.areaText, // "850 sqft"
                                      furnishing: property.furnishing,

                                      // FLAGS
                                      isVerified: property.isVerified,
                                      isFeatured: property.isFeatured,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= AD SLIDER =================
  Widget buildAdSlider(CategoryProvider provider) {
    if (provider.isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.ads.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: provider.pageController,
        itemCount: provider.ads.length,
        onPageChanged: (index) => provider.trackImpression(provider.ads[index]),
        itemBuilder: (context, index) {
          final ad = provider.ads[index];
          return GestureDetector(
            onTap: () => provider.onAdTap(ad),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          ad.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.broken_image)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (ad.title.isNotEmpty)
                                Text(
                                  ad.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () => provider.onAdTap(ad),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 0.5),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Explore Now",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 10,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}





class PropertyCard extends StatelessWidget {
  final String price;
  final String title;
  final String location;
  final String postedText;
  final String imgUrl;

  final int bhk;
  final int bathrooms;
  final String area;
  final String furnishing;
  final bool isVerified;
  final bool isFeatured;

  const PropertyCard({
    super.key,
    required this.price,
    required this.title,
    required this.location,
    required this.postedText,
    required this.imgUrl,
    required this.bhk,
    required this.bathrooms,
    required this.area,
    required this.furnishing,
    required this.isVerified,
    required this.isFeatured,
  });

  bool get hasImage =>
      imgUrl.isNotEmpty && imgUrl.startsWith('http');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.10),
        //     blurRadius: 24,
        //     offset: const Offset(0, 12),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max, // IMPORTANT
        children: [
          // ================= IMAGE =================
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.15,
                  child: hasImage
                      ? Image.network(imgUrl, fit: BoxFit.cover)
                      : Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.home_work_rounded,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.75),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isFeatured
                          ? Colors.amber
                          : isVerified
                          ? Colors.green
                          : Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isFeatured
                          ? "FEATURED"
                          : isVerified
                          ? "VERIFIED"
                          : postedText,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                // Price
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= CONTENT =================
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ================= PROPERTY INFO (WRAP FIX) =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _chip(Icons.bed_outlined, "$bhk BHK"),
                _chip(Icons.bathtub_outlined, "$bathrooms Bath"),
                _chip(Icons.square_foot_outlined, area),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              furnishing,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Spacer(), // PUSH CTA TO BOTTOM

          // ================= CTA =================
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

}
