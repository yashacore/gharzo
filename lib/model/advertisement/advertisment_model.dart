class AdvertisementModel {
  final String id;
  final String title;
  final String adType;     // popup | sidebar | hero
  final String format;     // image | video
  final int priority;

  final AdMedia media;
  final AdClickAction clickAction;

  AdvertisementModel({
    required this.id,
    required this.title,
    required this.adType,
    required this.format,
    required this.priority,
    required this.media,
    required this.clickAction,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      adType: json['adType'] ?? '',
      format: json['format'] ?? '',
      priority: json['priority'] ?? 0,
      media: AdMedia.fromJson(json['media'] ?? {}),
      clickAction: AdClickAction.fromJson(json['clickAction'] ?? {}),
    );
  }

  /// 🟢 mobile first image
  String get imageUrl {
    if (media.mobileImage.isNotEmpty) return media.mobileImage;
    return media.desktopImage;
  }

  bool get hasImage => imageUrl.isNotEmpty;
}


class AdMedia {
  final String desktopImage;
  final String mobileImage;

  AdMedia({
    required this.desktopImage,
    required this.mobileImage,
  });

  factory AdMedia.fromJson(Map<String, dynamic> json) {
    return AdMedia(
      desktopImage: json['desktopImage']?['url'] ?? '',
      mobileImage: json['mobileImage']?['url'] ?? '',
    );
  }
}


class AdClickAction {
  final String type; // external_url | internal
  final String url;
  final bool openInNewTab;

  AdClickAction({
    required this.type,
    required this.url,
    required this.openInNewTab,
  });

  factory AdClickAction.fromJson(Map<String, dynamic> json) {
    return AdClickAction(
      type: json['type'] ?? '',
      url: json['url'] ?? '',
      openInNewTab: json['openInNewTab'] ?? false,
    );
  }
}
