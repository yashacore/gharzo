class UserProfileResponse {
  final User user;
  final dynamic subscription;

  UserProfileResponse({
    required this.user,
    this.subscription,
  });

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

  /// ✅ FIXED
  final String? profileImageUrl;

  /// ✅ FIXED
  final DateTime? lastLogin;

  /// ✅ FIXED
  final Address? address;

  final List<FcmToken> fcmTokens;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.profileImageUrl,
    this.lastLogin,
    this.address,
    required this.fcmTokens,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? false,

      /// 🔥 FIX: read nested object
      profileImageUrl: json['profileImage']?['url'],

      /// 🔥 FIX: null-safe DateTime
      lastLogin: json['lastLogin'] != null
          ? DateTime.tryParse(json['lastLogin'])
          : null,

      /// 🔥 FIX: nullable address
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,

      fcmTokens: (json['fcmTokens'] as List? ?? [])
          .map((e) => FcmToken.fromJson(e))
          .toList(),
    );
  }
}
class Address {
  final String? city;
  final String? state;
  final String? pincode;

  Address({
    this.city,
    this.state,
    this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
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
