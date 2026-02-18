class RoomDetailModel {
  Price? price;
  Area? area;
  PgDetails? pgDetails;
  LandlordDetails? landlordDetails;
  RoomStats? roomStats;
  Furnishing? furnishing;
  Parking? parking;
  Floor? floor;
  Amenities? amenities;
  Location? location;
  Ownership? ownership;
  ContactInfo? contactInfo;
  Stats? stats;
  Boost? boost;
  String? id;
  String? category;
  String? propertyType;
  String? listingType;
  bool? isRentalManagement;
  int? bathrooms;
  int? balconies;
  String? status;
  String? verificationStatus;
  bool? isFeatured;
  bool? isPremium;
  OwnerId? ownerId;
  String? postedBy;
  int? completionPercentage;
  List<String>? completedSteps;
  List<PropertyImage>? images;
  List<dynamic>? videos;
  List<dynamic>? floorPlan;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? availableFrom;
  int? bhk;
  String? description;
  String? propertyAge;
  String? slug;
  String? title;
  List<dynamic>? amenitiesList;
  String? publishedAt;

  RoomDetailModel({
    this.price,
    this.area,
    this.pgDetails,
    this.landlordDetails,
    this.roomStats,
    this.furnishing,
    this.parking,
    this.floor,
    this.amenities,
    this.location,
    this.ownership,
    this.contactInfo,
    this.stats,
    this.boost,
    this.id,
    this.category,
    this.propertyType,
    this.listingType,
    this.isRentalManagement,
    this.bathrooms,
    this.balconies,
    this.status,
    this.verificationStatus,
    this.isFeatured,
    this.isPremium,
    this.ownerId,
    this.postedBy,
    this.completionPercentage,
    this.completedSteps,
    this.images,
    this.videos,
    this.floorPlan,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.availableFrom,
    this.bhk,
    this.description,
    this.propertyAge,
    this.slug,
    this.title,
    this.amenitiesList,
    this.publishedAt,
  });

  factory RoomDetailModel.fromJson(Map<String, dynamic> json) {
    return RoomDetailModel(
      price: json['price'] != null ? Price.fromJson(json['price']) : null,
      area: json['area'] != null ? Area.fromJson(json['area']) : null,
      pgDetails:
      json['pgDetails'] != null ? PgDetails.fromJson(json['pgDetails']) : null,
      landlordDetails: json['landlordDetails'] != null
          ? LandlordDetails.fromJson(json['landlordDetails'])
          : null,
      roomStats:
      json['roomStats'] != null ? RoomStats.fromJson(json['roomStats']) : null,
      furnishing:
      json['furnishing'] != null ? Furnishing.fromJson(json['furnishing']) : null,
      parking: json['parking'] != null ? Parking.fromJson(json['parking']) : null,
      floor: json['floor'] != null ? Floor.fromJson(json['floor']) : null,
      amenities:
      json['amenities'] != null ? Amenities.fromJson(json['amenities']) : null,
      location:
      json['location'] != null ? Location.fromJson(json['location']) : null,
      ownership:
      json['ownership'] != null ? Ownership.fromJson(json['ownership']) : null,
      contactInfo:
      json['contactInfo'] != null ? ContactInfo.fromJson(json['contactInfo']) : null,
      stats: json['stats'] != null ? Stats.fromJson(json['stats']) : null,
      boost: json['boost'] != null ? Boost.fromJson(json['boost']) : null,
      id: json['_id'],
      category: json['category'],
      propertyType: json['propertyType'],
      listingType: json['listingType'],
      isRentalManagement: json['isRentalManagement'],
      bathrooms: json['bathrooms'],
      balconies: json['balconies'],
      status: json['status'],
      verificationStatus: json['verificationStatus'],
      isFeatured: json['isFeatured'],
      isPremium: json['isPremium'],
      ownerId:
      json['ownerId'] != null ? OwnerId.fromJson(json['ownerId']) : null,
      postedBy: json['postedBy'],
      completionPercentage: json['completionPercentage'],
      completedSteps:
      json['completedSteps'] != null ? List<String>.from(json['completedSteps']) : [],
      images: json['images'] != null
          ? (json['images'] as List).map((e) => PropertyImage.fromJson(e)).toList()
          : [],
      videos: json['videos'] ?? [],
      floorPlan: json['floorPlan'] ?? [],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      availableFrom: json['availableFrom'],
      bhk: json['bhk'],
      description: json['description'],
      propertyAge: json['propertyAge'],
      slug: json['slug'],
      title: json['title'],
      amenitiesList: json['amenitiesList'] ?? [],
      publishedAt: json['publishedAt'],
    );
  }
}

/* ---------------- SUB MODELS ---------------- */

class Price {
  int? amount;
  String? per;
  bool? negotiable;
  int? pricePerSqft;
  int? securityDeposit;

  Price({
    this.amount,
    this.per,
    this.negotiable,
    this.pricePerSqft,
    this.securityDeposit,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      amount: json['amount'],
      per: json['per'],
      negotiable: json['negotiable'],
      pricePerSqft: json['pricePerSqft'],
      securityDeposit: json['securityDeposit'],
    );
  }
}

class Area {
  int? carpet;
  int? builtUp;
  String? unit;

  Area({this.carpet, this.builtUp, this.unit});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      carpet: json['carpet'],
      builtUp: json['builtUp'],
      unit: json['unit'],
    );
  }
}

class PgDetails {
  List<dynamic>? rules;
  List<dynamic>? commonAreas;

  PgDetails({this.rules, this.commonAreas});

  factory PgDetails.fromJson(Map<String, dynamic> json) {
    return PgDetails(
      rules: json['rules'] ?? [],
      commonAreas: json['commonAreas'] ?? [],
    );
  }
}

class LandlordDetails {
  String? preferredPaymentMethod;

  LandlordDetails({this.preferredPaymentMethod});

  factory LandlordDetails.fromJson(Map<String, dynamic> json) {
    return LandlordDetails(
      preferredPaymentMethod: json['preferredPaymentMethod'],
    );
  }
}

class RoomStats {
  int? totalRooms;
  int? occupiedRooms;
  int? availableRooms;

  RoomStats({this.totalRooms, this.occupiedRooms, this.availableRooms});

  factory RoomStats.fromJson(Map<String, dynamic> json) {
    return RoomStats(
      totalRooms: json['totalRooms'],
      occupiedRooms: json['occupiedRooms'],
      availableRooms: json['availableRooms'],
    );
  }
}

class Furnishing {
  List<dynamic>? items;
  String? type;

  Furnishing({this.items, this.type});

  factory Furnishing.fromJson(Map<String, dynamic> json) {
    return Furnishing(
      items: json['items'] ?? [],
      type: json['type'],
    );
  }
}

class Parking {
  int? covered;
  int? open;

  Parking({this.covered, this.open});

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      covered: json['covered'],
      open: json['open'],
    );
  }
}

class Floor {
  int? current;
  int? total;

  Floor({this.current, this.total});

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      current: json['current'],
      total: json['total'],
    );
  }
}

class Amenities {
  List<dynamic>? basic;
  List<dynamic>? society;
  List<dynamic>? nearby;

  Amenities({this.basic, this.society, this.nearby});

  factory Amenities.fromJson(Map<String, dynamic> json) {
    return Amenities(
      basic: json['basic'] ?? [],
      society: json['society'] ?? [],
      nearby: json['nearby'] ?? [],
    );
  }
}

class Location {
  Coordinates? coordinates;
  String? address;
  String? city;
  String? locality;
  String? subLocality;
  String? landmark;
  String? pincode;
  String? state;

  Location({
    this.coordinates,
    this.address,
    this.city,
    this.locality,
    this.subLocality,
    this.landmark,
    this.pincode,
    this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      address: json['address'],
      city: json['city'],
      locality: json['locality'],
      subLocality: json['subLocality'],
      landmark: json['landmark'],
      pincode: json['pincode'],
      state: json['state'],
    );
  }
}

class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}

class Ownership {
  bool? verified;

  Ownership({this.verified});

  factory Ownership.fromJson(Map<String, dynamic> json) {
    return Ownership(
      verified: json['verified'],
    );
  }
}

class ContactInfo {
  String? name;
  String? phone;
  String? alternatePhone;
  String? email;
  String? preferredCallTime;

  ContactInfo({
    this.name,
    this.phone,
    this.alternatePhone,
    this.email,
    this.preferredCallTime,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      name: json['name'],
      phone: json['phone'],
      alternatePhone: json['alternatePhone'],
      email: json['email'],
      preferredCallTime: json['preferredCallTime'],
    );
  }
}

class Stats {
  int? views;
  int? uniqueViews;
  int? enquiries;
  int? shortlists;
  int? shares;
  String? lastViewedAt;

  Stats({
    this.views,
    this.uniqueViews,
    this.enquiries,
    this.shortlists,
    this.shares,
    this.lastViewedAt,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      views: json['views'],
      uniqueViews: json['uniqueViews'],
      enquiries: json['enquiries'],
      shortlists: json['shortlists'],
      shares: json['shares'],
      lastViewedAt: json['lastViewedAt'],
    );
  }
}

class Boost {
  bool? isActive;

  Boost({this.isActive});

  factory Boost.fromJson(Map<String, dynamic> json) {
    return Boost(
      isActive: json['isActive'],
    );
  }
}

class OwnerId {
  String? id;
  String? name;
  String? phone;

  OwnerId({this.id, this.name, this.phone});

  factory OwnerId.fromJson(Map<String, dynamic> json) {
    return OwnerId(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class PropertyImage {
  String? url;
  String? key;
  bool? isPrimary;
  String? id;
  String? uploadedAt;

  PropertyImage({
    this.url,
    this.key,
    this.isPrimary,
    this.id,
    this.uploadedAt,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      url: json['url'],
      key: json['key'],
      isPrimary: json['isPrimary'],
      id: json['_id'],
      uploadedAt: json['uploadedAt'],
    );
  }
}
