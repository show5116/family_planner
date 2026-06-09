import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 소비처 모델
class MerchantModel {
  final String id;
  final String? groupId;
  final String? userId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MerchantModel({
    required this.id,
    this.groupId,
    this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 소비처 생성 DTO
class CreateMerchantDto {
  final String? groupId;
  final String name;

  const CreateMerchantDto({this.groupId, required this.name});

  Map<String, dynamic> toJson() => {
        if (groupId != null) 'groupId': groupId,
        'name': name,
      };
}

/// 소비처 수정 DTO
class UpdateMerchantDto {
  final String name;

  const UpdateMerchantDto({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

/// 앱 연결이 가능한 샘플 소비처
class MerchantSample {
  final String name;
  final IconData icon;
  final Color color;

  /// 앱 scheme (null이면 앱 연결 없음)
  final String? appScheme;

  const MerchantSample({
    required this.name,
    required this.icon,
    required this.color,
    this.appScheme,
  });

  bool get hasAppLink => appScheme != null;

  Future<void> launchApp() async {
    if (appScheme == null) return;
    final uri = Uri.parse(appScheme!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// 샘플 소비처 목록
const List<MerchantSample> kMerchantSamples = [
  // 쇼핑
  MerchantSample(
    name: '쿠팡',
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFFFF4500),
    appScheme: 'coupang://',
  ),
  MerchantSample(
    name: '네이버쇼핑',
    icon: Icons.storefront_outlined,
    color: Color(0xFF03C75A),
    appScheme: 'navershopping://',
  ),
  MerchantSample(
    name: '마켓컬리',
    icon: Icons.eco_outlined,
    color: Color(0xFF5F0080),
    appScheme: 'kurly://',
  ),
  MerchantSample(
    name: '11번가',
    icon: Icons.shopping_cart_outlined,
    color: Color(0xFFFF0000),
    appScheme: 'elevenst://',
  ),
  MerchantSample(
    name: 'G마켓',
    icon: Icons.local_mall_outlined,
    color: Color(0xFFE60012),
    appScheme: 'gmarket://',
  ),
  MerchantSample(
    name: '옥션',
    icon: Icons.gavel_outlined,
    color: Color(0xFF0066CC),
    appScheme: 'auction://',
  ),
  // 배달
  MerchantSample(
    name: '배달의민족',
    icon: Icons.delivery_dining_outlined,
    color: Color(0xFF2AC1BC),
    appScheme: 'baemin://',
  ),
  MerchantSample(
    name: '요기요',
    icon: Icons.fastfood_outlined,
    color: Color(0xFFFA2828),
    appScheme: 'yogiyo://',
  ),
  MerchantSample(
    name: '쿠팡이츠',
    icon: Icons.restaurant_outlined,
    color: Color(0xFFFF4500),
    appScheme: 'coupangeats://',
  ),
  // 중고거래
  MerchantSample(
    name: '당근마켓',
    icon: Icons.storefront_outlined,
    color: Color(0xFFFF6F0F),
    appScheme: 'karrot://',
  ),
  MerchantSample(
    name: '번개장터',
    icon: Icons.bolt_outlined,
    color: Color(0xFF00BFFF),
    appScheme: 'bunjang://',
  ),
  // 결제/금융
  MerchantSample(
    name: '네이버페이',
    icon: Icons.payment_outlined,
    color: Color(0xFF03C75A),
    appScheme: 'naverpay://',
  ),
  MerchantSample(
    name: '카카오페이',
    icon: Icons.account_balance_wallet_outlined,
    color: Color(0xFFFFE500),
    appScheme: 'kakaopay://',
  ),
  MerchantSample(
    name: '토스',
    icon: Icons.account_balance_outlined,
    color: Color(0xFF0064FF),
    appScheme: 'supertoss://',
  ),
  // 편의점/마트
  MerchantSample(
    name: 'GS25',
    icon: Icons.store_outlined,
    color: Color(0xFF0050A0),
  ),
  MerchantSample(
    name: 'CU',
    icon: Icons.store_outlined,
    color: Color(0xFF6F2C91),
  ),
  MerchantSample(
    name: '이마트',
    icon: Icons.local_grocery_store_outlined,
    color: Color(0xFFFFCC00),
  ),
  MerchantSample(
    name: '홈플러스',
    icon: Icons.local_grocery_store_outlined,
    color: Color(0xFF0078D7),
  ),
  MerchantSample(
    name: '롯데마트',
    icon: Icons.local_grocery_store_outlined,
    color: Color(0xFFE60012),
  ),
  MerchantSample(
    name: '코스트코',
    icon: Icons.local_grocery_store_outlined,
    color: Color(0xFF005DAA),
  ),
  // 교통
  MerchantSample(
    name: 'T머니',
    icon: Icons.directions_transit_outlined,
    color: Color(0xFF006699),
    appScheme: 'tmoney://',
  ),
  MerchantSample(
    name: '카카오택시',
    icon: Icons.local_taxi_outlined,
    color: Color(0xFFFFE500),
    appScheme: 'kakaomap://',
  ),
];
