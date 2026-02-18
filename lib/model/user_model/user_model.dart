class UserModel {
  String? name;
  String? phone;
  String? email;
  String? image;
  Map<String, dynamic>? address;

  UserModel({this.name, this.phone, this.email, this.image, this.address});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      image: json['logo'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'logo': image,
      'address': address,
    };
  }
}
