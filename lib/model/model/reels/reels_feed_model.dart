
class ReelModel {
  bool success;
  int count;
  int total;
  int totalPages;
  int currentPage;
  List<ReelData> data;

  ReelModel({
    required this.success,
    required this.count,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.data,
  });

  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      success: json['success'],
      count: json['count'],
      total: json['total'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      data: (json['data'] as List)
          .map((e) => ReelData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'total': total,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ReelData {
  String id;
  Property property;
  UploadedBy uploadedBy;
  String videoUrl;
  String videoKey;
  String? caption;
  List<String>? tags;
  int duration;
  int views;
  int likes;
  int saves;
  int shares;
  int comments;

  ReelData({
    required this.id,
    required this.property,
    required this.uploadedBy,
    required this.videoUrl,
    required this.videoKey,
    this.caption,
    this.tags,
    required this.duration,
    required this.views,
    required this.likes,
    required this.saves,
    required this.shares,
    required this.comments,
  });

  factory ReelData.fromJson(Map<String, dynamic> json) {
    return ReelData(
      id: json['_id'],
      property: Property.fromJson(json['propertyId']),
      uploadedBy: UploadedBy.fromJson(json['uploadedBy']),
      videoUrl: json['videoUrl'],
      videoKey: json['videoKey'],
      caption: json['caption'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      duration: json['duration'],
      views: json['views'],
      likes: json['likes'],
      saves: json['saves'],
      shares: json['shares'],
      comments: json['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'propertyId': property.toJson(),
      'uploadedBy': uploadedBy.toJson(),
      'videoUrl': videoUrl,
      'videoKey': videoKey,
      'caption': caption,
      'tags': tags,
      'duration': duration,
      'views': views,
      'likes': likes,
      'saves': saves,
      'shares': shares,
      'comments': comments,
    };
  }
}

class Property {
  String id;
  String listingType;
  Price price;
  String title;
  Location location;
  List<PropertyImage> images;

  Property({
    required this.id,
    required this.listingType,
    required this.price,
    required this.title,
    required this.location,
    required this.images,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'],
      listingType: json['listingType'],
      price: Price.fromJson(json['price']),
      title: json['title'],
      location: Location.fromJson(json['location']),
      images: (json['images'] as List)
          .map((e) => PropertyImage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'listingType': listingType,
      'price': price.toJson(),
      'title': title,
      'location': location.toJson(),
      'images': images.map((e) => e.toJson()).toList(),
    };
  }
}

class Price {
  int amount;
  String per;
  bool negotiable;
  int pricePerSqft;
  int securityDeposit;

  Price({
    required this.amount,
    required this.per,
    required this.negotiable,
    required this.pricePerSqft,
    required this.securityDeposit,
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

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'per': per,
      'negotiable': negotiable,
      'pricePerSqft': pricePerSqft,
      'securityDeposit': securityDeposit,
    };
  }
}

class PropertyImage {
  String url;
  bool isPrimary;

  PropertyImage({required this.url, required this.isPrimary});

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      url: json['url'],
      isPrimary: json['isPrimary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'isPrimary': isPrimary,
    };
  }
}

class Location {
  String city;
  String locality;
  String address;

  Location({required this.city, required this.locality, required this.address});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      locality: json['locality'],
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'locality': locality,
      'address': address,
    };
  }
}

class UploadedBy {
  String id;
  String name;

  UploadedBy({required this.id, required this.name});

  factory UploadedBy.fromJson(Map<String, dynamic> json) {
    return UploadedBy(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}


class PropertyLocation {
  final String city;
  final String locality;

  PropertyLocation({
    required this.city,
    required this.locality,
  });

  factory PropertyLocation.fromJson(Map<String, dynamic> json) {
    return PropertyLocation(
      city: json['city'],
      locality: json['locality'],
    );
  }
}

class ReelLocation {
  final String city;
  final String locality;

  ReelLocation({
    required this.city,
    required this.locality,
  });

  factory ReelLocation.fromJson(Map<String, dynamic> json) {
    return ReelLocation(
      city: json['city'],
      locality: json['locality'],
    );
  }
}
