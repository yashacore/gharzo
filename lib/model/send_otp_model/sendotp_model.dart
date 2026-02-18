class SendOtpModel {
  final bool success;
  final String? message;
  final SendOtpData? data;

  SendOtpModel({
    required this.success,
    this.message,
    this.data,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) {
    return SendOtpModel(
      success: json['success'] ?? false,
      message: json['message'],
      data:
      json['data'] != null ? SendOtpData.fromJson(json['data']) : null,
    );
  }
}


class SendOtpData {
  final String? phone;
  final String? purpose;
  final int? expiresIn;
  final String? otp;

  SendOtpData({
    this.phone,
    this.purpose,
    this.expiresIn,
    this.otp,
  });

  factory SendOtpData.fromJson(Map<String, dynamic> json) {
    return SendOtpData(
      phone: json['phone'],
      purpose: json['purpose'],
      expiresIn: json['expiresIn'],
      otp: json['otp'],
    );
  }
}
