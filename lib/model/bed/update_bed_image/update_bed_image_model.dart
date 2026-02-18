class UpdateBedImagesResponse {
  final bool success;
  final String message;
  final UpdatedBedImages data;

  UpdateBedImagesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateBedImagesResponse.fromJson(Map<String, dynamic> json) {
    return UpdateBedImagesResponse(
      success: json['success'],
      message: json['message'],
      data: UpdatedBedImages.fromJson(json['data']),
    );
  }
}

class UpdatedBedImages {
  final String id;
  final String bedNumber;
  final String bedType;
  final String status;
  final bool isActive;
  final String condition;
  final String notes;
  final String roomId;
  final String landlordId;
  final Pricing pricing;
  final BedFeatures features;

  UpdatedBedImages({
    required this.id,
    required this.bedNumber,
    required this.bedType,
    required this.status,
    required this.isActive,
    required this.condition,
    required this.notes,
    required this.roomId,
    required this.landlordId,
    required this.pricing,
    required this.features,
  });

  factory UpdatedBedImages.fromJson(Map<String, dynamic> json) {
    return UpdatedBedImages(
      id: json['_id'],
      bedNumber: json['bedNumber'],
      bedType: json['bedType'],
      status: json['status'],
      isActive: json['isActive'],
      condition: json['condition'],
      notes: json['notes'],
      roomId: json['roomId'],
      landlordId: json['landlordId'],
      pricing: Pricing.fromJson(json['pricing']),
      features: BedFeatures.fromJson(json['features']),
    );
  }
}

/* ---------- Shared Models ---------- */

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

class BedFeatures {
  final bool hasAC;
  final bool hasAttachedBathroom;
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

  BedFeatures({
    required this.hasAC,
    required this.hasAttachedBathroom,
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

  factory BedFeatures.fromJson(Map<String, dynamic> json) {
    return BedFeatures(
      hasAC: json['hasAC'],
      hasAttachedBathroom: json['hasAttachedBathroom'],
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
