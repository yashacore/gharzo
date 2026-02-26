import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/api_constant/api_constant.dart';
import 'package:gharzo_project/data/advertisement_service/advertisment_service.dart';
import 'package:gharzo_project/model/advertisement/advertisment_model.dart';
import 'package:gharzo_project/model/category/category_model.dart';
import 'package:gharzo_project/model/home/home_model.dart';
import 'package:gharzo_project/model/property_model/property_model.dart';
import 'package:gharzo_project/data/db_service/db_service.dart';
import 'package:gharzo_project/providers/home_loan_enquiry_provider.dart';
import 'package:gharzo_project/providers/services_provider.dart';
import 'package:gharzo_project/screens/banquet/banquet_list_screen.dart';
import 'package:gharzo_project/screens/category/category_provider.dart';
import 'package:gharzo_project/screens/hotels/hotel_list_screen.dart';
import 'package:gharzo_project/screens/loan_screen/home_loan_enquiry_screen.dart';
import 'package:gharzo_project/screens/loan_screen/loan_screen.dart';
import 'package:gharzo_project/screens/projects/project_list_screen.dart';
import 'package:gharzo_project/screens/services/services_screen.dart';
import 'package:http/http.dart' as http;
import 'package:gharzo_project/screens/category/category_view.dart';
import 'package:gharzo_project/screens/login/login_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeProvider extends ChangeNotifier {
  // ================= UI STATE =================
  bool isLoading = false;
  bool isViewAll = false;

  final pageController = PageController();
  final ScrollController scrollController = ScrollController();

  List<AdvertisementModel> ads = [];
  int currentAdIndex = 0;

  void onAdPageChanged(int index) {
    currentAdIndex = index;
    notifyListeners();
  }
  // ================= CATEGORY DATA =================
  final List<CategoryModel> categories = [
    CategoryModel(
      icon: "assets/icons/rent.png",
      label: "Rent",
      // color: Colors.orange,
      type: "category",
    ),
    CategoryModel(
      icon: "assets/icons/hostel.png",
      label: "Hostels",
      // color: Colors.red,
      type: "hostels",
    ),
    CategoryModel(
      icon: "assets/icons/buy.png",
      label: "Buy",
      // color: Colors.blue,
      type: "buy",
    ),
    CategoryModel(
      icon: "assets/icons/pg.png",
      label: "PG",
      // color: Colors.indigo,
      type: "pg",
    ),
    CategoryModel(
      icon: "assets/icons/6.png",
      label: "Commercial",
      // color: Colors.blueGrey,
      type: "commercial",
    ),
    CategoryModel(
      icon: "assets/icons/banquet.png",
      label: "Banquets",
      // color: Colors.green,
      type: "banquets",
    ),
    CategoryModel(
      icon: "assets/icons/services.png",
      label: "Services",
      // color: Colors.purple,
      type: "villa",
    ),
    CategoryModel(
      icon: "assets/icons/loan.png",
      label: "Home Loan",
      // color: Colors.teal,
      type: "farm",
    ),
    CategoryModel(
      icon: "assets/icons/hotel.png",
      label: "Hotels",
      // color: Colors.brown,
      type: "hotel",
    ),
    CategoryModel(
      icon: "assets/icons/commercial.png",
      label: "Project",
      // color: Colors.cyan,
      type: "shops",
    ),
  ];

  Timer? _timer;

  Home() {
    print('save-token:::  Api Calling');
  }

  void toggleViewAll() {
    isViewAll = true; // Only allow expanding
    notifyListeners();
  }

  void resetView() {
    isViewAll = false;
    notifyListeners();
  }

  List<CategoryModel> get displayCategories =>
      isViewAll ? categories : categories.take(3).toList();

  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          (i + chunkSize > list.length) ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  /// ================= FETCH ADS =================
  Future<void> fetchHomeAds(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      debugPrint("📢 Fetching home ads...");

      final response = await AdvertisementApi.fetchHomepageAds();

      ads = response
          .map((e) => AdvertisementModel.fromJson(e))
          .where((ad) => ad.hasImage)
          .toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));

      debugPrint("✅ Ads loaded: ${ads.length}");

      /// 🔥 PRE-CACHE IMAGES (THIS FIXES SLOW LOADING)
      for (final ad in ads) {
        if (ad.imageUrl.isNotEmpty) {
          precacheImage(
            CachedNetworkImageProvider(ad.imageUrl),
            context,
          );
        }
      }
    } catch (e, stack) {
      debugPrint("❌ Error fetching ads: $e");
      debugPrint("$stack");
      ads = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  /// ================= PROPERTY API =================
  List<PropertyModel> featuredProperties = [];
  List<PropertyModel> trendingProperties = [];
  List<PropertyModel> recentProperties = [];

  Future<void> fetchProperties() async {
    try {
      isLoading = true;
      notifyListeners();

      final featuredResp = await http.get(
        Uri.parse(ApiConstant.featuredProperties),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      featuredProperties = (jsonDecode(featuredResp.body)['data'] as List)
          .map((e) => PropertyModel.fromJson(e))
          .toList();

      final trendingResp = await http.get(
        Uri.parse(ApiConstant.trendingProperties),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      trendingProperties = (jsonDecode(trendingResp.body)['data'] as List)
          .map((e) => PropertyModel.fromJson(e))
          .toList();

      final recentResp = await http.get(
        Uri.parse(ApiConstant.recentProperties),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      recentProperties = (jsonDecode(recentResp.body)['data'] as List)
          .map((e) => PropertyModel.fromJson(e))
          .toList();
    } catch (e) {
      print("Error fetching properties: $e");
      featuredProperties = [];
      trendingProperties = [];
      recentProperties = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= IMPRESSION / CLICK / CONVERSION =================
  void trackImpression(AdvertisementModel ad) =>
      AdvertisementApi.trackImpression(ad.id);

  Future<void> onAdTap(AdvertisementModel ad) async {
    AdvertisementApi.trackClick(ad.id);

    if (ad.clickAction.type == "external_url" &&
        ad.clickAction.url.isNotEmpty) {
      final uri = Uri.parse(ad.clickAction.url);
      await launchUrl(
        uri,
        mode: ad.clickAction.openInNewTab
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    }
  }

  void trackConversion(AdvertisementModel ad) =>
      AdvertisementApi.trackConversion(ad.id);

  void onCategoryTap(BuildContext context, String type) async {
    final loggedIn = await checkLogin(context);
    if (!loggedIn) return;

    if (type == "Services") {
      // 👉 Open Services Screen
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ServicesProvider(),
            child: const ServicesScreen(),
          ),
        ),
      );
    } else if (type == "Home Loan") {
      // 👉 Open Home Loan Enquiry Screen
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoanScreen()),
      );
    } else if (type == "Banquets") {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BanquetListScreen()),
      );
    } else if (type == "Hotels") {
      // 👉 Open Home Loan Enquiry Screen
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HotelListScreen()),
      );
    } else if (type == "Project") {
      // 👉 Open Home Loan Enquiry Screen
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProjectListScreen()),
      );
    } else {
      // 👉 Open Category Screen
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CategoryProvider(type),
            child: CategoryView(category: type),
          ),
        ),
      );
    }
  }

  Future<bool> checkLogin(BuildContext context) async {
    final token = await PrefService.getToken();
    if (token == null || token.isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
      return false;
    }
    return true;
  }

  HomeProvider() {
    _startAutoScroll();
    fetchProperties();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients && ads.isNotEmpty) {
        int nextPage = (pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= ads.length) nextPage = 0;

        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// ================= SAVE FCM TOKEN =================
  Future<void> saveToken() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        print("FCM token is null");
        return;
      }

      final token = await PrefService.getToken();

      final url = Uri.parse(
        'https://api.gharzoreality.com/api/auth/save-token',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"token": fcmToken, "device": "android"}),
      );

      if (response.statusCode == 200) {
        print("FCM Token saved successfully");
      } else {
        print("Failed to save token: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error saving token: $e");
    }
  }

  Future<void> fetchPublicProperties() async {
    debugPrint("🟡 fetchPublicProperties() START");

    isLoading = true;
    notifyListeners();

    try {
      final url = "https://api.gharzoreality.com/api/public/properties";
      debugPrint("🌐 API URL => $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint("📡 Status Code => ${response.statusCode}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final List data = decoded['data'] ?? [];
        debugPrint("📦 Total properties received => ${data.length}");

        _allProperties = data
            .map((e) => PropertyModel.fromJson(e))
            .toList();

        debugPrint("✅ Parsed properties => ${_allProperties.length}");

        // 🔍 DEBUG: recent (last 24h)
        final recent = _allProperties.where((p) {
          if (p.createdAt == null) return false;
          return DateTime.now()
              .toUtc()
              .difference(p.createdAt!.toUtc())
              .inHours <=
              24;
        }).toList();

        debugPrint("🆕 Properties uploaded in last 24h => ${recent.length}");

        if (recent.isNotEmpty) {
          debugPrint(
            "🕒 Latest property time => ${recent.first.createdAt}",
          );
        }
      } else {
        debugPrint(
          '❌ API Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e, stack) {
      debugPrint('❌ fetchPublicProperties error: $e');
      debugPrint('📛 StackTrace: $stack');
    }

    isLoading = false;
    notifyListeners();

    debugPrint("🟢 fetchPublicProperties() END");
  }
  List<PropertyModel> get recentProperty {
    final now = DateTime.now().toUtc();

    return _allProperties.where((property) {
      if (property.createdAt == null) return false;

      // ✅ NO parsing needed
      final diff = now.difference(property.createdAt!.toUtc());

      return diff.inHours <= 48;
    }).toList();
  }

  List<PropertyModel> get allProperties => _allProperties;
  List<PropertyModel> _allProperties = [];
}
