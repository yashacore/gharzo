class DeleteRoomResponseModel {
  bool success;
  String message;

  DeleteRoomResponseModel({
    required this.success,
    required this.message,
  });

  factory DeleteRoomResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteRoomResponseModel(
      success: json['success'],
      message: json['message'] ?? '',
    );
  }
}
