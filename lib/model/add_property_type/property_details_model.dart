// class PropertyDetailModel {
//   final String id;
//   final String title;
//   final String description;
//   final String propertyType; // ✅ NEW
//   final String category; // optional (Residential / Commercial)
//
//   final int bhk;
//   final int bathrooms;
//   final int balconies;
//
//   final int price;
//   final bool negotiable;
//   final int maintenance;
//   final int securityDeposit;
//
//   final int carpetArea;
//   final int builtUpArea;
//   final String areaUnit;
//
//   final int currentFloor;
//   final int totalFloors;
//
//   final String propertyAge;
//   final String availableFrom;
//
//   final String city;
//   final String locality;
//   final String address;
//   final double latitude;
//   final double longitude;
//
//   final String pricePer;
//
//   PropertyDetailModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.propertyType,
//     required this.category,
//     required this.bhk,
//     required this.bathrooms,
//     required this.balconies,
//     required this.price,
//     required this.negotiable,
//     required this.maintenance,
//     required this.securityDeposit,
//     required this.carpetArea,
//     required this.builtUpArea,
//     required this.areaUnit,
//     required this.currentFloor,
//     required this.totalFloors,
//     required this.propertyAge,
//     required this.availableFrom,
//     required this.city,
//     required this.locality,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//     required this.pricePer,
//   });
//
//   factory PropertyDetailModel.fromJson(Map<String, dynamic> json) {
//     final priceJson = json['price'] ?? {};
//     final maintenanceJson = priceJson['maintenanceCharges'] ?? {};
//     final areaJson = json['area'] ?? {};
//     final floorJson = json['floor'] ?? {};
//     final locationJson = json['location'] ?? {};
//     final coordJson = locationJson['coordinates'] ?? {};
//
//     return PropertyDetailModel(
//       id: json['_id']?.toString() ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       propertyType: json['propertyType'] ?? '',
//       category: json['category'] ?? '',
//
//       bhk: json['bhk'] ?? 0,
//       bathrooms: json['bathrooms'] ?? 0,
//       balconies: json['balconies'] ?? 0,
//
//       price: priceJson['amount'] ?? 0,
//       negotiable: priceJson['negotiable'] ?? false,
//       maintenance: maintenanceJson['amount'] ?? 0,
//       securityDeposit: priceJson['securityDeposit'] ?? 0,
//
//       carpetArea: areaJson['carpet'] ?? 0,
//       builtUpArea: areaJson['builtUp'] ?? 0,
//       areaUnit: areaJson['unit'] ?? 'sqft',
//
//       currentFloor: floorJson['current'] ?? 0,
//       totalFloors: floorJson['total'] ?? 0,
//
//       propertyAge: json['propertyAge'] ?? '',
//       availableFrom: json['availableFrom'] ?? '',
//
//       city: locationJson['city'] ?? '',
//       locality: locationJson['locality'] ?? '',
//       address: locationJson['address'] ?? '',
//       latitude: (coordJson['latitude'] ?? 0).toDouble(),
//       longitude: (coordJson['longitude'] ?? 0).toDouble(),
//
//       pricePer: maintenanceJson['frequency'] ?? 'Monthly',
//     );
//   }
// }



class PropertyDetailModel {
  final String id;
  final String title;
  final String description;

  final String propertyType;
  final String category;
  final String listingType;
  final String furnishingType;
  final String facing;

  final int bhk;
  final int bathrooms;
  final int balconies;

  final int price;
  final bool negotiable;
  final String pricePer;
  final int pricePerSqft;
  final int securityDeposit;

  final int carpetArea;
  final int builtUpArea;
  final String areaUnit;

  final int currentFloor;
  final int totalFloors;

  final String propertyAge;
  final String availableFrom;

  final String city;
  final String locality;
  final String subLocality;
  final String landmark;
  final String address;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;

  final List<String> images;

  /// 🔥 NEW: Saved state
  final bool isSaved;

  PropertyDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.propertyType,
    required this.category,
    required this.listingType,
    required this.furnishingType,
    required this.facing,
    required this.bhk,
    required this.bathrooms,
    required this.balconies,
    required this.price,
    required this.negotiable,
    required this.pricePer,
    required this.pricePerSqft,
    required this.securityDeposit,
    required this.carpetArea,
    required this.builtUpArea,
    required this.areaUnit,
    required this.currentFloor,
    required this.totalFloors,
    required this.propertyAge,
    required this.availableFrom,
    required this.city,
    required this.locality,
    required this.subLocality,
    required this.landmark,
    required this.address,
    required this.state,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.isSaved,
  });

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) {
    final priceJson = json['price'] ?? {};
    final areaJson = json['area'] ?? {};
    final floorJson = json['floor'] ?? {};
    final locationJson = json['location'] ?? {};
    final coordJson = locationJson['coordinates'] ?? {};
    final furnishingJson = json['furnishing'] ?? {};

    final imageList = (json['images'] as List? ?? [])
        .map((e) => e['url']?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    return PropertyDetailModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',

      propertyType: json['propertyType']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      listingType: json['listingType']?.toString() ?? '',
      furnishingType: furnishingJson['type']?.toString() ?? '',
      facing: json['facing']?.toString() ?? '',

      bhk: json['bhk'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      balconies: json['balconies'] ?? 0,

      price: priceJson['amount'] ?? 0,
      negotiable: priceJson['negotiable'] ?? false,
      pricePer: priceJson['per']?.toString() ?? '',
      pricePerSqft: priceJson['pricePerSqft'] ?? 0,
      securityDeposit: priceJson['securityDeposit'] ?? 0,

      carpetArea: areaJson['carpet'] ?? 0,
      builtUpArea: areaJson['builtUp'] ?? 0,
      areaUnit: areaJson['unit']?.toString() ?? 'sqft',

      currentFloor: floorJson['current'] ?? 0,
      totalFloors: floorJson['total'] ?? 0,

      propertyAge: json['propertyAge']?.toString() ?? '',
      availableFrom: json['availableFrom']?.toString() ?? '',

      city: locationJson['city']?.toString() ?? '',
      locality: locationJson['locality']?.toString() ?? '',
      subLocality: locationJson['subLocality']?.toString() ?? '',
      landmark: locationJson['landmark']?.toString() ?? '',
      address: locationJson['address']?.toString() ?? '',
      state: locationJson['state']?.toString() ?? '',
      pincode: locationJson['pincode']?.toString() ?? '',
      latitude: (coordJson['latitude'] ?? 0).toDouble(),
      longitude: (coordJson['longitude'] ?? 0).toDouble(),

      images: imageList,

      /// ✅ Safe parsing
      isSaved: json['isSaved'] ?? false,
    );
  }
}

