class UpdateRoomRequestModel {
  Pricing pricing;
  Features features;
  Rules rules;

  UpdateRoomRequestModel({
    required this.pricing,
    required this.features,
    required this.rules,
  });

  Map<String, dynamic> toJson() => {
    "pricing": pricing.toJson(),
    "features": features.toJson(),
    "rules": rules.toJson(),
  };
}

class Pricing {
  int rentPerBed;
  int securityDeposit;
  MaintenanceCharges maintenanceCharges;

  Pricing({
    required this.rentPerBed,
    required this.securityDeposit,
    required this.maintenanceCharges,
  });

  Map<String, dynamic> toJson() => {
    "rentPerBed": rentPerBed,
    "securityDeposit": securityDeposit,
    "maintenanceCharges": maintenanceCharges.toJson(),
  };
}

class MaintenanceCharges {
  int amount;
  bool includedInRent;

  MaintenanceCharges({
    required this.amount,
    required this.includedInRent,
  });

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "includedInRent": includedInRent,
  };
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

  Map<String, dynamic> toJson() => {
    "furnishing": furnishing,
    "hasAttachedBathroom": hasAttachedBathroom,
    "hasBalcony": hasBalcony,
    "hasAC": hasAC,
    "hasWardrobe": hasWardrobe,
    "hasFridge": hasFridge,
    "amenities": amenities,
  };
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

  Map<String, dynamic> toJson() => {
    "genderPreference": genderPreference,
    "foodType": foodType,
    "smokingAllowed": smokingAllowed,
    "petsAllowed": petsAllowed,
    "guestsAllowed": guestsAllowed,
    "noticePeriod": noticePeriod,
    "lockInPeriod": lockInPeriod,
  };
}




