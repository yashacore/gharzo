class UserProfileResponse {
  final User user;
  final dynamic subscription;

  UserProfileResponse({required this.user, this.subscription});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      user: User.fromJson(json['data']['user']),
      subscription: json['data']['subscription'],
    );
  }
}

class User {
  final String id;
  final String name;
  final String phone;
  final String role;
  final bool isVerified;
  final bool isActive;
  final String? profileImage;
  final DateTime lastLogin;

  /// ✅ THIS WAS MISSING / NOT MATCHING
  final Address address;

  final List<FcmToken> fcmTokens;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.profileImage,
    required this.lastLogin,
    required this.address,
    required this.fcmTokens,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? false,
      profileImage: json['profileImage'],
      lastLogin: DateTime.parse(json['lastLogin']),
      address: Address.fromJson(json['address'] ?? {}),
      fcmTokens: (json['fcmTokens'] as List? ?? [])
          .map((e) => FcmToken.fromJson(e))
          .toList(),
    );
  }
}

class Address {
  final String city;
  final String state;
  final String pincode;

  Address({required this.city, required this.state, required this.pincode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }
}

class FcmToken {
  final String? token;
  final String device;
  final String id;
  final DateTime createdAt;

  FcmToken({
    this.token,
    required this.device,
    required this.id,
    required this.createdAt,
  });

  factory FcmToken.fromJson(Map<String, dynamic> json) {
    return FcmToken(
      token: json['token'],
      device: json['device'] ?? '',
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
