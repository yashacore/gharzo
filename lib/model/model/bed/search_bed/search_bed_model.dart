class SearchBedsResponse {
  final bool success;
  final int count;
  final int total;
  final int page;
  final int pages;
  final List<BedSearchItem> data;

  SearchBedsResponse({
    required this.success,
    required this.count,
    required this.total,
    required this.page,
    required this.pages,
    required this.data,
  });

  factory SearchBedsResponse.fromJson(Map<String, dynamic> json) {
    return SearchBedsResponse(
      success: json['success'],
      count: json['count'],
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      data:
      (json['data'] as List).map((e) => BedSearchItem.fromJson(e)).toList(),
    );
  }
}

// ---------------- BED ITEM ----------------

class BedSearchItem {
  final String id;
  final String bedNumber;
  final String bedType;
  final String status;
  final bool isActive;
  final String condition;
  final String? notes;
  final DateTime availableFrom;
  final Pricing pricing;
  final BedFeatures features;
  final RoomInfo room;
  final PropertyInfo property;
  final LandlordInfo landlord;
  final List<BedImage> images;

  BedSearchItem({
    required this.id,
    required this.bedNumber,
    required this.bedType,
    required this.status,
    required this.isActive,
    required this.condition,
    this.notes,
    required this.availableFrom,
    required this.pricing,
    required this.features,
    required this.room,
    required this.property,
    required this.landlord,
    required this.images,
  });

  factory BedSearchItem.fromJson(Map<String, dynamic> json) {
    return BedSearchItem(
      id: json['_id'],
      bedNumber: json['bedNumber'],
      bedType: json['bedType'],
      status: json['status'],
      isActive: json['isActive'],
      condition: json['condition'],
      notes: json['notes'],
      availableFrom: DateTime.parse(json['availableFrom']),
      pricing: Pricing.fromJson(json['pricing']),
      features: BedFeatures.fromJson(json['features']),
      room: RoomInfo.fromJson(json['roomId']),
      property: PropertyInfo.fromJson(json['propertyId']),
      landlord: LandlordInfo.fromJson(json['landlordId']),
      images: (json['images'] as List? ?? [])
          .map((e) => BedImage.fromJson(e))
          .toList(),
    );
  }
}

// ---------------- SUB MODELS ----------------

class Pricing {
  final int rent;
  final int securityDeposit;
  final int maintenanceCharges;

  Pricing({
    required this.rent,
    required this.securityDeposit,
    required this.maintenanceCharges,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      rent: json['rent'],
      securityDeposit: json['securityDeposit'],
      maintenanceCharges: json['maintenanceCharges'],
    );
  }
}

class BedFeatures {
  final bool hasAC;
  final bool hasLocker;
  final bool hasStudyTable;
  final bool hasAttachedBathroom;
  final bool hasBalcony;
  final bool hasFan;
  final bool hasLight;
  final bool hasChair;
  final bool hasWardrobe;
  final bool hasMattress;
  final bool hasPillow;
  final bool hasBedsheet;

  BedFeatures({
    required this.hasAC,
    required this.hasLocker,
    required this.hasStudyTable,
    required this.hasAttachedBathroom,
    required this.hasBalcony,
    required this.hasFan,
    required this.hasLight,
    required this.hasChair,
    required this.hasWardrobe,
    required this.hasMattress,
    required this.hasPillow,
    required this.hasBedsheet,
  });

  factory BedFeatures.fromJson(Map<String, dynamic> json) {
    return BedFeatures(
      hasAC: json['hasAC'] ?? false,
      hasLocker: json['hasLocker'] ?? false,
      hasStudyTable: json['hasStudyTable'] ?? false,
      hasAttachedBathroom: json['hasAttachedBathroom'] ?? false,
      hasBalcony: json['hasBalcony'] ?? false,
      hasFan: json['hasFan'] ?? false,
      hasLight: json['hasLight'] ?? false,
      hasChair: json['hasChair'] ?? false,
      hasWardrobe: json['hasWardrobe'] ?? false,
      hasMattress: json['hasMattress'] ?? false,
      hasPillow: json['hasPillow'] ?? false,
      hasBedsheet: json['hasBedsheet'] ?? false,
    );
  }
}

class RoomInfo {
  final String id;
  final String roomNumber;
  final String roomType;
  final int? floor;

  RoomInfo({
    required this.id,
    required this.roomNumber,
    required this.roomType,
    this.floor,
  });

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    return RoomInfo(
      id: json['_id'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      floor: json['floor'],
    );
  }
}

class PropertyInfo {
  final String id;
  final String title;
  final PropertyLocation location;
  final List<String> amenitiesList;
  final List<PropertyImage> images;

  PropertyInfo({
    required this.id,
    required this.title,
    required this.location,
    required this.amenitiesList,
    required this.images,
  });

  factory PropertyInfo.fromJson(Map<String, dynamic> json) {
    return PropertyInfo(
      id: json['_id'],
      title: json['title'],
      location: PropertyLocation.fromJson(json['location']),
      amenitiesList:
      (json['amenitiesList'] as List? ?? []).map((e) => e.toString()).toList(),
      images: (json['images'] as List? ?? [])
          .map((e) => PropertyImage.fromJson(e))
          .toList(),
    );
  }
}

class PropertyLocation {
  final String address;
  final String city;
  final String locality;
  final String subLocality;
  final String landmark;
  final String pincode;
  final String state;
  final double? latitude;
  final double? longitude;

  PropertyLocation({
    required this.address,
    required this.city,
    required this.locality,
    required this.subLocality,
    required this.landmark,
    required this.pincode,
    required this.state,
    this.latitude,
    this.longitude,
  });

  factory PropertyLocation.fromJson(Map<String, dynamic> json) {
    return PropertyLocation(
      address: json['address'],
      city: json['city'],
      locality: json['locality'],
      subLocality: json['subLocality'],
      landmark: json['landmark'],
      pincode: json['pincode'],
      state: json['state'],
      latitude: json['coordinates']?['latitude']?.toDouble(),
      longitude: json['coordinates']?['longitude']?.toDouble(),
    );
  }
}

class LandlordInfo {
  final String id;
  final String name;
  final String phone;

  LandlordInfo({
    required this.id,
    required this.name,
    required this.phone,
  });

  factory LandlordInfo.fromJson(Map<String, dynamic> json) {
    return LandlordInfo(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class BedImage {
  final String id;
  final String url;
  final bool isPrimary;

  BedImage({
    required this.id,
    required this.url,
    required this.isPrimary,
  });

  factory BedImage.fromJson(Map<String, dynamic> json) {
    return BedImage(
      id: json['_id'],
      url: json['url'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}

class PropertyImage {
  final String id;
  final String url;
  final bool isPrimary;

  PropertyImage({
    required this.id,
    required this.url,
    required this.isPrimary,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['_id'],
      url: json['url'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}
