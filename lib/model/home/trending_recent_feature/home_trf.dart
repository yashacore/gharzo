

import 'package:gharzo_project/model/advertisement/advertisment_model.dart';
import 'package:gharzo_project/model/property_model/property_model.dart';

class HomeModel {
  final List<AdvertisementModel> ads;
  final List<PropertyModel> featured;
  final List<PropertyModel> trending;
  final List<PropertyModel> recent;

  HomeModel({
    required this.ads,
    required this.featured,
    required this.trending,
    required this.recent,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      ads: (json['ads'] as List?)
          ?.map((e) => AdvertisementModel.fromJson(e))
          .toList() ??
          [],
      featured: (json['featured'] as List?)
          ?.map((e) => PropertyModel.fromJson(e))
          .toList() ??
          [],
      trending: (json['trending'] as List?)
          ?.map((e) => PropertyModel.fromJson(e))
          .toList() ??
          [],
      recent: (json['recent'] as List?)
          ?.map((e) => PropertyModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}
