import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_trend_model.dart';
import 'package:family_planner/features/main/assets/data/models/holding_model.dart';
import 'package:family_planner/features/main/assets/data/models/holding_record_model.dart';
import 'package:family_planner/features/main/assets/data/models/withdrawal_model.dart';

class DuplicateRecordDateException implements Exception {}

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return AssetRepository();
});

class AssetRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 계좌 목록 조회
  Future<List<AccountModel>> getAccounts({
    required String groupId,
    String? userId,
  }) async {
    try {
      final response = await _dio.get('/assets/accounts', queryParameters: {
        'groupId': groupId,
        if (userId != null) 'userId': userId,
      });

      final data = response.data;
      if (data is List) {
        return data
            .map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 계좌 목록 조회 실패: ${e.message}');
      throw Exception('계좌 목록 조회 실패: ${e.message}');
    }
  }

  /// 계좌 상세 조회
  Future<AccountModel> getAccountById(String id) async {
    try {
      final response = await _dio.get('/assets/accounts/$id');
      return AccountModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('계좌를 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('접근 권한이 없습니다');
      throw Exception('계좌 조회 실패: ${e.message}');
    }
  }

  /// 계좌 생성
  Future<AccountModel> createAccount(CreateAccountDto dto) async {
    try {
      final response = await _dio.post('/assets/accounts', data: dto.toJson());
      return AccountModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 계좌 생성 실패: ${e.message}');
      throw Exception('계좌 생성 실패: ${e.message}');
    }
  }

  /// 계좌 수정
  Future<AccountModel> updateAccount(String id, UpdateAccountDto dto) async {
    try {
      final response = await _dio.patch('/assets/accounts/$id', data: dto.toJson());
      return AccountModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('계좌를 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌만 수정할 수 있습니다');
      throw Exception('계좌 수정 실패: ${e.message}');
    }
  }

  /// 계좌 순서 변경
  Future<void> reorderAccounts({
    required String groupId,
    required List<String> accountIds,
  }) async {
    try {
      await _dio.patch('/assets/accounts/reorder', data: {
        'groupId': groupId,
        'accountIds': accountIds,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) throw Exception('해당 그룹의 멤버가 아닙니다');
      throw Exception('계좌 순서 변경 실패: ${e.message}');
    }
  }

  /// 계좌 삭제
  Future<void> deleteAccount(String id) async {
    try {
      await _dio.delete('/assets/accounts/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('계좌를 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌만 삭제할 수 있습니다');
      throw Exception('계좌 삭제 실패: ${e.message}');
    }
  }

  /// 자산 기록 목록 조회
  Future<List<AssetRecordModel>> getAssetRecords(String accountId) async {
    try {
      final response = await _dio.get('/assets/accounts/$accountId/records');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => AssetRecordModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 자산 기록 목록 조회 실패: ${e.message}');
      throw Exception('자산 기록 조회 실패: ${e.message}');
    }
  }

  /// 자산 기록 추가
  Future<AssetRecordModel> createAssetRecord(
    String accountId,
    CreateAssetRecordDto dto,
  ) async {
    try {
      final response = await _dio.post(
        '/assets/accounts/$accountId/records',
        data: dto.toJson(),
      );
      return AssetRecordModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) throw DuplicateRecordDateException();
      if (e.response?.statusCode == 404) throw Exception('계좌를 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌에만 기록을 추가할 수 있습니다');
      throw Exception('자산 기록 추가 실패: ${e.message}');
    }
  }

  /// 자산 기록 삭제
  Future<void> deleteAssetRecord(String accountId, String recordId) async {
    try {
      await _dio.delete('/assets/accounts/$accountId/records/$recordId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('계좌 또는 기록을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌 기록만 삭제할 수 있습니다');
      throw Exception('자산 기록 삭제 실패: ${e.message}');
    }
  }

  /// 출금 기록 목록 조회
  Future<List<WithdrawalModel>> getWithdrawals(String accountId) async {
    try {
      final response = await _dio.get('/assets/accounts/$accountId/withdrawals');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => WithdrawalModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 출금 기록 조회 실패: ${e.message}');
      throw Exception('출금 기록 조회 실패: ${e.message}');
    }
  }

  /// 출금 기록 추가
  Future<WithdrawalModel> createWithdrawal(
    String accountId,
    CreateWithdrawalDto dto,
  ) async {
    try {
      final response = await _dio.post(
        '/assets/accounts/$accountId/withdrawals',
        data: dto.toJson(),
      );
      return WithdrawalModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('계좌를 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌에만 출금 기록을 추가할 수 있습니다');
      throw Exception('출금 기록 추가 실패: ${e.message}');
    }
  }

  /// 출금 기록 삭제
  Future<void> deleteWithdrawal(String accountId, String withdrawalId) async {
    try {
      await _dio.delete('/assets/accounts/$accountId/withdrawals/$withdrawalId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('출금 기록을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌 출금 기록만 삭제할 수 있습니다');
      throw Exception('출금 기록 삭제 실패: ${e.message}');
    }
  }

  /// 그룹 전체 자산 추이 조회
  Future<List<AssetTrendPoint>> getGroupAssetTrend({
    required String groupId,
    required TrendPeriod period,
    String? year,
    List<String>? accountIds,
  }) async {
    try {
      final response = await _dio.get('/assets/statistics/trend', queryParameters: {
        'groupId': groupId,
        'period': period.name,
        if (year != null) 'year': year,
        if (accountIds != null && accountIds.isNotEmpty)
          'accountIds': accountIds.join(','),
      });
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => AssetTrendPoint.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 그룹 자산 추이 조회 실패: ${e.message}');
      throw Exception('자산 추이 조회 실패: ${e.message}');
    }
  }

  /// 계좌별 자산 추이 조회
  Future<List<AssetTrendPoint>> getAccountAssetTrend({
    required String accountId,
    required TrendPeriod period,
    String? year,
  }) async {
    try {
      final response = await _dio.get(
        '/assets/accounts/$accountId/statistics/trend',
        queryParameters: {
          'period': period.name,
          if (year != null) 'year': year,
        },
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => AssetTrendPoint.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 계좌 자산 추이 조회 실패: ${e.message}');
      throw Exception('계좌 자산 추이 조회 실패: ${e.message}');
    }
  }

  /// 종목(포트폴리오 비중) 목록 조회
  Future<List<HoldingModel>> getHoldings(String accountId) async {
    try {
      final response = await _dio.get('/assets/accounts/$accountId/holdings');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => HoldingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 종목 목록 조회 실패: ${e.message}');
      throw Exception('종목 목록 조회 실패: ${e.message}');
    }
  }

  /// 종목 추가
  Future<HoldingModel> createHolding(String accountId, CreateHoldingDto dto) async {
    try {
      final response = await _dio.post(
        '/assets/accounts/$accountId/holdings',
        data: dto.toJson(),
      );
      return HoldingModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw Exception('비율 합계가 100%를 초과합니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌에만 종목을 추가할 수 있습니다');
      throw Exception('종목 추가 실패: ${e.message}');
    }
  }

  /// 종목 수정
  Future<HoldingModel> updateHolding(
    String accountId,
    String holdingId,
    UpdateHoldingDto dto,
  ) async {
    try {
      final response = await _dio.patch(
        '/assets/accounts/$accountId/holdings/$holdingId',
        data: dto.toJson(),
      );
      return HoldingModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) throw Exception('비율 합계가 100%를 초과합니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌 종목만 수정할 수 있습니다');
      throw Exception('종목 수정 실패: ${e.message}');
    }
  }

  /// 종목 삭제
  Future<void> deleteHolding(String accountId, String holdingId) async {
    try {
      await _dio.delete('/assets/accounts/$accountId/holdings/$holdingId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌 종목만 삭제할 수 있습니다');
      throw Exception('종목 삭제 실패: ${e.message}');
    }
  }

  /// 종목 순서 변경
  Future<void> reorderHoldings(String accountId, List<String> holdingIds) async {
    try {
      await _dio.patch(
        '/assets/accounts/$accountId/holdings/reorder',
        data: {'holdingIds': holdingIds},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌 종목만 순서 변경할 수 있습니다');
      throw Exception('종목 순서 변경 실패: ${e.message}');
    }
  }

  /// 금 현물가 조회 (원/g) — GOLD 계좌 생성 시 원금 임시값 계산용
  Future<double> getGoldCurrentPrice() async {
    try {
      final response = await _dio.get('/assets/gold/current-price');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final raw = data['pricePerGram'] ?? data['price'] ?? data['value'];
        if (raw != null) return double.parse(raw.toString());
      }
      if (data is num) return data.toDouble();
      throw Exception('금 시세 파싱 실패');
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 금 현물가 조회 실패: ${e.message}');
      throw Exception('금 현물가 조회 실패: ${e.message}');
    }
  }

  /// 종목 기록 - 자동완성용 종목명 목록 조회
  Future<List<String>> getHoldingRecordNames(String accountId) async {
    try {
      final response = await _dio.get('/assets/accounts/$accountId/holding-records/names');
      final data = response.data;
      if (data is List) return data.map((e) => e.toString()).toList();
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 종목명 목록 조회 실패: ${e.message}');
      return [];
    }
  }

  /// 종목 기록 목록 조회 (날짜 지정 시 해당 날짜만)
  Future<List<HoldingRecordModel>> getHoldingRecords(
    String accountId, {
    String? recordDate, // YYYY-MM-DD
  }) async {
    try {
      final response = await _dio.get(
        '/assets/accounts/$accountId/holding-records',
        queryParameters: {
          if (recordDate != null) 'recordDate': recordDate,
        },
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => HoldingRecordModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 종목 기록 조회 실패: ${e.message}');
      throw Exception('종목 기록 조회 실패: ${e.message}');
    }
  }

  /// 종목 기록 추가
  Future<HoldingRecordModel> createHoldingRecord(
    String accountId,
    CreateHoldingRecordDto dto,
  ) async {
    try {
      final response = await _dio.post(
        '/assets/accounts/$accountId/holding-records',
        data: dto.toJson(),
      );
      return HoldingRecordModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('해당 날짜의 자산 기록이 없습니다. 먼저 잔액 기록을 추가해주세요.');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌에만 기록을 추가할 수 있습니다');
      throw Exception('종목 기록 추가 실패: ${e.message}');
    }
  }

  /// 종목 기록 수정
  Future<HoldingRecordModel> updateHoldingRecord(
    String accountId,
    String recordId,
    UpdateHoldingRecordDto dto,
  ) async {
    try {
      final response = await _dio.patch(
        '/assets/accounts/$accountId/holding-records/$recordId',
        data: dto.toJson(),
      );
      return HoldingRecordModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('기록을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌 기록만 수정할 수 있습니다');
      throw Exception('종목 기록 수정 실패: ${e.message}');
    }
  }

  /// 종목 기록 삭제
  Future<void> deleteHoldingRecord(String accountId, String recordId) async {
    try {
      await _dio.delete('/assets/accounts/$accountId/holding-records/$recordId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('기록을 찾을 수 없습니다');
      if (e.response?.statusCode == 403) throw Exception('본인의 계좌 기록만 삭제할 수 있습니다');
      throw Exception('종목 기록 삭제 실패: ${e.message}');
    }
  }

  /// 자산 통계 조회
  Future<AssetStatisticsModel> getAssetStatistics({
    required String groupId,
    String? userId,
    List<String>? accountIds,
  }) async {
    try {
      final response = await _dio.get('/assets/statistics', queryParameters: {
        'groupId': groupId,
        if (userId != null) 'userId': userId,
        if (accountIds != null && accountIds.isNotEmpty)
          'accountIds': accountIds.join(','),
      });
      return AssetStatisticsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 자산 통계 조회 실패: ${e.message}');
      throw Exception('자산 통계 조회 실패: ${e.message}');
    }
  }
}
