class ReelSaveResponse {
  final bool success;
  final String message;
  final Data? data;

  ReelSaveResponse({required this.success, required this.message, this.data});

  factory ReelSaveResponse.fromJson(Map<String, dynamic> json) {
    return ReelSaveResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  final String reelId;
  final bool isSaved;
  final int savedCount;

  Data({required this.reelId, required this.isSaved, required this.savedCount});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      reelId: json['reelId'],
      isSaved: json['isSaved'],
      savedCount: json['savedCount'],
    );
  }
}
