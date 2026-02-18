class UpdateBedResponse {
  final bool success;
  final String message;
  final UpdatedBed data;

  UpdateBedResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateBedResponse.fromJson(Map<String, dynamic> json) {
    return UpdateBedResponse(
      success: json['success'],
      message: json['message'],
      data: UpdatedBed.fromJson(json['data']),
    );
  }
}

class UpdatedBed {
  final String id;
  final String bedNumber;
  final String bedType;
  final String status;
  final bool isActive;
  final String condition;
  final String notes;
  final String availableFrom;
  final String roomId;
  final String landlordId;
  final Pricing pricing;
  final BedFeatures features;

  UpdatedBed({
    required this.id,
    required this.bedNumber,
    required this.bedType,
    required this.status,
    required this.isActive,
    required this.condition,
    required this.notes,
    required this.availableFrom,
    required this.roomId,
    required this.landlordId,
    required this.pricing,
    required this.features,
  });

  factory UpdatedBed.fromJson(Map<String, dynamic> json) {
    return UpdatedBed(
      id: json['_id'],
      bedNumber: json['bedNumber'],
      bedType: json['bedType'],
      status: json['status'],
      isActive: json['isActive'],
      condition: json['condition'],
      notes: json['notes'],
      availableFrom: json['availableFrom'],
      roomId: json['roomId'],
      landlordId: json['landlordId'],
      pricing: Pricing.fromJson(json['pricing']),
      features: BedFeatures.fromJson(json['features']),
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

  Map<String, dynamic> toJson() => {
    "rent": rent,
    "securityDeposit": securityDeposit,
    "maintenanceCharges": maintenanceCharges,
  };
}

class BedFeatures {
  final bool hasAC;
  final bool hasAttachedBathroom;
  final bool hasLocker;
  final bool hasStudyTable;
  final bool hasWardrobe;

  BedFeatures({
    required this.hasAC,
    required this.hasAttachedBathroom,
    required this.hasLocker,
    required this.hasStudyTable,
    required this.hasWardrobe,
  });

  factory BedFeatures.fromJson(Map<String, dynamic> json) {
    return BedFeatures(
      hasAC: json['hasAC'],
      hasAttachedBathroom: json['hasAttachedBathroom'],
      hasLocker: json['hasLocker'],
      hasStudyTable: json['hasStudyTable'],
      hasWardrobe: json['hasWardrobe'],
    );
  }

  Map<String, dynamic> toJson() => {
    "hasAC": hasAC,
    "hasAttachedBathroom": hasAttachedBathroom,
    "hasLocker": hasLocker,
    "hasStudyTable": hasStudyTable,
    "hasWardrobe": hasWardrobe,
  };
}
