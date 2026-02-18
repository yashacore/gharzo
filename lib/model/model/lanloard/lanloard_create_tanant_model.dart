class CreateTenancyResponse {
  final bool success;
  final String message;
  final TenancyData data;

  CreateTenancyResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateTenancyResponse.fromJson(Map<String, dynamic> json) {
    return CreateTenancyResponse(
      success: json['success'],
      message: json['message'],
      data: TenancyData.fromJson(json['data']),
    );
  }
}

class TenancyData {
  final Tenancy tenancy;
  final Tenant tenant;

  TenancyData({
    required this.tenancy,
    required this.tenant,
  });

  factory TenancyData.fromJson(Map<String, dynamic> json) {
    return TenancyData(
      tenancy: Tenancy.fromJson(json['tenancy']),
      tenant: Tenant.fromJson(json['tenant']),
    );
  }
}

class Tenancy {
  final String id;
  final String tenantId;
  final String landlordId;
  final String propertyId;
  final String roomId;
  final int bedNumber;
  final String status;

  Tenancy({
    required this.id,
    required this.tenantId,
    required this.landlordId,
    required this.propertyId,
    required this.roomId,
    required this.bedNumber,
    required this.status,
  });

  factory Tenancy.fromJson(Map<String, dynamic> json) {
    return Tenancy(
      id: json['_id'],
      tenantId: json['tenantId'],
      landlordId: json['landlordId'],
      propertyId: json['propertyId'],
      roomId: json['roomId'],
      bedNumber: json['bedNumber'],
      status: json['status'],
    );
  }
}

class Tenant {
  final String id;
  final String name;
  final String phone;
  final String role;

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
