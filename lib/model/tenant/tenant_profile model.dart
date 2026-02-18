class TenantProfileModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;

  TenantProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory TenantProfileModel.fromJson(Map<String, dynamic> json) {
    return TenantProfileModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      address: json["address"] ?? "",
    );
  }
}
