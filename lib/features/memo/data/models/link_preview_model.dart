/// 링크 프리뷰 모델
class LinkPreviewModel {
  final String url;
  final String? title;
  final String? description;
  final String? image;
  final String? siteName;

  const LinkPreviewModel({
    required this.url,
    this.title,
    this.description,
    this.image,
    this.siteName,
  });

  factory LinkPreviewModel.fromJson(Map<String, dynamic> json) {
    return LinkPreviewModel(
      url: json['url'] as String,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      siteName: json['siteName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (image != null) 'image': image,
        if (siteName != null) 'siteName': siteName,
      };

  bool get hasContent => title != null || image != null;
}
