class MyBedsResponse {
  final bool success;
  final int count;
  final int total;
  final int page;
  final int pages;
  final BedStats stats;
  final List<BedData> data;

  MyBedsResponse({
    required this.success,
    required this.count,
    required this.total,
    required this.page,
    required this.pages,
    required this.stats,
    required this.data,
  });

  factory MyBedsResponse.fromJson(Map<String, dynamic> json) {
    return MyBedsResponse(
      success: json['success'],
      count: json['count'],
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      stats: BedStats.fromJson(json['stats']),
      data: List<BedData>.from(
        json['data'].map((x) => BedData.fromJson(x)),
      ),
    );
  }
}

class BedStats {
  final int total;
  final int available;
  final int occupied;
  final int reserved;
  final int maintenance;
  final int blocked;

  BedStats({
    required this.total,
    required this.available,
    required this.occupied,
    required this.reserved,
    required this.maintenance,
    required this.blocked,
  });

  factory BedStats.fromJson(Map<String, dynamic> json) {
    return BedStats(
      total: json['total'],
      available: json['available'],
      occupied: json['occupied'],
      reserved: json['reserved'],
      maintenance: json['maintenance'],
      blocked: json['blocked'],
    );
  }
}

class BedData {
  final String id;
  final String bedNumber;
  final String bedType;
  final String status;
  final String availableFrom;
  final String condition;
  final bool isActive;
  final Room room;
  final Property property;

  BedData({
    required this.id,
    required this.bedNumber,
    required this.bedType,
    required this.status,
    required this.availableFrom,
    required this.condition,
    required this.isActive,
    required this.room,
    required this.property,
  });

  factory BedData.fromJson(Map<String, dynamic> json) {
    return BedData(
      id: json['_id'],
      bedNumber: json['bedNumber'],
      bedType: json['bedType'],
      status: json['status'],
      availableFrom: json['availableFrom'],
      condition: json['condition'],
      isActive: json['isActive'],
      room: Room.fromJson(json['roomId']),
      property: Property.fromJson(json['propertyId']),
    );
  }
}

class Room {
  final String id;
  final String roomNumber;
  final String roomType;

  Room({
    required this.id,
    required this.roomNumber,
    required this.roomType,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
    );
  }
}

class Property {
  final String id;
  final String title;
  final String address;
  final String city;
  final String state;

  Property({
    required this.id,
    required this.title,
    required this.address,
    required this.city,
    required this.state,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'],
      title: json['title'],
      address: json['location']['address'],
      city: json['location']['city'],
      state: json['location']['state'],
    );
  }
}
