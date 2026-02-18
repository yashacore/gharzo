class ToggleRoomStatusResponseModel {
  bool success;
  RoomStatusData data;

  ToggleRoomStatusResponseModel({
    required this.success,
    required this.data,
  });

  factory ToggleRoomStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return ToggleRoomStatusResponseModel(
      success: json['success'],
      data: RoomStatusData.fromJson(json['data']),
    );
  }
}

class RoomStatusData {
  Pricing pricing;
  Capacity capacity;
  Media media;
  Features features;
  Rules rules;
  Availability availability;
  Area area;
  String id;
  String propertyId;
  String landlordId;
  String roomNumber;
  String roomType;
  int floor;
  bool isActive;
  bool isDeleted;
  String createdAt;
  String updatedAt;

  RoomStatusData({
    required this.pricing,
    required this.capacity,
    required this.media,
    required this.features,
    required this.rules,
    required this.availability,
    required this.area,
    required this.id,
    required this.propertyId,
    required this.landlordId,
    required this.roomNumber,
    required this.roomType,
    required this.floor,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomStatusData.fromJson(Map<String, dynamic> json) {
    return RoomStatusData(
      pricing: Pricing.fromJson(json['pricing']),
      capacity: Capacity.fromJson(json['capacity']),
      media: Media.fromJson(json['media']),
      features: Features.fromJson(json['features']),
      rules: Rules.fromJson(json['rules']),
      availability: Availability.fromJson(json['availability']),
      area: Area.fromJson(json['area']),
      id: json['_id'],
      propertyId: json['propertyId'],
      landlordId: json['landlordId'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      floor: json['floor'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

/* ---- Nested Models ---- */

class Pricing {
  MaintenanceCharges maintenanceCharges;
  int rentPerBed;
  int securityDeposit;
  String electricityCharges;
  String waterCharges;

  Pricing({
    required this.maintenanceCharges,
    required this.rentPerBed,
    required this.securityDeposit,
    required this.electricityCharges,
    required this.waterCharges,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      maintenanceCharges:
      MaintenanceCharges.fromJson(json['maintenanceCharges']),
      rentPerBed: json['rentPerBed'],
      securityDeposit: json['securityDeposit'],
      electricityCharges: json['electricityCharges'],
      waterCharges: json['waterCharges'],
    );
  }
}

class MaintenanceCharges {
  int amount;
  bool includedInRent;

  MaintenanceCharges({
    required this.amount,
    required this.includedInRent,
  });

  factory MaintenanceCharges.fromJson(Map<String, dynamic> json) {
    return MaintenanceCharges(
      amount: json['amount'],
      includedInRent: json['includedInRent'],
    );
  }
}

class Capacity {
  int totalBeds;
  int occupiedBeds;

  Capacity({
    required this.totalBeds,
    required this.occupiedBeds,
  });

  factory Capacity.fromJson(Map<String, dynamic> json) {
    return Capacity(
      totalBeds: json['totalBeds'],
      occupiedBeds: json['occupiedBeds'],
    );
  }
}

class Media {
  List<dynamic> images;

  Media({required this.images});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(images: json['images'] ?? []);
  }
}

class Features {
  String furnishing;
  bool hasAttachedBathroom;
  bool hasBalcony;
  bool hasAC;
  bool hasWardrobe;
  bool hasFridge;
  List<String> amenities;

  Features({
    required this.furnishing,
    required this.hasAttachedBathroom,
    required this.hasBalcony,
    required this.hasAC,
    required this.hasWardrobe,
    required this.hasFridge,
    required this.amenities,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      furnishing: json['furnishing'],
      hasAttachedBathroom: json['hasAttachedBathroom'],
      hasBalcony: json['hasBalcony'],
      hasAC: json['hasAC'],
      hasWardrobe: json['hasWardrobe'],
      hasFridge: json['hasFridge'],
      amenities: List<String>.from(json['amenities']),
    );
  }
}

class Rules {
  String genderPreference;
  String foodType;
  bool smokingAllowed;
  bool petsAllowed;
  bool guestsAllowed;
  int noticePeriod;
  int lockInPeriod;

  Rules({
    required this.genderPreference,
    required this.foodType,
    required this.smokingAllowed,
    required this.petsAllowed,
    required this.guestsAllowed,
    required this.noticePeriod,
    required this.lockInPeriod,
  });

  factory Rules.fromJson(Map<String, dynamic> json) {
    return Rules(
      genderPreference: json['genderPreference'],
      foodType: json['foodType'],
      smokingAllowed: json['smokingAllowed'],
      petsAllowed: json['petsAllowed'],
      guestsAllowed: json['guestsAllowed'],
      noticePeriod: json['noticePeriod'],
      lockInPeriod: json['lockInPeriod'],
    );
  }
}

class Availability {
  String status;

  Availability({required this.status});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(status: json['status']);
  }
}

class Area {
  int carpet;
  String unit;

  Area({required this.carpet, required this.unit});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      carpet: json['carpet'],
      unit: json['unit'],
    );
  }
}
