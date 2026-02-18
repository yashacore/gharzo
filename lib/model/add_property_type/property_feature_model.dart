class PropertyFeaturesModel {
  final FurnishingModel furnishing;
  // final ParkingModel parking;
  // final String facing;
  final List<String> amenitiesList;
  final PropertyRulesModel propertyFeatures;

  PropertyFeaturesModel({
    required this.furnishing,
    // required this.parking,
    // required this.facing,
    required this.amenitiesList,
    required this.propertyFeatures,
  });

  factory PropertyFeaturesModel.fromJson(Map<String, dynamic> json) {
    return PropertyFeaturesModel(
      furnishing: FurnishingModel.fromJson(json['furnishing'] ?? {}),
      // parking: ParkingModel.fromJson(json['parking'] ?? {}),
      // facing: json['facing'] ?? '',
      amenitiesList: List<String>.from(json['amenitiesList'] ?? []),
      propertyFeatures:
      PropertyRulesModel.fromJson(json['propertyFeatures'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "furnishing": furnishing.toJson(),
      // "parking": parking.toJson(),
      // "facing": facing,
      "amenitiesList": amenitiesList,
      "propertyFeatures": propertyFeatures.toJson(),
    };
  }
}

// ---------------- Furnishing
class FurnishingModel {
  final String type;
  final List<String> items;

  FurnishingModel({
    required this.type,
    required this.items,
  });

  factory FurnishingModel.fromJson(Map<String, dynamic> json) {
    return FurnishingModel(
      type: json['type'] ?? 'Unfurnished',
      items: List<String>.from(json['items'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "items": items,
    };
  }
}

// ---------------- Parking
class ParkingModel {
  final int covered;
  final int open;

  ParkingModel({
    required this.covered,
    required this.open,
  });

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    return ParkingModel(
      covered: json['covered'] ?? 0,
      open: json['open'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "covered": covered,
      "open": open,
    };
  }
}

// ---------------- Property Rules
class PropertyRulesModel {
  final String powerBackup; // None / Partial / Full
  final String waterSupply; // Borewell / Corporation / Both
  final bool gatedSecurity;
  final bool liftAvailable;
  final bool petFriendly;
  final bool bachelorsAllowed;
  final bool nonVegAllowed;
  final bool wheelchairAccessible;

  PropertyRulesModel({
    required this.powerBackup,
    required this.waterSupply,
    required this.gatedSecurity,
    required this.liftAvailable,
    required this.petFriendly,
    required this.bachelorsAllowed,
    required this.nonVegAllowed,
    required this.wheelchairAccessible,
  });

  factory PropertyRulesModel.fromJson(Map<String, dynamic> json) {
    return PropertyRulesModel(
      powerBackup: json['powerBackup'] ?? 'None',
      waterSupply: json['waterSupply'] ?? 'Both',
      gatedSecurity: json['gatedSecurity'] ?? false,
      liftAvailable: json['liftAvailable'] ?? false,
      petFriendly: json['petFriendly'] ?? false,
      bachelorsAllowed: json['bachelorsAllowed'] ?? false,
      nonVegAllowed: json['nonVegAllowed'] ?? true,
      wheelchairAccessible: json['wheelchairAccessible'] ?? false,
    );
  }

  PropertyRulesModel copyWith({
    String? powerBackup,
    String? waterSupply,
    bool? gatedSecurity,
    bool? liftAvailable,
    bool? petFriendly,
    bool? bachelorsAllowed,
    bool? nonVegAllowed,
    bool? wheelchairAccessible,
  }) {
    return PropertyRulesModel(
      powerBackup: powerBackup ?? this.powerBackup,
      waterSupply: waterSupply ?? this.waterSupply,
      gatedSecurity: gatedSecurity ?? this.gatedSecurity,
      liftAvailable: liftAvailable ?? this.liftAvailable,
      petFriendly: petFriendly ?? this.petFriendly,
      bachelorsAllowed: bachelorsAllowed ?? this.bachelorsAllowed,
      nonVegAllowed: nonVegAllowed ?? this.nonVegAllowed,
      wheelchairAccessible:
      wheelchairAccessible ?? this.wheelchairAccessible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "powerBackup": powerBackup,
      "waterSupply": waterSupply,
      "gatedSecurity": gatedSecurity,
      "liftAvailable": liftAvailable,
      "petFriendly": petFriendly,
      "bachelorsAllowed": bachelorsAllowed,
      "nonVegAllowed": nonVegAllowed,
      "wheelchairAccessible": wheelchairAccessible,
    };
  }
}
