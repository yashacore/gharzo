
import 'package:gharzo_project/model/user_model/user_model.dart';

class UpdateProfileResponse {
  final bool success;
  final String message;
  final UserModel? data;

  UpdateProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? UserModel.fromJson(json['data'])
          : null,
    );
  }
}
