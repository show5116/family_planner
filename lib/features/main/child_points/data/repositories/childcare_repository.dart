import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';

// ─── DTOs ───────────────────────────────────────────────────────────────────

/// 자녀 프로필 등록 DTO
class CreateChildProfileDto {
  final String groupId;
  final String name;
  final String birthDate; // YYYY-MM-DD

  const CreateChildProfileDto({
    required this.groupId,
    required this.name,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'name': name,
        'birthDate': birthDate,
      };
}

/// 용돈 플랜 설정 DTO
class UpsertAllowancePlanDto {
  final int monthlyPoints;
  final int payDay;
  final int pointToMoneyRatio;
  final String? nextNegotiationDate; // YYYY-MM-DD

  const UpsertAllowancePlanDto({
    required this.monthlyPoints,
    required this.payDay,
    required this.pointToMoneyRatio,
    this.nextNegotiationDate,
  });

  Map<String, dynamic> toJson() => {
        'monthlyPoints': monthlyPoints,
        'payDay': payDay,
        'pointToMoneyRatio': pointToMoneyRatio,
        if (nextNegotiationDate != null)
          'nextNegotiationDate': nextNegotiationDate,
      };
}

/// 포인트 거래 추가 DTO
class CreateTransactionDto {
  final ChildcareTransactionType type;
  final double amount;
  final String description;

  const CreateTransactionDto({
    required this.type,
    required this.amount,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'type': childcareTransactionTypeToString(type),
        'amount': amount,
        'description': description,
      };
}

/// 보상 항목 생성 DTO
class CreateRewardDto {
  final String name;
  final String? description;
  final double points;

  const CreateRewardDto({
    required this.name,
    this.description,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'points': points,
      };
}

/// 보상 항목 수정 DTO
class UpdateRewardDto {
  final String? name;
  final String? description;
  final double? points;
  final bool? isActive;

  const UpdateRewardDto({
    this.name,
    this.description,
    this.points,
    this.isActive,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (points != null) 'points': points,
        if (isActive != null) 'isActive': isActive,
      };
}

/// 규칙 생성 DTO
class CreateRuleDto {
  final String name;
  final String? description;
  final double penalty;

  const CreateRuleDto({
    required this.name,
    this.description,
    required this.penalty,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        if (description != null) 'description': description,
        'penalty': penalty,
      };
}

/// 규칙 수정 DTO
class UpdateRuleDto {
  final String? name;
  final String? description;
  final double? penalty;
  final bool? isActive;

  const UpdateRuleDto({
    this.name,
    this.description,
    this.penalty,
    this.isActive,
  });

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (penalty != null) 'penalty': penalty,
        if (isActive != null) 'isActive': isActive,
      };
}

/// 적금 입출금 DTO
class SavingsAmountDto {
  final double amount;

  const SavingsAmountDto({required this.amount});

  Map<String, dynamic> toJson() => {'amount': amount};
}

// ─── Repository ─────────────────────────────────────────────────────────────

/// 육아 포인트 Repository Provider
final childcareRepositoryProvider = Provider<ChildcareRepository>((ref) {
  return ChildcareRepository();
});

/// 육아 포인트 Repository
class ChildcareRepository {
  final Dio _dio = ApiClient.instance.dio;

  ChildcareRepository();

  // ── 자녀 프로필 ───────────────────────────────────────────────────────────

  /// 자녀 프로필 등록 (앱 계정 불필요, 포인트 계정 자동 생성)
  Future<ChildcareChild> createChild(CreateChildProfileDto dto) async {
    try {
      final response = await _dio.post('/childcare/children', data: dto.toJson());
      return ChildcareChild.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 자녀 프로필 등록 실패: ${e.message}');
      throw Exception('자녀 프로필 등록 실패: ${e.message}');
    }
  }

  /// 자녀 프로필 목록 조회
  Future<List<ChildcareChild>> getChildren({required String groupId}) async {
    try {
      final response = await _dio.get(
        '/childcare/children',
        queryParameters: {'groupId': groupId},
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => ChildcareChild.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 자녀 프로필 목록 조회 실패: ${e.message}');
      throw Exception('자녀 프로필 목록 조회 실패: ${e.message}');
    }
  }

  /// 자녀 프로필과 앱 계정 연동 (부모만 가능)
  Future<ChildcareChild> linkUser(String childId) async {
    try {
      final response =
          await _dio.post('/childcare/children/$childId/link-user');
      return ChildcareChild.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 계정 연동 실패: ${e.message}');
      throw Exception('계정 연동 실패: ${e.message}');
    }
  }

  // ── 용돈 플랜 ─────────────────────────────────────────────────────────────

  /// 용돈 플랜 설정 (생성 또는 수정, 부모만 가능)
  Future<AllowancePlan> upsertAllowancePlan(
    String childId,
    UpsertAllowancePlanDto dto,
  ) async {
    try {
      final response = await _dio.post(
        '/childcare/children/$childId/allowance-plan',
        data: dto.toJson(),
      );
      return AllowancePlan.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 용돈 플랜 설정 실패: ${e.message}');
      throw Exception('용돈 플랜 설정 실패: ${e.message}');
    }
  }

  /// 용돈 플랜 조회
  Future<AllowancePlan?> getAllowancePlan(String childId) async {
    try {
      final response =
          await _dio.get('/childcare/children/$childId/allowance-plan');
      return AllowancePlan.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      debugPrint('❌ [ChildcareRepository] 용돈 플랜 조회 실패: ${e.message}');
      throw Exception('용돈 플랜 조회 실패: ${e.message}');
    }
  }

  /// 용돈 플랜 변경 히스토리 조회
  Future<List<AllowancePlanHistory>> getAllowancePlanHistory(
      String childId) async {
    try {
      final response = await _dio
          .get('/childcare/children/$childId/allowance-plan/history');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) =>
                AllowancePlanHistory.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 용돈 플랜 히스토리 조회 실패: ${e.message}');
      throw Exception('용돈 플랜 히스토리 조회 실패: ${e.message}');
    }
  }

  // ── 포인트 계정 ───────────────────────────────────────────────────────────

  /// 포인트 계정 목록 조회
  Future<List<ChildcareAccount>> getAccounts({required String groupId}) async {
    try {
      final response = await _dio.get(
        '/childcare/accounts',
        queryParameters: {'groupId': groupId},
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => ChildcareAccount.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 계정 목록 조회 실패: ${e.message}');
      throw Exception('계정 목록 조회 실패: ${e.message}');
    }
  }

  /// 포인트 계정 상세 조회
  Future<ChildcareAccount> getAccount(String accountId) async {
    try {
      final response = await _dio.get('/childcare/accounts/$accountId');
      return ChildcareAccount.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('포인트 계정을 찾을 수 없습니다');
      }
      throw Exception('계정 조회 실패: ${e.message}');
    }
  }

  // ── 거래 내역 ─────────────────────────────────────────────────────────────

  /// 포인트 거래 추가 (부모만 가능)
  Future<ChildcareTransaction> addTransaction(
    String accountId,
    CreateTransactionDto dto,
  ) async {
    try {
      final response = await _dio.post(
        '/childcare/accounts/$accountId/transactions',
        data: dto.toJson(),
      );
      return ChildcareTransaction.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 거래 추가 실패: ${e.message}');
      throw Exception('거래 추가 실패: ${e.message}');
    }
  }

  /// 거래 내역 조회
  Future<List<ChildcareTransaction>> getTransactions(
    String accountId, {
    ChildcareTransactionType? type,
    String? month,
  }) async {
    try {
      final response = await _dio.get(
        '/childcare/accounts/$accountId/transactions',
        queryParameters: {
          if (type != null) 'type': childcareTransactionTypeToString(type),
          if (month != null) 'month': month,
        },
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => ChildcareTransaction.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 거래 내역 조회 실패: ${e.message}');
      throw Exception('거래 내역 조회 실패: ${e.message}');
    }
  }

  // ── 보상 ─────────────────────────────────────────────────────────────────

  /// 보상 항목 목록 조회
  Future<List<ChildcareReward>> getRewards(String accountId) async {
    try {
      final response = await _dio.get('/childcare/accounts/$accountId/rewards');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => ChildcareReward.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 보상 목록 조회 실패: ${e.message}');
      throw Exception('보상 목록 조회 실패: ${e.message}');
    }
  }

  /// 보상 항목 추가 (부모만 가능)
  Future<ChildcareReward> addReward(
      String accountId, CreateRewardDto dto) async {
    try {
      final response = await _dio.post(
        '/childcare/accounts/$accountId/rewards',
        data: dto.toJson(),
      );
      return ChildcareReward.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 보상 추가 실패: ${e.message}');
      throw Exception('보상 추가 실패: ${e.message}');
    }
  }

  /// 보상 항목 수정 (부모만 가능)
  Future<ChildcareReward> updateReward(
    String accountId,
    String rewardId,
    UpdateRewardDto dto,
  ) async {
    try {
      final response = await _dio.patch(
        '/childcare/accounts/$accountId/rewards/$rewardId',
        data: dto.toJson(),
      );
      return ChildcareReward.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('보상 항목을 찾을 수 없습니다');
      }
      throw Exception('보상 수정 실패: ${e.message}');
    }
  }

  /// 보상 항목 삭제 (부모만 가능)
  Future<void> deleteReward(String accountId, String rewardId) async {
    try {
      await _dio.delete('/childcare/accounts/$accountId/rewards/$rewardId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('보상 항목을 찾을 수 없습니다');
      }
      throw Exception('보상 삭제 실패: ${e.message}');
    }
  }

  // ── 규칙 ─────────────────────────────────────────────────────────────────

  /// 규칙 목록 조회
  Future<List<ChildcareRule>> getRules(String accountId) async {
    try {
      final response = await _dio.get('/childcare/accounts/$accountId/rules');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => ChildcareRule.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 규칙 목록 조회 실패: ${e.message}');
      throw Exception('규칙 목록 조회 실패: ${e.message}');
    }
  }

  /// 규칙 추가 (부모만 가능)
  Future<ChildcareRule> addRule(String accountId, CreateRuleDto dto) async {
    try {
      final response = await _dio.post(
        '/childcare/accounts/$accountId/rules',
        data: dto.toJson(),
      );
      return ChildcareRule.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 규칙 추가 실패: ${e.message}');
      throw Exception('규칙 추가 실패: ${e.message}');
    }
  }

  /// 규칙 수정 (부모만 가능)
  Future<ChildcareRule> updateRule(
    String accountId,
    String ruleId,
    UpdateRuleDto dto,
  ) async {
    try {
      final response = await _dio.patch(
        '/childcare/accounts/$accountId/rules/$ruleId',
        data: dto.toJson(),
      );
      return ChildcareRule.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('규칙을 찾을 수 없습니다');
      }
      throw Exception('규칙 수정 실패: ${e.message}');
    }
  }

  /// 규칙 삭제 (부모만 가능)
  Future<void> deleteRule(String accountId, String ruleId) async {
    try {
      await _dio.delete('/childcare/accounts/$accountId/rules/$ruleId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('규칙을 찾을 수 없습니다');
      }
      throw Exception('규칙 삭제 실패: ${e.message}');
    }
  }

  // ── 적금 ─────────────────────────────────────────────────────────────────

  /// 적금 입금 (자녀 또는 부모)
  Future<ChildcareTransaction> savingsDeposit(
    String accountId,
    SavingsAmountDto dto,
  ) async {
    try {
      final response = await _dio.post(
        '/childcare/accounts/$accountId/savings/deposit',
        data: dto.toJson(),
      );
      return ChildcareTransaction.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 적금 입금 실패: ${e.message}');
      throw Exception('적금 입금 실패: ${e.message}');
    }
  }

  /// 적금 출금 (부모만 가능)
  Future<ChildcareTransaction> savingsWithdraw(
    String accountId,
    SavingsAmountDto dto,
  ) async {
    try {
      final response = await _dio.post(
        '/childcare/accounts/$accountId/savings/withdraw',
        data: dto.toJson(),
      );
      return ChildcareTransaction.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [ChildcareRepository] 적금 출금 실패: ${e.message}');
      throw Exception('적금 출금 실패: ${e.message}');
    }
  }
}
