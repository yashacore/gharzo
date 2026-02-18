class UpdateBedStatusResponse {
  final bool success;
  final String message;
  final UpdatedBedStatus data;

  UpdateBedStatusResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateBedStatusResponse.fromJson(Map<String, dynamic> json) {
    return UpdateBedStatusResponse(
      success: json['success'],
      message: json['message'],
      data: UpdatedBedStatus.fromJson(json['data']),
    );
  }
}

class UpdatedBedStatus {
  final String id;
  final String bedNumber;
  final String bedType;
  final String status;
  final String notes;
  final bool isActive;
  final String roomId;
  final String landlordId;

  UpdatedBedStatus({
    required this.id,
    required this.bedNumber,
    required this.bedType,
    required this.status,
    required this.notes,
    required this.isActive,
    required this.roomId,
    required this.landlordId,
  });

  factory UpdatedBedStatus.fromJson(Map<String, dynamic> json) {
    return UpdatedBedStatus(
      id: json['_id'],
      bedNumber: json['bedNumber'],
      bedType: json['bedType'],
      status: json['status'],
      notes: json['notes'],
      isActive: json['isActive'],
      roomId: json['roomId'],
      landlordId: json['landlordId'],
    );
  }
}
