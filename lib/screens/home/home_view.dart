import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gharzo_project/common/common_widget/common_home_widget/common_home_widget.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/providers/search_provider.dart';
import 'package:gharzo_project/screens/bottom_bar/bottom_bar_provider.dart';
import 'package:gharzo_project/screens/home/curosal_slider_helper.dart';
import 'package:gharzo_project/screens/home/home_provider.dart';
import 'package:gharzo_project/screens/home/landlord_card_helper.dart';
import 'package:gharzo_project/screens/home/property_card_helper.dart';
import 'package:gharzo_project/screens/home/search_screen.dart';
import 'package:gharzo_project/screens/home/trending_properties_helper.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      provider.fetchPublicProperties();
    });
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
      context.read<HomeProvider>().fetchHomeAds(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🧠 BUILD ROLE => $role");
    debugPrint("🧪 RAW ROLE => [$role]");
    debugPrint("🧪 CLEAN ROLE => [${role?.replaceAll('"', '').trim()}]");

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Stack(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
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
              top: true,
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CommonHomeWidgets.headerView(
                      userName: FutureBuilder(
                        future: PrefService.getUser(),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) return const SizedBox();
                          return Text(snapshot.data!['name']); // ✅ updated name
                        },
                      ),
                      onMenuTap: widget.action,
                      context: context,
                    ),
                  ),

                  const SizedBox(height: 20),

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

                  const HomeAdSlider(),

                  const SizedBox(height: 16),

                  Consumer<HomeProvider>(
                    builder: (_, provider, __) {
                      return listOfCategory(provider);
                    },
                  ),

                  const SizedBox(height: 12),
                  Consumer<HomeProvider>(
                    builder: (_, provider, __) {
                      return buildTrendingProperties(provider);
                    },
                  ),
                  const SizedBox(height: 12),

                  Consumer<HomeProvider>(
                    builder: (_, provider, __) {
                      return buildFeaturedProperties(provider);
                    },
                  ),

                  const SizedBox(height: 24),

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
                        const SizedBox(height: 12),
                        LandlordCardHelper(),
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

  Widget buildTrendingProperties(HomeProvider provider) {
    if (provider.trendingProperties.isEmpty) {
      return const SizedBox.shrink();
    }

    return CommonHomeWidgets.commonColumn(
      title: "Trending Properties",
      child: SizedBox(
        height: 250,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true, // ✅ KEY FIX
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: provider.trendingProperties.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 240,
                child: TrendingPropertyCard(
                  provider: provider,
                  property: provider.trendingProperties[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget listOfCategory(HomeProvider provider) {
    int halfLength = (provider.categories.length / 2).ceil();

    final firstRow = provider.categories.take(halfLength).toList();
    final secondRow = provider.categories.skip(halfLength).toList();

    final double cardWidth = MediaQuery.of(context).size.width / 4.0;

    return CommonHomeWidgets.commonColumn(
      title: "Get Started with",
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- FIRST ROW ----------
            Row(
              children: firstRow.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 12),
                  child: SizedBox(
                    width: cardWidth,
                    child: GestureDetector(
                      onTap: () => provider.onCategoryTap(context, item.label),
                      child: CommonHomeWidgets.categoryCardView(
                        assetPath: item.icon,
                        label: item.label,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            /// ---------- SECOND ROW ----------
            Row(
              children: secondRow.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 12),
                  child: SizedBox(
                    width: cardWidth,
                    child: GestureDetector(
                      onTap: () => provider.onCategoryTap(context, item.label),
                      child: CommonHomeWidgets.categoryCardView(
                        assetPath: item.icon,
                        label: item.label,
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
    final recentProperties = provider.recentProperty;

    if (recentProperties.isEmpty) {
      return const SizedBox.shrink();
    }

    return CommonHomeWidgets.commonColumn(
      title: "New Properties (Last 24 Hours)",
      child: SizedBox(
        height: 340,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: recentProperties.length,
          itemBuilder: (context, index) {
            final property = recentProperties[index];

            return SizedBox(
              // width: 200,
              child: PropertyCardHelper(
                property: provider.trendingProperties[index],
                provider: provider,
              ),
            );
          },
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
