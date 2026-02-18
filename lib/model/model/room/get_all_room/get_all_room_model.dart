class AllRoomsResponseModel {
  final bool success;
  final int count;
  final List<AllRoomModel> data;

  AllRoomsResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory AllRoomsResponseModel.fromJson(Map<String, dynamic> json) {
    return AllRoomsResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List)
          .map((e) => AllRoomModel.fromJson(e))
          .toList(),
    );
  }
}

class AllRoomModel {
  final String id;
  final String propertyId;
  final String roomNumber;
  final String roomType;
  final int? floor;
  final Pricing pricing;
  final Capacity capacity;
  final Features features;
  final Rules rules;
  final Availability availability;
  final Area area;

  AllRoomModel({
    required this.id,
    required this.propertyId,
    required this.roomNumber,
    required this.roomType,
    required this.floor,
    required this.pricing,
    required this.capacity,
    required this.features,
    required this.rules,
    required this.availability,
    required this.area,
  });

  factory AllRoomModel.fromJson(Map<String, dynamic> json) {
    return AllRoomModel(
      id: json['_id'] ?? '',
      propertyId: json['propertyId'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['roomType'] ?? '',
      floor: json['floor'],
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      capacity: Capacity.fromJson(json['capacity'] ?? {}),
      features: Features.fromJson(json['features'] ?? {}),
      rules: Rules.fromJson(json['rules'] ?? {}),
      availability: Availability.fromJson(json['availability'] ?? {}),
      area: Area.fromJson(json['area'] ?? {}),
    );
  }
}

class Pricing {
  final int rentPerBed;
  final int securityDeposit;
  final int maintenanceAmount;
  final bool maintenanceIncluded;
  final String electricityCharges;
  final String waterCharges;

  Pricing({
    required this.rentPerBed,
    required this.securityDeposit,
    required this.maintenanceAmount,
    required this.maintenanceIncluded,
    required this.electricityCharges,
    required this.waterCharges,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      rentPerBed: json['rentPerBed'] ?? 0,
      securityDeposit: json['securityDeposit'] ?? 0,
      maintenanceAmount: json['maintenanceCharges']?['amount'] ?? 0,
      maintenanceIncluded:
      json['maintenanceCharges']?['includedInRent'] ?? false,
      electricityCharges: json['electricityCharges'] ?? '',
      waterCharges: json['waterCharges'] ?? '',
    );
  }
}

class Capacity {
  final int totalBeds;
  final int occupiedBeds;

  Capacity({
    required this.totalBeds,
    required this.occupiedBeds,
  });

  factory Capacity.fromJson(Map<String, dynamic> json) {
    return Capacity(
      totalBeds: json['totalBeds'] ?? 0,
      occupiedBeds: json['occupiedBeds'] ?? 0,
    );
  }
}

class Features {
  final String furnishing;
  final bool hasAttachedBathroom;
  final bool hasAC;
  final bool hasWardrobe;
  final List<String> amenities;

  Features({
    required this.furnishing,
    required this.hasAttachedBathroom,
    required this.hasAC,
    required this.hasWardrobe,
    required this.amenities,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      furnishing: json['furnishing'] ?? '',
      hasAttachedBathroom: json['hasAttachedBathroom'] ?? false,
      hasAC: json['hasAC'] ?? false,
      hasWardrobe: json['hasWardrobe'] ?? false,
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : [],
    );
  }
}

class Rules {
  final String genderPreference;
  final String foodType;
  final bool smokingAllowed;
  final bool petsAllowed;
  final int noticePeriod;
  final int lockInPeriod;

  Rules({
    required this.genderPreference,
    required this.foodType,
    required this.smokingAllowed,
    required this.petsAllowed,
    required this.noticePeriod,
    required this.lockInPeriod,
  });

  factory Rules.fromJson(Map<String, dynamic> json) {
    return Rules(
      genderPreference: json['genderPreference'] ?? '',
      foodType: json['foodType'] ?? '',
      smokingAllowed: json['smokingAllowed'] ?? false,
      petsAllowed: json['petsAllowed'] ?? false,
      noticePeriod: json['noticePeriod'] ?? 0,
      lockInPeriod: json['lockInPeriod'] ?? 0,
    );
  }
}

class Availability {
  final String status;

  Availability({required this.status});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      status: json['status'] ?? '',
    );
  }
}

class Area {
  final int carpet;
  final String unit;

  Area({
    required this.carpet,
    required this.unit,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      carpet: json['carpet'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}
