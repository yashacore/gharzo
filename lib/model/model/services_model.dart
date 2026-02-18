class ServicesResponse {
  final bool success;
  final int count;
  final int total;
  final int page;
  final int pages;
  final List<ServiceCategory> categories;
  final List<ServiceModel> data;

  ServicesResponse({
    required this.success,
    required this.count,
    required this.total,
    required this.page,
    required this.pages,
    required this.categories,
    required this.data,
  });

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      success: json['success'],
      count: json['count'],
      total: json['total'],
      page: json['page'],
      pages: json['pages'],
      categories: (json['categories'] as List)
          .map((e) => ServiceCategory.fromJson(e))
          .toList(),
      data: (json['data'] as List)
          .map((e) => ServiceModel.fromJson(e))
          .toList(),
    );
  }
}
class ServiceCategory {
  final String id;
  final int count;

  ServiceCategory({
    required this.id,
    required this.count,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['_id'],
      count: json['count'],
    );
  }
}
class ServiceModel {
  final String id;
  final String serviceName;
  final String category;
  final String shortDescription;
  final Pricing pricing;
  final ProviderInfo provider;
  final List<ServiceImage> images;
  final String slug;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.shortDescription,
    required this.pricing,
    required this.provider,
    required this.images,
    required this.slug,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'],
      serviceName: json['serviceName'],
      category: json['category'],
      shortDescription: json['shortDescription'],
      pricing: Pricing.fromJson(json['pricing']),
      provider: ProviderInfo.fromJson(json['provider']),
      images: (json['images'] as List)
          .map((e) => ServiceImage.fromJson(e))
          .toList(),
      slug: json['slug'],
    );
  }
}
class Pricing {
  final int amount;
  final String type;
  final String currency;

  Pricing({
    required this.amount,
    required this.type,
    required this.currency,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      amount: json['amount'],
      type: json['type'],
      currency: json['currency'],
    );
  }
}
class ProviderInfo {
  final String companyName;
  final String city;
  final String phone;

  ProviderInfo({
    required this.companyName,
    required this.city,
    required this.phone,
  });

  factory ProviderInfo.fromJson(Map<String, dynamic> json) {
    return ProviderInfo(
      companyName: json['companyName'],
      city: json['address']['city'],
      phone: json['phone'],
    );
  }
}
class ServiceImage {
  final String url;
  final bool isPrimary;

  ServiceImage({
    required this.url,
    required this.isPrimary,
  });

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      url: json['url'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}
