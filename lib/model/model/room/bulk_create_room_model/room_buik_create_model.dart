class BulkCreateRoomRequestModel {
  final String propertyId;
  final List<RoomRequest> rooms;

  BulkCreateRoomRequestModel({
    required this.propertyId,
    required this.rooms,
  });

  Map<String, dynamic> toJson() => {
    "propertyId": propertyId,
    "rooms": rooms.map((e) => e.toJson()).toList(),
  };
}

class RoomRequest {
  final String roomNumber;
  final String roomType;
  final int floor;
  final Pricing pricing;
  final Capacity capacity;
  final Features features;
  final Rules rules;
  final Area area;

  RoomRequest({
    required this.roomNumber,
    required this.roomType,
    required this.floor,
    required this.pricing,
    required this.capacity,
    required this.features,
    required this.rules,
    required this.area,
  });

  Map<String, dynamic> toJson() => {
    "roomNumber": roomNumber,
    "roomType": roomType,
    "floor": floor,
    "pricing": pricing.toJson(),
    "capacity": capacity.toJson(),
    "features": features.toJson(),
    "rules": rules.toJson(),
    "area": area.toJson(),
  };
}

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

  Map<String, dynamic> toJson() => {
    "rentPerBed": rentPerBed,
    "securityDeposit": securityDeposit,
    "maintenanceCharges": maintenanceCharges.toJson(),
    "electricityCharges": electricityCharges,
    "waterCharges": waterCharges,
  };
}

class MaintenanceCharges {
  final int amount;
  final bool includedInRent;

  MaintenanceCharges({
    required this.amount,
    required this.includedInRent,
  });

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "includedInRent": includedInRent,
  };
}

class Capacity {
  final int totalBeds;

  Capacity({required this.totalBeds});

  Map<String, dynamic> toJson() => {
    "totalBeds": totalBeds,
  };
}

class Features {
  final String furnishing;
  final bool hasAttachedBathroom;
  final bool hasAC;
  final bool hasWardrobe;
  final List<String> amenities;

  final bool? hasBalcony;
  final bool? hasFridge;

  Features({
    required this.furnishing,
    required this.hasAttachedBathroom,
    required this.hasAC,
    required this.hasWardrobe,
    required this.amenities,
    this.hasBalcony,
    this.hasFridge,
  });

  Map<String, dynamic> toJson() => {
    "furnishing": furnishing,
    "hasAttachedBathroom": hasAttachedBathroom,
    "hasAC": hasAC,
    "hasWardrobe": hasWardrobe,
    "amenities": amenities,
    if (hasBalcony != null) "hasBalcony": hasBalcony,
    if (hasFridge != null) "hasFridge": hasFridge,
  };
}

class Rules {
  final String genderPreference;
  final String foodType;
  final int noticePeriod;
  final bool? smokingAllowed;
  final bool? petsAllowed;
  final int? lockInPeriod;

  Rules({
    required this.genderPreference,
    required this.foodType,
    required this.noticePeriod,
    this.smokingAllowed,
    this.petsAllowed,
    this.lockInPeriod,
  });

  Map<String, dynamic> toJson() => {
    "genderPreference": genderPreference,
    "foodType": foodType,
    "noticePeriod": noticePeriod,
    if (smokingAllowed != null) "smokingAllowed": smokingAllowed,
    if (petsAllowed != null) "petsAllowed": petsAllowed,
    if (lockInPeriod != null) "lockInPeriod": lockInPeriod,
  };
}

class Area {
  final int carpet;
  final String unit;

  Area({required this.carpet, required this.unit});

  Map<String, dynamic> toJson() => {
    "carpet": carpet,
    "unit": unit,
  };
}



class BulkCreateRoomResponse {
  final bool success;
  final int count;
  final List<RoomData> data;

  BulkCreateRoomResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory BulkCreateRoomResponse.fromJson(Map<String, dynamic> json) {
    return BulkCreateRoomResponse(
      success: json['success'],
      count: json['count'],
      data: List<RoomData>.from(
        json['data'].map((x) => RoomData.fromJson(x)),
      ),
    );
  }
}

class RoomData {
  final String id;
  final String roomNumber;
  final String roomType;
  final int floor;

  RoomData({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.floor,
  });

  factory RoomData.fromJson(Map<String, dynamic> json) {
    return RoomData(
      id: json['_id'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      floor: json['floor'],
    );
  }
}
