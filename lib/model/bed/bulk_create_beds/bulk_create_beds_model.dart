class BulkCreateBedsRequest {
  final String roomId;
  final List<BulkBedItem> beds;

  BulkCreateBedsRequest({
    required this.roomId,
    required this.beds,
  });

  Map<String, dynamic> toJson() {
    return {
      "roomId": roomId,
      "beds": beds.map((e) => e.toJson()).toList(),
    };
  }
}

class BulkBedItem {
  final String bedNumber;
  final String bedType;
  final BedPricing pricing;
  final BedFeatures features;
  final BedPreferences preferences;

  BulkBedItem({
    required this.bedNumber,
    required this.bedType,
    required this.pricing,
    required this.features,
    required this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      "bedNumber": bedNumber,
      "bedType": bedType,
      "pricing": pricing.toJson(),
      "features": features.toJson(),
      "preferences": preferences.toJson(),
    };
  }
}

class BedPricing {
  final int rent;
  final int securityDeposit;
  final int maintenanceCharges;

  BedPricing({
    required this.rent,
    required this.securityDeposit,
    required this.maintenanceCharges,
  });

  Map<String, dynamic> toJson() {
    return {
      "rent": rent,
      "securityDeposit": securityDeposit,
      "maintenanceCharges": maintenanceCharges,
    };
  }
}

class BedFeatures {
  final bool hasAC;
  final bool hasLocker;
  final bool hasStudyTable;

  BedFeatures({
    required this.hasAC,
    required this.hasLocker,
    required this.hasStudyTable,
  });

  Map<String, dynamic> toJson() {
    return {
      "hasAC": hasAC,
      "hasLocker": hasLocker,
      "hasStudyTable": hasStudyTable,
    };
  }
}

class BedPreferences {
  final String genderPreference;

  BedPreferences({
    required this.genderPreference,
  });

  Map<String, dynamic> toJson() {
    return {
      "genderPreference": genderPreference,
    };
  }
}
