class BedModel {
  final String id;
  final String bedNumber;
  final String bedType;
  final String status;
  final bool isActive;
  final DateTime availableFrom;
  final int rent;
  final int securityDeposit;
  final int maintenanceCharges;

  BedModel({
    required this.id,
    required this.bedNumber,
    required this.bedType,
    required this.status,
    required this.isActive,
    required this.availableFrom,
    required this.rent,
    required this.securityDeposit,
    required this.maintenanceCharges,
  });

  factory BedModel.fromJson(Map<String, dynamic> json) {
    return BedModel(
      id: json['_id'],
      bedNumber: json['bedNumber'],
      bedType: json['bedType'],
      status: json['status'],
      isActive: json['isActive'],
      availableFrom: DateTime.parse(json['availableFrom']),
      rent: json['pricing']['rent'],
      securityDeposit: json['pricing']['securityDeposit'],
      maintenanceCharges: json['pricing']['maintenanceCharges'],
    );
  }
}