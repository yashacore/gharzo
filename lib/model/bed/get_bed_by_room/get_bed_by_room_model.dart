class GetBedsByRoomResponseModel {
  final bool success;
  final int count;
  final Room room;
  final List<BedModel> data;

  GetBedsByRoomResponseModel({
    required this.success,
    required this.count,
    required this.room,
    required this.data,
  });

  factory GetBedsByRoomResponseModel.fromJson(Map<String, dynamic> json) {
    return GetBedsByRoomResponseModel(
      success: json['success'],
      count: json['count'],
      room: Room.fromJson(json['room']),
      data: List<BedModel>.from(
        json['data'].map((x) => BedModel.fromJson(x)),
      ),
    );
  }
}

/* ---------------- Room ---------------- */

class Room {
  final String id;
  final String roomNumber;
  final String roomType;
  final RoomCapacity capacity;

  Room({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.capacity,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      capacity: RoomCapacity.fromJson(json['capacity']),
    );
  }
}

class RoomCapacity {
  final int totalBeds;
  final int occupiedBeds;

  RoomCapacity({
    required this.totalBeds,
    required this.occupiedBeds,
  });

  factory RoomCapacity.fromJson(Map<String, dynamic> json) {
    return RoomCapacity(
      totalBeds: json['totalBeds'],
      occupiedBeds: json['occupiedBeds'],
    );
  }
}

/* ---------------- Bed ---------------- */

class BedModel {
  final String id;
  final String bedNumber;
  final String roomId;
  final String propertyId;
  final String landlordId;
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

  BedModel({
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

  factory BedModel.fromJson(Map<String, dynamic> json) {
    return BedModel(
      id: json['_id'],
      bedNumber: json['bedNumber'],
      roomId: json['roomId'],
      propertyId: json['propertyId'],
      landlordId: json['landlordId'],
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

/* ---------------- Common Sub Models ---------------- */

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
