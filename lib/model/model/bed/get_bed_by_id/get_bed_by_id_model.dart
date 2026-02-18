class GetBedByIdResponseModel {
  final bool success;
  final BedDetail data;

  GetBedByIdResponseModel({
    required this.success,
    required this.data,
  });

  factory GetBedByIdResponseModel.fromJson(Map<String, dynamic> json) {
    return GetBedByIdResponseModel(
      success: json['success'],
      data: BedDetail.fromJson(json['data']),
    );
  }
}

/* ---------------- Bed Detail ---------------- */

class BedDetail {
  final String id;
  final String bedNumber;
  final Room roomId;
  final Property propertyId;
  final Landlord landlordId;
  final String bedType;
  final BedSize bedSize;
  final Pricing pricing;
  final Features features;
  final Position position;
  final Preferences preferences;
  final CreatedBy createdBy;
  final List<String> images;
  final String status;
  final bool isActive;
  final String availableFrom;
  final String condition;
  final String notes;
  final bool isDeleted;
  final List<dynamic> occupancyHistory;
  final String createdAt;
  final String updatedAt;

  BedDetail({
    required this.id,
    required this.bedNumber,
    required this.roomId,
    required this.propertyId,
    required this.landlordId,
    required this.bedType,
    required this.bedSize,
    required this.pricing,
    required this.features,
    required this.position,
    required this.preferences,
    required this.createdBy,
    required this.images,
    required this.status,
    required this.isActive,
    required this.availableFrom,
    required this.condition,
    required this.notes,
    required this.isDeleted,
    required this.occupancyHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BedDetail.fromJson(Map<String, dynamic> json) {
    return BedDetail(
      id: json['_id'],
      bedNumber: json['bedNumber'],
      roomId: Room.fromJson(json['roomId']),
      propertyId: Property.fromJson(json['propertyId']),
      landlordId: Landlord.fromJson(json['landlordId']),
      bedType: json['bedType'],
      bedSize: BedSize.fromJson(json['bedSize']),
      pricing: Pricing.fromJson(json['pricing']),
      features: Features.fromJson(json['features']),
      position: Position.fromJson(json['position']),
      preferences: Preferences.fromJson(json['preferences']),
      createdBy: CreatedBy.fromJson(json['createdBy']),
      images: List<String>.from(json['images']),
      status: json['status'],
      isActive: json['isActive'],
      availableFrom: json['availableFrom'],
      condition: json['condition'],
      notes: json['notes'],
      isDeleted: json['isDeleted'],
      occupancyHistory: json['occupancyHistory'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

/* ---------------- Sub Models ---------------- */

class Room {
  final String id;
  final String roomNumber;
  final String roomType;
  final int floor;

  Room({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.floor,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      floor: json['floor'],
    );
  }
}

class Property {
  final String id;
  final String title;
  final Location location;
  final List<PropertyImage> images;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.images,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'],
      title: json['title'],
      location: Location.fromJson(json['location']),
      images: List<PropertyImage>.from(
        json['images'].map((x) => PropertyImage.fromJson(x)),
      ),
    );
  }
}

class Location {
  final String address;
  final String city;
  final String locality;
  final String subLocality;
  final String landmark;
  final String pincode;
  final String state;

  Location({
    required this.address,
    required this.city,
    required this.locality,
    required this.subLocality,
    required this.landmark,
    required this.pincode,
    required this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
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

class PropertyImage {
  final String id;
  final String url;
  final String key;
  final bool isPrimary;
  final String uploadedAt;

  PropertyImage({
    required this.id,
    required this.url,
    required this.key,
    required this.isPrimary,
    required this.uploadedAt,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['_id'],
      url: json['url'],
      key: json['key'],
      isPrimary: json['isPrimary'],
      uploadedAt: json['uploadedAt'],
    );
  }
}

class Landlord {
  final String id;
  final String name;
  final String phone;

  Landlord({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory Landlord.fromJson(Map<String, dynamic> json) {
    return Landlord(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class BedSize {
  final int length;
  final int width;
  final String unit;

  BedSize({
    required this.length,
    required this.width,
    required this.unit,
  });

  factory BedSize.fromJson(Map<String, dynamic> json) {
    return BedSize(
      length: json['length'],
      width: json['width'],
      unit: json['unit'],
    );
  }
}

class Pricing {
  final int rent;
  final int securityDeposit;
  final int maintenanceCharges;

  Pricing({
    required this.rent,
    required this.securityDeposit,
    required this.maintenanceCharges,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      rent: json['rent'],
      securityDeposit: json['securityDeposit'],
      maintenanceCharges: json['maintenanceCharges'],
    );
  }
}

class Features {
  final bool hasAttachedBathroom;
  final bool hasAC;
  final bool hasLocker;
  final bool hasStudyTable;
  final bool hasWardrobe;
  final bool hasBalcony;
  final bool hasFan;
  final bool hasLight;
  final bool hasChair;
  final bool hasMattress;
  final bool hasPillow;
  final bool hasBedsheet;

  Features({
    required this.hasAttachedBathroom,
    required this.hasAC,
    required this.hasLocker,
    required this.hasStudyTable,
    required this.hasWardrobe,
    required this.hasBalcony,
    required this.hasFan,
    required this.hasLight,
    required this.hasChair,
    required this.hasMattress,
    required this.hasPillow,
    required this.hasBedsheet,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      hasAttachedBathroom: json['hasAttachedBathroom'],
      hasAC: json['hasAC'],
      hasLocker: json['hasLocker'],
      hasStudyTable: json['hasStudyTable'],
      hasWardrobe: json['hasWardrobe'],
      hasBalcony: json['hasBalcony'],
      hasFan: json['hasFan'],
      hasLight: json['hasLight'],
      hasChair: json['hasChair'],
      hasMattress: json['hasMattress'],
      hasPillow: json['hasPillow'],
      hasBedsheet: json['hasBedsheet'],
    );
  }
}

class Position {
  final bool nearWindow;
  final bool cornerBed;
  final String description;
  final bool nearDoor;

  Position({
    required this.nearWindow,
    required this.cornerBed,
    required this.description,
    required this.nearDoor,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      nearWindow: json['nearWindow'],
      cornerBed: json['cornerBed'],
      description: json['description'],
      nearDoor: json['nearDoor'],
    );
  }
}

class Preferences {
  final String genderPreference;
  final String occupationType;

  Preferences({
    required this.genderPreference,
    required this.occupationType,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      genderPreference: json['genderPreference'],
      occupationType: json['occupationType'],
    );
  }
}

class CreatedBy {
  final String userId;
  final String role;

  CreatedBy({
    required this.userId,
    required this.role,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      userId: json['userId'],
      role: json['role'],
    );
  }
}
