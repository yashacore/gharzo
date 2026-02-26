class LoginModel {
  final bool success;
  final String message;
  LoginData? data;

  LoginModel({required this.success, required this.message, this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class LoginData {
  final User user;
  final String token;
  final bool isNewUser;

  LoginData({required this.user, required this.token, required this.isNewUser});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json['user']),
      token: json['token'],
      isNewUser: json['isNewUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token, 'isNewUser': isNewUser};
  }
}

class User {
  final String id;
  final String name;
  final String phone;
  final String role;
  final bool isVerified;
  final bool isActive;
  final ProfileImage? profileImage; // ✅ FIXED
  final DateTime lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.isVerified,
    required this.isActive,
    this.profileImage,
    required this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      isVerified: json['isVerified'],
      isActive: json['isActive'],
      profileImage: json['profileImage'] != null
          ? ProfileImage.fromJson(json['profileImage'])
          : null,
      lastLogin: DateTime.parse(json['lastLogin']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      'isActive': isActive,
      'profileImage': profileImage?.toJson(),
      'lastLogin': lastLogin.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}


class ProfileImage {
  final String? url;
  final String? key;
  final DateTime? uploadedAt;

  ProfileImage({
    this.url,
    this.key,
    this.uploadedAt,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      url: json['url'],
      key: json['key'],
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'uploadedAt': uploadedAt?.toIso8601String(),
    };
  }
}