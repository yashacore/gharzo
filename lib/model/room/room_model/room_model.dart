class RoomModel {
  final String id;
  final String roomNumber;
  final String roomType;
  final int floor;
  final Pricing pricing;
  final Capacity capacity;
  final Features features;
  final Rules rules;
  final Area area;
  final List<RoomImage> images;
  final String status;

  RoomModel({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    required this.floor,
    required this.pricing,
    required this.capacity,
    required this.features,
    required this.rules,
    required this.area,
    required this.images,
    required this.status,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['_id'],
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['roomType'] ?? '',
      floor: json['floor'] ?? 0,
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      capacity: Capacity.fromJson(json['capacity'] ?? {}),
      features: Features.fromJson(json['features'] ?? {}),
      rules: Rules.fromJson(json['rules'] ?? {}),
      area: Area.fromJson(json['area'] ?? {}),
      images: (json['images'] as List? ?? [])
          .map((e) => RoomImage.fromJson(e))
          .toList(),
      status: json['status'] ?? 'Available',
    );
  }

  RoomModel copyWith({
    String? id,
    String? roomNumber,
    String? roomType,
    int? floor,
    Pricing? pricing,
    Capacity? capacity,
    Features? features,
    Rules? rules,
    Area? area,
    List<RoomImage>? images,
    String? status,
  }) {
    return RoomModel(
      id: id ?? this.id,
      roomNumber: roomNumber ?? this.roomNumber,
      roomType: roomType ?? this.roomType,
      floor: floor ?? this.floor,
      pricing: pricing ?? this.pricing,
      capacity: capacity ?? this.capacity,
      features: features ?? this.features,
      rules: rules ?? this.rules,
      area: area ?? this.area,
      images: images ?? this.images,
      status: status ?? this.status,
    );
  }

}

/* ---------- Sub Models ---------- */

class Pricing {
  final int rentPerBed;
  final int securityDeposit;

  Pricing({required this.rentPerBed, required this.securityDeposit});

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      rentPerBed: json['rentPerBed'] ?? 0,
      securityDeposit: json['securityDeposit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "rentPerBed": rentPerBed,
    "securityDeposit": securityDeposit,
  };
}

class Capacity {
  final int totalBeds;
  final int occupiedBeds;
  final int availableBeds;

  Capacity({
    required this.totalBeds,
    this.occupiedBeds = 0,
    this.availableBeds = 0,
  });

  factory Capacity.fromJson(Map<String, dynamic> json) {
    return Capacity(
      totalBeds: json['totalBeds'] ?? 0,
      occupiedBeds: json['occupiedBeds'] ?? 0,
      availableBeds: json['availableBeds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "totalBeds": totalBeds,
  };
}

class Features {
  final String furnishing;
  final bool hasAttachedBathroom;
  final bool hasAC;
  final bool hasBalcony;
  final bool hasWardrobe;

  Features({
    required this.furnishing,
    this.hasAttachedBathroom = false,
    this.hasAC = false,
    this.hasBalcony = false,
    this.hasWardrobe = false,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      furnishing: json['furnishing'] ?? '',
      hasAttachedBathroom: json['hasAttachedBathroom'] ?? false,
      hasAC: json['hasAC'] ?? false,
      hasBalcony: json['hasBalcony'] ?? false,
      hasWardrobe: json['hasWardrobe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "furnishing": furnishing,
    "hasAttachedBathroom": hasAttachedBathroom,
    "hasAC": hasAC,
    "hasBalcony": hasBalcony,
    "hasWardrobe": hasWardrobe,
  };
}

class Rules {
  final String genderPreference;
  final String foodType;
  final int noticePeriod;

  Rules({
    required this.genderPreference,
    this.foodType = '',
    this.noticePeriod = 0,
  });

  factory Rules.fromJson(Map<String, dynamic> json) {
    return Rules(
      genderPreference: json['genderPreference'] ?? '',
      foodType: json['foodType'] ?? '',
      noticePeriod: json['noticePeriod'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "genderPreference": genderPreference,
    "foodType": foodType,
    "noticePeriod": noticePeriod,
  };
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

  Map<String, dynamic> toJson() => {
    "carpet": carpet,
    "unit": unit,
  };
}

class RoomImage {
  final String url;
  final bool isPrimary;

  RoomImage({required this.url, this.isPrimary = false});

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      url: json['url'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}
