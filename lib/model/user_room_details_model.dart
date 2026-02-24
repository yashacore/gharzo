class RoomDetailsResponseModel {
  final bool success;
  final RoomDetailsModel data;

  RoomDetailsResponseModel({
    required this.success,
    required this.data,
  });

  factory RoomDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return RoomDetailsResponseModel(
      success: json['success'],
      data: RoomDetailsModel.fromJson(json['data']),
    );
  }
}class RoomDetailsModel {
  final String id;
  final String roomNumber;
  final String roomType;
  final int floor;
  final bool isActive;
  final PricingModel pricing;
  final CapacityModel capacity;
  final MediaModel media;
  final FeaturesModel features;
  final RulesModel rules;
  final AvailabilityModel availability;
  final AreaModel area;

  RoomDetailsModel({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.floor,
    required this.isActive,
    required this.pricing,
    required this.capacity,
    required this.media,
    required this.features,
    required this.rules,
    required this.availability,
    required this.area,
  });

  factory RoomDetailsModel.fromJson(Map<String, dynamic> json) {
    return RoomDetailsModel(
      id: json['_id'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['roomType'] ?? '',
      floor: json['floor'] ?? 0,
      isActive: json['isActive'] ?? true,
      pricing: PricingModel.fromJson(json['pricing'] ?? {}),
      capacity: CapacityModel.fromJson(json['capacity'] ?? {}),
      media: MediaModel.fromJson(json['media'] ?? {"images": []}),
      features: FeaturesModel.fromJson(json['features'] ?? {}),
      rules: RulesModel.fromJson(json['rules'] ?? {}),
      availability:
      AvailabilityModel.fromJson(json['availability'] ?? {"status": "Unknown"}),
      area: AreaModel.fromJson(json['area'] ?? {"carpet": 0, "unit": ""}),
    );
  }}
class PricingModel {
  final int rentPerBed;
  final int rentPerRoom;
  final int securityDeposit;
  final String electricityCharges;
  final String waterCharges;
  final MaintenanceChargesModel maintenance;

  PricingModel({
    required this.rentPerBed,
    required this.rentPerRoom,
    required this.securityDeposit,
    required this.electricityCharges,
    required this.waterCharges,
    required this.maintenance,
  });

  factory PricingModel.fromJson(Map<String, dynamic> json) {
    return PricingModel(
      rentPerBed: json['rentPerBed'] ?? 0,
      rentPerRoom: json['rentPerRoom'] ?? 0,
      securityDeposit: json['securityDeposit'] ?? 0,
      electricityCharges: json['electricityCharges'] ?? "Extra",
      waterCharges: json['waterCharges'] ?? "Included",
      maintenance: json['maintenanceCharges'] != null
          ? MaintenanceChargesModel.fromJson(json['maintenanceCharges'])
          : MaintenanceChargesModel(amount: 0, includedInRent: false),
    );
  }
}

class MaintenanceChargesModel {
  final int amount;
  final bool includedInRent;

  MaintenanceChargesModel({
    required this.amount,
    required this.includedInRent,
  });

  factory MaintenanceChargesModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceChargesModel(
      amount: json['amount'] ?? 0,
      includedInRent: json['includedInRent'] ?? false,
    );
  }
}class CapacityModel {
  final int totalBeds;
  final int occupiedBeds;

  CapacityModel({
    required this.totalBeds,
    required this.occupiedBeds,
  });

  factory CapacityModel.fromJson(Map<String, dynamic> json) {
    return CapacityModel(
      totalBeds: json['totalBeds'],
      occupiedBeds: json['occupiedBeds'],
    );
  }
}class MediaModel {
  final List<RoomImageModel> images;

  MediaModel({required this.images});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      images: (json['images'] as List)
          .map((e) => RoomImageModel.fromJson(e))
          .toList(),
    );
  }
}

class RoomImageModel {
  final String url;
  final bool isPrimary;

  RoomImageModel({
    required this.url,
    required this.isPrimary,
  });

  factory RoomImageModel.fromJson(Map<String, dynamic> json) {
    return RoomImageModel(
      url: json['url'],
      isPrimary: json['isPrimary'],
    );
  }
}class FeaturesModel {
  final String furnishing;
  final bool hasAttachedBathroom;
  final bool hasBalcony;
  final bool hasAC;
  final bool hasWardrobe;
  final bool hasFridge;
  final List<String> amenities;

  FeaturesModel({
    required this.furnishing,
    required this.hasAttachedBathroom,
    required this.hasBalcony,
    required this.hasAC,
    required this.hasWardrobe,
    required this.hasFridge,
    required this.amenities,
  });

  factory FeaturesModel.fromJson(Map<String, dynamic> json) {
    return FeaturesModel(
      furnishing: json['furnishing'],
      hasAttachedBathroom: json['hasAttachedBathroom'],
      hasBalcony: json['hasBalcony'],
      hasAC: json['hasAC'],
      hasWardrobe: json['hasWardrobe'],
      hasFridge: json['hasFridge'],
      amenities: List<String>.from(json['amenities']),
    );
  }
}class RulesModel {
  final String genderPreference;
  final String foodType;
  final bool smokingAllowed;
  final bool petsAllowed;
  final bool guestsAllowed;
  final int noticePeriod;
  final int lockInPeriod;

  RulesModel({
    required this.genderPreference,
    required this.foodType,
    required this.smokingAllowed,
    required this.petsAllowed,
    required this.guestsAllowed,
    required this.noticePeriod,
    required this.lockInPeriod,
  });

  factory RulesModel.fromJson(Map<String, dynamic> json) {
    return RulesModel(
      genderPreference: json['genderPreference'],
      foodType: json['foodType'],
      smokingAllowed: json['smokingAllowed'],
      petsAllowed: json['petsAllowed'],
      guestsAllowed: json['guestsAllowed'],
      noticePeriod: json['noticePeriod'],
      lockInPeriod: json['lockInPeriod'],
    );
  }
}class AvailabilityModel {
  final String status;

  AvailabilityModel({required this.status});

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      status: json['status'],
    );
  }
}

class AreaModel {
  final int carpet;
  final String unit;

  AreaModel({
    required this.carpet,
    required this.unit,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      carpet: json['carpet'],
      unit: json['unit'],
    );
  }
}