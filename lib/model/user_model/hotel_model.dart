

class HotelModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String propertyType;
  final LocationModel location;
  final ContactInfoModel contactInfo;
  final int totalRooms;
  final List<RoomTypeModel> roomTypes;
  final PriceRangeModel priceRange;
  final AmenitiesModel amenities;
  final PoliciesModel policies;
  final List<ImageModel> images;
  final List<NearbyPlaceModel> nearbyPlaces;
  final bool isFeatured;
  final bool isVerified;
  final bool isPremium;
  final RatingModel ratings;
  final StatsModel stats;
  final String status;
  final String slug;

  HotelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.propertyType,
    required this.location,
    required this.contactInfo,
    required this.totalRooms,
    required this.roomTypes,
    required this.priceRange,
    required this.amenities,
    required this.policies,
    required this.images,
    required this.nearbyPlaces,
    required this.isFeatured,
    required this.isVerified,
    required this.isPremium,
    required this.ratings,
    required this.stats,
    required this.status,
    required this.slug,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      propertyType: json['propertyType'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      contactInfo: ContactInfoModel.fromJson(json['contactInfo'] ?? {}),
      totalRooms: json['totalRooms'] ?? 0,
      roomTypes: (json['roomTypes'] as List? ?? [])
          .map((e) => RoomTypeModel.fromJson(e))
          .toList(),
      priceRange: PriceRangeModel.fromJson(json['priceRange'] ?? {}),
      amenities: AmenitiesModel.fromJson(json['amenities'] ?? {}),
      policies: PoliciesModel.fromJson(json['policies'] ?? {}),
      images: (json['images'] as List? ?? [])
          .map((e) => ImageModel.fromJson(e))
          .toList(),
      nearbyPlaces: (json['nearbyPlaces'] as List? ?? [])
          .map((e) => NearbyPlaceModel.fromJson(e))
          .toList(),
      isFeatured: json['isFeatured'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isPremium: json['isPremium'] ?? false,
      ratings: RatingModel.fromJson(json['ratings'] ?? {}),
      stats: StatsModel.fromJson(json['stats'] ?? {}),
      status: json['status'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
class LocationModel {
  final String address;
  final String city;
  final String locality;
  final String landmark;
  final String pincode;
  final String state;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.address,
    required this.city,
    required this.locality,
    required this.landmark,
    required this.pincode,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      locality: json['locality'] ?? '',
      landmark: json['landmark'] ?? '',
      pincode: json['pincode'] ?? '',
      state: json['state'] ?? '',
      latitude:
      (json['coordinates']?['latitude'] ?? 0).toDouble(),
      longitude:
      (json['coordinates']?['longitude'] ?? 0).toDouble(),
    );
  }
}
class ContactInfoModel {
  final String phone;
  final String alternatePhone;
  final String email;
  final String website;
  final String whatsapp;

  ContactInfoModel({
    required this.phone,
    required this.alternatePhone,
    required this.email,
    required this.website,
    required this.whatsapp,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      phone: json['phone'] ?? '',
      alternatePhone: json['alternatePhone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
    );
  }
}
class PriceRangeModel {
  final int min;
  final int max;
  final String currency;

  PriceRangeModel({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory PriceRangeModel.fromJson(Map<String, dynamic> json) {
    return PriceRangeModel(
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
      currency: json['currency'] ?? 'INR',
    );
  }
}
class RoomTypeModel {
  final String type;
  final int count;
  final int maxOccupancy;
  final String bedType;
  final int basePrice;

  RoomTypeModel({
    required this.type,
    required this.count,
    required this.maxOccupancy,
    required this.bedType,
    required this.basePrice,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    return RoomTypeModel(
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
      maxOccupancy: json['maxOccupancy'] ?? 0,
      bedType: json['bedType'] ?? '',
      basePrice: json['price']?['basePrice'] ?? 0,
    );
  }
}
class AmenitiesModel {
  final List<String> basic;
  final List<String> dining;
  final List<String> recreation;
  final List<String> business;
  final List<String> safety;
  final List<String> services;

  AmenitiesModel({
    required this.basic,
    required this.dining,
    required this.recreation,
    required this.business,
    required this.safety,
    required this.services,
  });

  factory AmenitiesModel.fromJson(Map<String, dynamic> json) {
    return AmenitiesModel(
      basic: List<String>.from(json['basic'] ?? []),
      dining: List<String>.from(json['dining'] ?? []),
      recreation: List<String>.from(json['recreation'] ?? []),
      business: List<String>.from(json['business'] ?? []),
      safety: List<String>.from(json['safety'] ?? []),
      services: List<String>.from(json['services'] ?? []),
    );
  }
}
class PoliciesModel {
  final String checkIn;
  final String checkOut;
  final String cancellation;
  final bool petsAllowed;
  final bool smokingAllowed;

  PoliciesModel({
    required this.checkIn,
    required this.checkOut,
    required this.cancellation,
    required this.petsAllowed,
    required this.smokingAllowed,
  });

  factory PoliciesModel.fromJson(Map<String, dynamic> json) {
    return PoliciesModel(
      checkIn: json['checkIn'] ?? '',
      checkOut: json['checkOut'] ?? '',
      cancellation: json['cancellation'] ?? '',
      petsAllowed: json['petsAllowed'] ?? false,
      smokingAllowed: json['smokingAllowed'] ?? false,
    );
  }
}
class ImageModel {
  final String url;
  final String category;

  ImageModel({
    required this.url,
    required this.category,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['url'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
class NearbyPlaceModel {
  final String name;
  final String type;
  final String distance;

  NearbyPlaceModel({
    required this.name,
    required this.type,
    required this.distance,
  });

  factory NearbyPlaceModel.fromJson(Map<String, dynamic> json) {
    return NearbyPlaceModel(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      distance: json['distance'] ?? '',
    );
  }
}
class RatingModel {
  final double average;
  final int count;

  RatingModel({
    required this.average,
    required this.count,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }
}
class StatsModel {
  final int views;
  final int enquiries;

  StatsModel({
    required this.views,
    required this.enquiries,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      views: json['views'] ?? 0,
      enquiries: json['enquiries'] ?? 0,
    );
  }
}
