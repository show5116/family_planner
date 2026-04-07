import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';

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

  /// 자산 통계 조회
  Future<AssetStatisticsModel> getAssetStatistics({
    required String groupId,
    String? userId,
  }) async {
    try {
      final response = await _dio.get('/assets/statistics', queryParameters: {
        'groupId': groupId,
        if (userId != null) 'userId': userId,
      });
      return AssetStatisticsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AssetRepository] 자산 통계 조회 실패: ${e.message}');
      throw Exception('자산 통계 조회 실패: ${e.message}');
    }
  }
}
