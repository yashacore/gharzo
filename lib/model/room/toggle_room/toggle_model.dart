class ToggleRoomStatusRequestModel {
  String status;

  ToggleRoomStatusRequestModel({required this.status});

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
