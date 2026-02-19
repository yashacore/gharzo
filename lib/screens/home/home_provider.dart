import 'dart:async';
import 'dart:convert';
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

  // ================= CATEGORY DATA =================
  final List<CategoryModel> categories = [
    CategoryModel(icon: Icons.apartment, label: "Rent", color: Colors.orange, type: "category"),
    CategoryModel(icon: Icons.home, label: "Hostels", color: Colors.red, type: "hostels"),
    CategoryModel(icon: Icons.shopping_bag, label: "Buy", color: Colors.blue, type: "buy"),
    CategoryModel(icon: Icons.people, label: "PG", color: Colors.indigo, type: "pg"),
    CategoryModel(icon: Icons.business, label: "Commercial", color: Colors.blueGrey, type: "commercial"),
    CategoryModel(icon: Icons.celebration, label: "Banquets", color: Colors.green, type: "banquets"),
    CategoryModel(icon: Icons.design_services, label: "Services", color: Colors.purple, type: "villa"),
    CategoryModel(icon: Icons.home, label: "Home Loan", color: Colors.teal, type: "farm"),
    CategoryModel(icon: Icons.hotel, label: "Hotels", color: Colors.brown, type: "hotel"),
    CategoryModel(icon: Icons.add_to_photos_outlined, label: "Project", color: Colors.cyan, type: "shops"),
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
        list.sublist(i, (i + chunkSize > list.length) ? list.length : i + chunkSize),
      );
    }
    return chunks;
  }

  /// ================= FETCH ADS =================
  Future<void> fetchHomeAds() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await AdvertisementApi.fetchHomepageAds();
      ads = (response ?? [])
          .map((e) => AdvertisementModel.fromJson(e))
          .where((ad) => ad.hasImage)
          .toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));
    } catch (e) {
      print("Error fetching ads: $e");
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
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      );

      featuredProperties = (jsonDecode(featuredResp.body)['data'] as List)
          .map((e) => PropertyModel.fromJson(e))
          .toList();

      final trendingResp = await http.get(
        Uri.parse(ApiConstant.trendingProperties),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      );

      trendingProperties = (jsonDecode(trendingResp.body)['data'] as List)
          .map((e) => PropertyModel.fromJson(e))
          .toList();

      final recentResp = await http.get(
        Uri.parse(ApiConstant.recentProperties),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
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

  /// ================= CATEGORY TAP =================
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
    }
    else if (type == "Home Loan") {
      // 👉 Open Home Loan Enquiry Screen
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoanScreen(),
          ),

      );
    }
    else if (type == "Banquets") {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const BanquetListScreen(),
          ),

      );
    }
    else if (type == "Hotels") {
      // 👉 Open Home Loan Enquiry Screen
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const HotelListScreen(),
          ),

      );
    }
    else {
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
          'https://api.gharzoreality.com/api/auth/save-token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "token": fcmToken,
          "device": "android",
        }),
      );

      if (response.statusCode == 200) {
        print("Token saved successfully");
      } else {
        print(
            "Failed to save token: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Error saving token: $e");
    }
  }
}
