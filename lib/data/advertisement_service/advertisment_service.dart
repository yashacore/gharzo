import 'dart:convert';
import 'package:http/http.dart' as http;

class AdvertisementApi {
  static const String baseUrl =
      "https://api.gharzoreality.com/api/v2/advertisements/public";

  static Future<List<dynamic>> fetchHomepageAds() async {
    final response = await http.get(
      Uri.parse("$baseUrl/placement/homepage_hero"),
    );

    final body = jsonDecode(response.body);
    return body['data'] ?? [];
  }

  static Future<void> trackImpression(String adId) async {
    await http.post(
      Uri.parse("$baseUrl/$adId/impression"),
    );
  }

  static Future<void> trackClick(String adId) async {
    await http.post(
      Uri.parse("$baseUrl/$adId/click"),
    );
  }

  static Future<void> trackConversion(String adId) async {
    await http.post(
      Uri.parse("$baseUrl/$adId/conversion"),
    );
  }
}
