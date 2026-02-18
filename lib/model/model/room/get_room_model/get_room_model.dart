class RoomDetailResponse {
  final bool success;
  final RoomDetail data;

  RoomDetailResponse({
    required this.success,
    required this.data,
  });

  factory RoomDetailResponse.fromJson(Map<String, dynamic> json) {
    return RoomDetailResponse(
      success: json['success'],
      data: RoomDetail.fromJson(json['data']),
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
  final String createdAt;
  final String updatedAt;

  final Pricing pricing;
  final Capacity capacity;
  final Media media;
  final Features features;
  final Rules rules;
  final Availability availability;
  final Area area;
  final PropertyMini property;
  final LandlordMini landlord;

  RoomDetail({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.floor,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.pricing,
    required this.capacity,
    required this.media,
    required this.features,
    required this.rules,
    required this.availability,
    required this.area,
    required this.property,
    required this.landlord,
  });

  factory RoomDetail.fromJson(Map<String, dynamic> json) {
    return RoomDetail(
      id: json['_id'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      floor: json['floor'],
      isActive: json['isActive'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      pricing: Pricing.fromJson(json['pricing']),
      capacity: Capacity.fromJson(json['capacity']),
      media: Media.fromJson(json['media']),
      features: Features.fromJson(json['features']),
      rules: Rules.fromJson(json['rules']),
      availability: Availability.fromJson(json['availability']),
      area: Area.fromJson(json['area']),
      property: PropertyMini.fromJson(json['propertyId']),
      landlord: LandlordMini.fromJson(json['landlordId']),
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
      rentPerBed: json['rentPerBed'],
      securityDeposit: json['securityDeposit'],
      maintenanceCharges:
      MaintenanceCharges.fromJson(json['maintenanceCharges']),
      electricityCharges: json['electricityCharges'],
      waterCharges: json['waterCharges'],
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
      amount: json['amount'],
      includedInRent: json['includedInRent'],
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
      totalBeds: json['totalBeds'],
      occupiedBeds: json['occupiedBeds'],
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
      furnishing: json['furnishing'],
      hasAttachedBathroom: json['hasAttachedBathroom'],
      hasAC: json['hasAC'],
      hasWardrobe: json['hasWardrobe'],
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
      genderPreference: json['genderPreference'],
      foodType: json['foodType'],
      noticePeriod: json['noticePeriod'],
      smokingAllowed: json['smokingAllowed'],
      petsAllowed: json['petsAllowed'],
      lockInPeriod: json['lockInPeriod'],
    );
  }
}

class Availability {
  final String status;

  Availability({required this.status});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      status: json['status'],
    );
  }
}

class Area {
  final int carpet;
  final String unit;

  Area({required this.carpet, required this.unit});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      carpet: json['carpet'],
      unit: json['unit'],
    );
  }
}

class PropertyMini {
  final String id;
  final String title;
  final PropertyLocation location;

  PropertyMini({
    required this.id,
    required this.title,
    required this.location,
  });

  factory PropertyMini.fromJson(Map<String, dynamic> json) {
    return PropertyMini(
      id: json['_id'],
      title: json['title'],
      location: PropertyLocation.fromJson(json['location']),
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
      address: json['address'],
      city: json['city'],
      locality: json['locality'],
      subLocality: json['subLocality'],
      landmark: json['landmark'],
      pincode: json['pincode'],
      state: json['state'],
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
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
