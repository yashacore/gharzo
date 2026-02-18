class RoomSearchResponse {
  final bool success;
  final int count;
  final int total;
  final int page;
  final int pages;
  final List<SearchRoomModel> data;

  RoomSearchResponse({
    required this.success,
    required this.count,
    required this.total,
    required this.page,
    required this.pages,
    required this.data,
  });

  factory RoomSearchResponse.fromJson(Map<String, dynamic> json) {
    return RoomSearchResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pages: json['pages'] ?? 1,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SearchRoomModel.fromJson(e))
          .toList(),
    );
  }
}

// --------------------------------------------------

class SearchRoomModel {
  final String id;
  final String roomNumber;
  final String roomType;
  final int floor;
  final bool isActive;
  final Pricing pricing;
  final Capacity capacity;
  final Media media;
  final Features features;
  final Rules rules;
  final Availability availability;
  final Area area;
  final Property property;

  SearchRoomModel({
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
    required this.property,
  });

  factory SearchRoomModel.fromJson(Map<String, dynamic> json) {
    return SearchRoomModel(
      id: json['_id'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['roomType'] ?? '',
      floor: json['floor'] ?? 0,
      isActive: json['isActive'] ?? false,
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      capacity: Capacity.fromJson(json['capacity'] ?? {}),
      media: Media.fromJson(json['media'] ?? {}),
      features: Features.fromJson(json['features'] ?? {}),
      rules: Rules.fromJson(json['rules'] ?? {}),
      availability: Availability.fromJson(json['availability'] ?? {}),
      area: Area.fromJson(json['area'] ?? {}),
      property: Property.fromJson(json['propertyId'] ?? {}),
    );
  }
}

// --------------------------------------------------

class Pricing {
  final int rentPerBed;
  final int securityDeposit;
  final String electricityCharges;
  final String waterCharges;
  final MaintenanceCharges maintenanceCharges;

  Pricing({
    required this.rentPerBed,
    required this.securityDeposit,
    required this.electricityCharges,
    required this.waterCharges,
    required this.maintenanceCharges,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      rentPerBed: json['rentPerBed'] ?? 0,
      securityDeposit: json['securityDeposit'] ?? 0,
      electricityCharges: json['electricityCharges'] ?? '',
      waterCharges: json['waterCharges'] ?? '',
      maintenanceCharges:
      MaintenanceCharges.fromJson(json['maintenanceCharges'] ?? {}),
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

// --------------------------------------------------

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

// --------------------------------------------------

class Media {
  final List<RoomImage> images;

  Media({required this.images});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => RoomImage.fromJson(e))
          .toList(),
    );
  }
}

class RoomImage {
  final String url;
  final bool isPrimary;

  RoomImage({
    required this.url,
    required this.isPrimary,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      url: json['url'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}

// --------------------------------------------------

class Features {
  final String furnishing;
  final bool hasAttachedBathroom;
  final bool hasBalcony;
  final bool hasAC;
  final bool hasWardrobe;
  final bool hasFridge;
  final List<String> amenities;

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
      furnishing: json['furnishing'] ?? '',
      hasAttachedBathroom: json['hasAttachedBathroom'] ?? false,
      hasBalcony: json['hasBalcony'] ?? false,
      hasAC: json['hasAC'] ?? false,
      hasWardrobe: json['hasWardrobe'] ?? false,
      hasFridge: json['hasFridge'] ?? false,
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }
}

// --------------------------------------------------

class Rules {
  final String genderPreference;
  final String foodType;
  final bool smokingAllowed;
  final bool petsAllowed;
  final bool guestsAllowed;
  final int noticePeriod;
  final int lockInPeriod;

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
      genderPreference: json['genderPreference'] ?? '',
      foodType: json['foodType'] ?? '',
      smokingAllowed: json['smokingAllowed'] ?? false,
      petsAllowed: json['petsAllowed'] ?? false,
      guestsAllowed: json['guestsAllowed'] ?? false,
      noticePeriod: json['noticePeriod'] ?? 0,
      lockInPeriod: json['lockInPeriod'] ?? 0,
    );
  }
}

// --------------------------------------------------

class Availability {
  final String status;

  Availability({required this.status});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      status: json['status'] ?? '',
    );
  }
}

// --------------------------------------------------

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

// --------------------------------------------------

class Property {
  final String id;
  final String title;
  final PropertyLocation location;

  Property({
    required this.id,
    required this.title,
    required this.location,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      location: PropertyLocation.fromJson(json['location'] ?? {}),
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
