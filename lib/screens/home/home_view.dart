import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gharzo_project/common/common_widget/common_home_widget/common_home_widget.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/model/property_model/property_model.dart';
import 'package:gharzo_project/providers/search_provider.dart';
import 'package:gharzo_project/screens/home/home_provider.dart';
import 'package:gharzo_project/screens/home/search_screen.dart';
import 'package:provider/provider.dart';


class HomeView extends StatefulWidget {
  final VoidCallback action;
  const HomeView({super.key, required this.action});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    // Force WHITE status bar text/icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,

        // ANDROID → white icons
        statusBarIconBrightness: Brightness.light,

        // iOS → white text
        statusBarBrightness: Brightness.dark,
      ),
    );

    Future.microtask(() {
      context.read<HomeProvider>().fetchHomeAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return CommonWidget.commonGradientScaffold(


          isScrollable: false,
          body: SafeArea(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
             Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CommonHomeWidgets.headerView(
                    onMenuTap: widget.action,
                    context: context,
                  ),
                ),
                SizedBox(height: 6),
                Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CommonHomeWidgets.searchBarView(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => PropertySearchProvider(),
                                child: const PropertySearchScreen(

                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    ),

                    SizedBox(height: 16),
                    buildAdSlider(provider),
                    SizedBox(height: 16),
                    listOfCategory(provider),
                    SizedBox(height: 24),
                    buildFeaturedProperties(provider),
                    SizedBox(height: 24),

                    buildTrendingProperties(provider),
                    SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= AD SLIDER =================
  Widget buildAdSlider(HomeProvider provider) {
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
        onPageChanged: (index) =>
            provider.trackImpression(provider.ads[index]),
        itemBuilder: (context, index) {
          final ad = provider.ads[index];

          return GestureDetector(
            onTap: () => provider.onAdTap(ad),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
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

                          /// 🔹 Explore Button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listOfCategory(HomeProvider provider) {

    // Split categories into 2 rows
    int halfLength = (provider.categories.length / 2).ceil();

    List firstRow = provider.categories.take(halfLength).toList();
    List secondRow = provider.categories.skip(halfLength).toList();

    return CommonHomeWidgets.commonColumn(
      title: "Get Started with",
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// -------- First Row --------
            Row(
              children: firstRow.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 12),
                  child: SizedBox(
                    width: 74,
                    height: 80,
                    child: GestureDetector(
                      onTap: () =>
                          provider.onCategoryTap(context, item.label),
                      child: CommonHomeWidgets.categoryCardView(
                        icon: item.icon,
                        label: item.label,
                        color: item.color,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            /// -------- Second Row --------
            Row(
              children: secondRow.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 74,
                    height: 80,
                    child: GestureDetector(
                      onTap: () =>
                          provider.onCategoryTap(context, item.label),
                      child: CommonHomeWidgets.categoryCardView(
                        icon: item.icon,
                        label: item.label,
                        color: item.color,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeaturedProperties(HomeProvider provider) {
    if (provider.featuredProperties.isEmpty) {
      return const SizedBox.shrink();
    }

    return CommonHomeWidgets.commonColumn(
      title: "Featured Properties",
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: provider.featuredProperties.length,
          itemBuilder: (context, index) {
            final property = provider.featuredProperties[index];

            return Container(
              width: 200,
              // margin: const EdgeInsets.only(right: 2),
              child: _propertyCard(property, provider),
            );
          },
        ),
      ),
    );
  }

  Widget buildTrendingProperties(HomeProvider provider) {
    if (provider.trendingProperties.isEmpty) {
      return const SizedBox.shrink();
    }

    return CommonHomeWidgets.commonColumn(
      title: "Trending Properties",
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.trendingProperties.length,
          itemBuilder: (context, index) {
            final property = provider.trendingProperties[index];

            return Container(
              width: 200,
              // margin: const EdgeInsets.only(right: 14),
              child: _propertyCard(property, provider, showLikeLeft: true),
            );
          },
        ),
      ),
    );
  }
  Widget _propertyCard(
      PropertyModel property,
      HomeProvider provider, {
        bool showLikeLeft = false,
      }) {

    return GestureDetector(
      onTap: () {
        // Add navigation or details logic here
      },
      child:
      Container(
        margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18), // 👈 All corners circular
          child: Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [

                /// 🔹 Image (Full Rounded)
                Positioned.fill(
                  child: Image.network(
                    property.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image)),
                  ),
                ),

                /// 🔹 Gradient
                Positioned.fill(
                  child: Container(
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
                ),

                /// 🔹 Like Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        property.price ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}