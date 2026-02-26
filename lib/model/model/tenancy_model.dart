class TenancyModel {
  final String id;
  final String status;
  final DateTime createdAt;

  final TenantInfo tenant;
  final PropertyInfo property;
  final RoomInfo room;

  final Agreement agreement;
  final Financials financials;

  TenancyModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.tenant,
    required this.property,
    required this.room,
    required this.agreement,
    required this.financials,
  });

  factory TenancyModel.fromJson(Map<String, dynamic> json) {
    return TenancyModel(
      id: json['_id'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      tenant: TenantInfo.fromJson(json['tenantId'] ?? {}),
      property: PropertyInfo.fromJson(json['propertyId'] ?? {}),
      room: RoomInfo.fromJson(json['roomId'] ?? {}),
      agreement: Agreement.fromJson(json['agreement'] ?? {}),
      financials: Financials.fromJson(json['financials'] ?? {}),
    );
  }
}

class TenantInfo {
  final String name;
  final String phone;

  TenantInfo({required this.name, required this.phone});

  factory TenantInfo.fromJson(Map<String, dynamic> json) {
    return TenantInfo(name: json['name'] ?? '', phone: json['phone'] ?? '');
  }
}

class PropertyInfo {
  final String id;
  final String title;
  final String city;

  PropertyInfo({required this.id, required this.title, required this.city});

  factory PropertyInfo.fromJson(Map<String, dynamic> json) {
    return PropertyInfo(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      city: json['location']?['city'] ?? '',
    );
  }
}

class RoomInfo {
  final String roomNumber;
  final String roomType;

  RoomInfo({required this.roomNumber, required this.roomType});

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    return RoomInfo(
      roomNumber: json['roomNumber'] ?? '',
      roomType: json['roomType'] ?? '',
    );
  }
}

class Agreement {
  final DateTime startDate;
  final DateTime endDate;
  final int durationMonths;

  Agreement({
    required this.startDate,
    required this.endDate,
    required this.durationMonths,
  });

  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      durationMonths: json['durationMonths'] ?? 0,
    );
  }
}

class Financials {
  final int monthlyRent;
  final int securityDeposit;

  Financials({required this.monthlyRent, required this.securityDeposit});

  factory Financials.fromJson(Map<String, dynamic> json) {
    return Financials(
      monthlyRent: json['monthlyRent'] ?? 0,
      securityDeposit: json['securityDeposit'] ?? 0,
    );
  }
}
