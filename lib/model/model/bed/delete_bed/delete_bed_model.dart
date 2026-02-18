class DeleteBedResponse {
  final bool success;
  final String message;

  DeleteBedResponse({
    required this.success,
    required this.message,
  });

  factory DeleteBedResponse.fromJson(Map<String, dynamic> json) {
    return DeleteBedResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}
