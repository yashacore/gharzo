class TenantUserModel {
  final String id;
  final String name;
  final String phone;
  final String role;

  TenantUserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
  });

  factory TenantUserModel.fromJson(Map<String, dynamic> json) {
    return TenantUserModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "tenant",
    );
  }
}




class TenantLoginRequest {
  final String phone;

  TenantLoginRequest({required this.phone});

  Map<String, dynamic> toJson() => {
    "phone": phone,
  };
}


class TenantOtpRequest {
  final String phone;
  final String otp;

  TenantOtpRequest({
    required this.phone,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "otp": otp,
  };
}


class TenantLoginResponse {
  final bool success;
  final String message;
  final TenantUserModel? user;
  final String? token;

  TenantLoginResponse({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });

  factory TenantLoginResponse.fromJson(Map<String, dynamic> json) {
    return TenantLoginResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      user:
      json["data"] != null ? TenantUserModel.fromJson(json["data"]) : null,
      token: json["token"],
    );
  }
}
