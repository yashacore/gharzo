import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gharzo_project/common/common_widget/common_home_widget/common_home_widget.dart';
import 'package:gharzo_project/common/common_widget/common_widget.dart';
import 'package:gharzo_project/common/common_widget/network_image_helper.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/model/property_model/property_model.dart';
import 'package:gharzo_project/providers/search_provider.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar_provider.dart';
import 'package:gharzo_project/screens/home/home_provider.dart';
import 'package:gharzo_project/screens/home/search_screen.dart';
import 'package:gharzo_project/screens/landloard/sub_owner/create_sub_owner_screen.dart';
import 'package:gharzo_project/screens/landloard/create_tenant/create_tenancy_screen.dart';
import 'package:gharzo_project/screens/landloard/landlord_dashboard.dart';
import 'package:gharzo_project/screens/landloard/landlord_properties/landlord_my_properties.dart';
import 'package:gharzo_project/utils/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class HomeView extends StatefulWidget {
  final VoidCallback action;

  const HomeView({super.key, required this.action});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? role;

  late bool isLandlord =
      (role ?? "")
          .replaceAll('"', '') // 🔥 REMOVE QUOTES
          .trim()
          .toLowerCase() ==
      "landlord";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    role = PrefService.getRoleSync();

    debugPrint("🟡 INIT STATE ROLE => $role");

    debugPrint("🟢 HomeView initState");

    _scrollController.addListener(() {
      debugPrint("📜 Scroll listener fired");

      if (!_scrollController.hasClients) {
        debugPrint("❌ No scroll clients attached");
        return;
      }

      final position = _scrollController.position;
      debugPrint(
        "📏 pixels=${position.pixels}, "
        "max=${position.maxScrollExtent}, "
        "direction=${position.userScrollDirection}",
      );

      final bottomBar = context.read<BottomBarProvider>();

      if (position.userScrollDirection == ScrollDirection.reverse) {
        debugPrint("🔽 SCROLLING DOWN → HIDE BOTTOM BAR");
        bottomBar.setBottomBarVisibility(false);
      } else if (position.userScrollDirection == ScrollDirection.forward) {
        debugPrint("🔼 SCROLLING UP → SHOW BOTTOM BAR");
        bottomBar.setBottomBarVisibility(true);
      }
    });

    SmsAutoFill().getAppSignature.then((signature) {
      debugPrint("🔑 OTP HASH: $signature");
    });

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    Future.microtask(() {
      context.read<HomeProvider>().fetchHomeAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🧠 BUILD ROLE => $role");

    debugPrint("🧪 RAW ROLE => [$role]");
    debugPrint("🧪 CLEAN ROLE => [${role?.replaceAll('"', '').trim()}]");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController, // ✅ ONLY ONE SCROLL
        child: Stack(
          children: [
            // 🔵 GRADIENT HEADER
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppThemeColors().backgroundLeft,
                    AppThemeColors().backgroundRight,
                  ],
                ),
              ),
            ),

            // 🔵 MAIN CONTENT
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CommonHomeWidgets.headerView(
                      onMenuTap: widget.action,
                      context: context,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CommonHomeWidgets.searchBarView(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => PropertySearchProvider(),
                              child: const PropertySearchScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  Consumer<HomeProvider>(
                    builder: (_, provider, __) {
                      return buildAdSlider(provider);
                    },
                  ),                  const SizedBox(height: 16),
                  listOfCategory(context.read<HomeProvider>()),
                  const SizedBox(height: 24),
                  buildFeaturedProperties(context.read<HomeProvider>()),
                  const SizedBox(height: 24),
                  buildTrendingProperties(context.read<HomeProvider>()),
                  const SizedBox(height: 24),

                  // ✅ LANDLORD SECTION (NOW IT WILL SHOW)
                  if (isLandlord)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Landlord Dashboard",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // _buildQuickActions(),
                        stylishLandlordCard(context),
                        const SizedBox(height: 12),

                        const SizedBox(height: 40),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        onPageChanged: (index) => provider.trackImpression(provider.ads[index]),
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
                    SafeNetworkImage(
                      debugLabel: "Ad slider",
                      imageUrl: ad.imageUrl,
                      fit: BoxFit.cover,
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
                      onTap: () => provider.onCategoryTap(context, item.label),
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
                      onTap: () => provider.onCategoryTap(context, item.label),
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

  Widget stylishLandlordCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LandlordDashboard()),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade50, width: 1),
            ),
            child: Row(
              children: [
                // Icon Container with soft background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.vignette_rounded,
                    color: Colors.blue.shade700,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                // Text Content
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Landlord Portal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '8 active properties',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Minimalist Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
              ],
            ),
          ),
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
      child: Container(
        margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18), // 👈 All corners circular
          child: Container(
            height: 100,
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                /// 🔹 Image (Full Rounded)
                Positioned.fill(
                  child: SafeNetworkImage(
                    debugLabel: " > PropertyCar",

                    imageUrl: property.imageUrl,
                    fit: BoxFit.cover,
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
                        property.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        // ignore: dead_code
                        property.formattedPrice ?? '',
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

  String? getPropertyImage(dynamic property) {
    final images = property['images'];

    if (images is List && images.isNotEmpty) {
      final url = images.first['url'];
      if (url != null && url.toString().trim().isNotEmpty) {
        return url.toString();
      }
    }

    return null;
  }
}
