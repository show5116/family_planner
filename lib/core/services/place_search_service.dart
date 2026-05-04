import 'package:dio/dio.dart';

import 'package:family_planner/core/config/environment.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';

/// 카카오 키워드 장소 검색 결과
class PlaceSearchResult {
  final String id;
  final String name;
  final String address;
  final String roadAddress;
  final double lat;
  final double lng;
  final String? category;
  final String? phone;

  const PlaceSearchResult({
    required this.id,
    required this.name,
    required this.address,
    required this.roadAddress,
    required this.lat,
    required this.lng,
    this.category,
    this.phone,
  });

  factory PlaceSearchResult.fromJson(Map<String, dynamic> json) {
    return PlaceSearchResult(
      id: json['id'] as String,
      name: json['place_name'] as String,
      address: json['address_name'] as String,
      roadAddress: json['road_address_name'] as String? ?? json['address_name'] as String,
      lat: double.parse(json['y'] as String),
      lng: double.parse(json['x'] as String),
      category: json['category_group_name'] as String?,
      phone: json['phone'] as String?,
    );
  }

  TaskLocation toTaskLocation() => TaskLocation(
        name: name,
        address: roadAddress.isNotEmpty ? roadAddress : address,
        lat: lat,
        lng: lng,
      );
}

/// 카카오 Local Search API 래퍼
class PlaceSearchService {
  PlaceSearchService._();

  static final _dio = Dio(BaseOptions(
    baseUrl: 'https://dapi.kakao.com',
    headers: {'Authorization': 'KakaoAK ${EnvironmentConfig.kakaoRestApiKey}'},
  ));

  /// 키워드로 장소 검색 (최대 15건)
  static Future<List<PlaceSearchResult>> search(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/v2/local/search/keyword.json',
        queryParameters: {'query': query, 'size': 15},
      );

      final documents = response.data?['documents'] as List<dynamic>? ?? [];
      return documents
          .map((e) => PlaceSearchResult.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException {
      return [];
    }
  }
}
