// lib/model/room/get_room_model/get_room_model.dart

class RoomDetailResponse {
  final bool success;
  final List<RoomDetail> data; // Updated to List, assuming API returns a list of rooms

  RoomDetailResponse({
    required this.success,
    required this.data,
  });

  factory RoomDetailResponse.fromJson(Map<String, dynamic> json) {
    return RoomDetailResponse(
      success: json['success'] ?? false,
      // Mapping the list of data
      data: json['data'] != null
          ? (json['data'] as List).map((i) => RoomDetail.fromJson(i)).toList()
          : [],
    );
  }
}

class RoomDetail {
  final String id;
  final String roomNumber;
  final String roomType;
  final int floor;
  final bool isActive;
  final bool isDeleted;
  final String? createdAt; // Made nullable
  final String? updatedAt; // Made nullable

  final Pricing pricing;
  final Capacity capacity;
  final Media media;
  final Features features;
  final Rules rules;
  final Availability availability;
  final Area area;
  final PropertyMini? property; // Made nullable
  final LandlordMini? landlord; // Made nullable

  RoomDetail({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.floor,
    required this.isActive,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
    required this.pricing,
    required this.capacity,
    required this.media,
    required this.features,
    required this.rules,
    required this.availability,
    required this.area,
    this.property,
    this.landlord,
  });

  factory RoomDetail.fromJson(Map<String, dynamic> json) {
    return RoomDetail(
      id: json['_id'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['type'] ?? '', // API mein shayad 'type' ho, screenshot ke hisaab se
      floor: json['floor'] ?? 0,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      capacity: Capacity.fromJson(json['capacity'] ?? {}),
      media: Media.fromJson(json['media'] ?? {}),
      features: Features.fromJson(json['features'] ?? {}),
      rules: Rules.fromJson(json['rules'] ?? {}),
      availability: Availability.fromJson(json['availability'] ?? {}),
      area: Area.fromJson(json['area'] ?? {}),
      // Handling potential null for nested objects
      property: json['propertyId'] != null ? PropertyMini.fromJson(json['propertyId']) : null,
      landlord: json['landlordId'] != null ? LandlordMini.fromJson(json['landlordId']) : null,
    );
  }
}

/* ---------------- Sub Models ---------------- */

class Pricing {
  final int rentPerBed;
  final int securityDeposit;
  final MaintenanceCharges maintenanceCharges;
  final String electricityCharges;
  final String waterCharges;

  Pricing({
    required this.rentPerBed,
    required this.securityDeposit,
    required this.maintenanceCharges,
    required this.electricityCharges,
    required this.waterCharges,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      rentPerBed: json['rentPerBed'] ?? 0,
      securityDeposit: json['securityDeposit'] ?? 0,
      maintenanceCharges: MaintenanceCharges.fromJson(json['maintenanceCharges'] ?? {}),
      electricityCharges: json['electricityCharges'] ?? '',
      waterCharges: json['waterCharges'] ?? '',
    );
  }
}

class MaintenanceCharges {
  final int amount;
  final bool includedInRent;

  MaintenanceCharges({
    required this.amount,
    required this.includedInRent,
  });

  factory MaintenanceCharges.fromJson(Map<String, dynamic> json) {
    return MaintenanceCharges(
      amount: json['amount'] ?? 0,
      includedInRent: json['includedInRent'] ?? false,
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

class Media {
  final List<String> images;

  Media({required this.images});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class Features {
  final String furnishing;
  final bool hasAttachedBathroom;
  final bool hasAC;
  final bool hasWardrobe;
  final bool? hasBalcony;
  final bool? hasFridge;
  final List<String> amenities;

  Features({
    required this.furnishing,
    required this.hasAttachedBathroom,
    required this.hasAC,
    required this.hasWardrobe,
    required this.amenities,
    this.hasBalcony,
    this.hasFridge,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      furnishing: json['furnishing'] ?? '',
      hasAttachedBathroom: json['hasAttachedBathroom'] ?? false,
      hasAC: json['hasAC'] ?? false,
      hasWardrobe: json['hasWardrobe'] ?? false,
      amenities: List<String>.from(json['amenities'] ?? []),
      hasBalcony: json['hasBalcony'],
      hasFridge: json['hasFridge'],
    );
  }
}

class Rules {
  final String genderPreference;
  final String foodType;
  final int noticePeriod;
  final bool smokingAllowed;
  final bool petsAllowed;
  final int lockInPeriod;

  Rules({
    required this.genderPreference,
    required this.foodType,
    required this.noticePeriod,
    required this.smokingAllowed,
    required this.petsAllowed,
    required this.lockInPeriod,
  });

  factory Rules.fromJson(Map<String, dynamic> json) {
    return Rules(
      genderPreference: json['genderPreference'] ?? '',
      foodType: json['foodType'] ?? '',
      noticePeriod: json['noticePeriod'] ?? 0,
      smokingAllowed: json['smokingAllowed'] ?? false,
      petsAllowed: json['petsAllowed'] ?? false,
      lockInPeriod: json['lockInPeriod'] ?? 0,
    );
  }
}

class Availability {
  final String status;

  Availability({required this.status});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      status: json['status'] ?? 'Available',
    );
  }
}

class Area {
  final int carpet;
  final String unit;

  Area({required this.carpet, required this.unit});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      carpet: json['carpet'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}

class PropertyMini {
  final String id;
  final String title;
  final PropertyLocation? location; // Made nullable

  PropertyMini({
    required this.id,
    required this.title,
    this.location,
  });

  factory PropertyMini.fromJson(Map<String, dynamic> json) {
    return PropertyMini(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] != null ? PropertyLocation.fromJson(json['location']) : null,
    );
  }
}

class PropertyLocation {
  final String address;
  final String city;
  final String locality;
  final String subLocality;
  final String landmark;
  final String pincode;
  final String state;

  PropertyLocation({
    required this.address,
    required this.city,
    required this.locality,
    required this.subLocality,
    required this.landmark,
    required this.pincode,
    required this.state,
  });

  factory PropertyLocation.fromJson(Map<String, dynamic> json) {
    return PropertyLocation(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      locality: json['locality'] ?? '',
      subLocality: json['subLocality'] ?? '',
      landmark: json['landmark'] ?? '',
      pincode: json['pincode'] ?? '',
      state: json['state'] ?? '',
    );
  }
}

class LandlordMini {
  final String id;
  final String name;
  final String phone;

  LandlordMini({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory LandlordMini.fromJson(Map<String, dynamic> json) {
    return LandlordMini(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}