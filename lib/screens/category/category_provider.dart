import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gharzo_project/common/http/http_method.dart';
import 'package:gharzo_project/data/advertisement_service/advertisment_service.dart';
import 'package:gharzo_project/model/advertisement/advertisment_model.dart';
import 'package:gharzo_project/model/property_model/property_model.dart';
import 'package:url_launcher/url_launcher.dart';


class CategoryProvider with ChangeNotifier {
  String selectedCategory = 'Rent';


  List<AdvertisementModel> ads = [];

  List<String> categories = [
    'Rent',
    'Buy',
    'Hostels',
    'PG',
    'Commercial',
    'Banquets'
  ];
  bool isLoading = false;
  List<PropertyModel> properties = [];

  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<String> images = [
    "assets/category/rent_image1.png",
    "assets/category/rent_image2.png",
    "assets/category/rent_image3.png",
  ];

  CategoryProvider(this.selectedCategory) {
    print('selectedCategory:::  $selectedCategory');
    startAutoSlide();
    setCategory(selectedCategory);
  }



  /// ================= FETCH ADS =================
  Future<void> fetchAds() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await AdvertisementApi.fetchHomepageAds();

      ads = (response ?? [])
          .map((e) => AdvertisementModel.fromJson(e))
          .where((ad) => ad.hasImage) // ✅ Only keep ads with images
          .toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));

      // Debug: print all ad image URLs
      for (var ad in ads) {
        print("Loaded Ad: ${ad.title} => ${ad.imageUrl}");
      }
    } catch (e) {
      print("Error fetching ads: $e");
      ads = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= IMPRESSION =================
  void trackImpression(AdvertisementModel ad) {
    AdvertisementApi.trackImpression(ad.id);
  }

  /// ================= CLICK =================
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

  /// ================= CONVERSION =================
  void trackConversion(AdvertisementModel ad) {
    AdvertisementApi.trackConversion(ad.id);
  }


  Future<void> setCategory(String category) async {
    selectedCategory = category;
    await fetchProperties();
  }

  Future<void> fetchProperties() async {
    isLoading = true;
    notifyListeners();

    try {
      properties = (await AuthService.getPropertiesByCategory(selectedCategory)).cast<PropertyModel>();
    } catch (e) {
      properties = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void startAutoSlide() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!pageController.hasClients) return;

      currentIndex = (currentIndex + 1) % images.length;

      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOutCubic,
      );

      notifyListeners();
    });
  }

  Future<void> preloadAssets(BuildContext context) async {
    for (final img in images) {
      await precacheImage(AssetImage(img), context);
    }
  }
}
