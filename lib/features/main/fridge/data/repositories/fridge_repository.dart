import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';

final fridgeRepositoryProvider = Provider<FridgeRepository>((ref) {
  return FridgeRepository();
});

class FridgeRepository {
  final Dio _dio = ApiClient.instance.dio;

  // ── Storage ────────────────────────────────────────────────────────────────

  Future<List<StorageModel>> getStorages({String? groupId}) async {
    try {
      final response = await _dio.get('/fridge/storages', queryParameters: {
        if (groupId != null) 'groupId': groupId,
      });
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => StorageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 보관소 목록 조회 실패: ${e.message}');
      throw Exception('보관소 목록 조회 실패: ${e.message}');
    }
  }

  Future<StorageModel> createStorage(CreateStorageDto dto) async {
    try {
      final response = await _dio.post('/fridge/storages', data: dto.toJson());
      return StorageModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 보관소 생성 실패: ${e.message}');
      throw Exception('보관소 생성 실패: ${e.message}');
    }
  }

  Future<void> reorderStorages(List<String> ids) async {
    try {
      await _dio.patch('/fridge/storages/reorder', data: {'ids': ids});
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 보관소 순서 변경 실패: ${e.message}');
      throw Exception('보관소 순서 변경 실패: ${e.message}');
    }
  }

  Future<StorageModel> updateStorage(
      String storageId, UpdateStorageDto dto, {String? groupId}) async {
    try {
      final response = await _dio.patch(
        '/fridge/storages/$storageId',
        data: dto.toJson(),
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
      return StorageModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('보관소를 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 보관소 수정 실패: ${e.message}');
      throw Exception('보관소 수정 실패: ${e.message}');
    }
  }

  Future<void> deleteStorage(String storageId, {String? groupId}) async {
    try {
      await _dio.delete(
        '/fridge/storages/$storageId',
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('보관소를 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 보관소 삭제 실패: ${e.message}');
      throw Exception('보관소 삭제 실패: ${e.message}');
    }
  }

  // ── FridgeItems ───────────────────────────────────────────────────────────

  Future<List<StorageWithItemsModel>> getItemsGroupedByStorage(
      {String? groupId}) async {
    try {
      final response = await _dio.get('/fridge/items', queryParameters: {
        if (groupId != null) 'groupId': groupId,
      });
      final data = response.data;
      if (data is List) {
        return data
            .map((e) =>
                StorageWithItemsModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 냉장고 품목 조회 실패: ${e.message}');
      throw Exception('냉장고 품목 조회 실패: ${e.message}');
    }
  }

  Future<FridgeItemModel> createFridgeItem(CreateFridgeItemDto dto) async {
    try {
      final response = await _dio.post('/fridge/items', data: dto.toJson());
      return FridgeItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('보관소를 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 냉장고 품목 등록 실패: ${e.message}');
      throw Exception('냉장고 품목 등록 실패: ${e.message}');
    }
  }

  Future<List<FridgeItemModel>> bulkCreateFridgeItems(
      BulkCreateFridgeItemDto dto) async {
    try {
      final response =
          await _dio.post('/fridge/items/bulk', data: dto.toJson());
      final list = response.data as List<dynamic>;
      return list
          .map((e) => FridgeItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('일부 보관소를 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 냉장고 품목 일괄 등록 실패: ${e.message}');
      throw Exception('냉장고 품목 일괄 등록 실패: ${e.message}');
    }
  }

  Future<FridgeItemModel> updateFridgeItem(
      String itemId, UpdateFridgeItemDto dto, {String? groupId}) async {
    try {
      final response = await _dio.patch(
        '/fridge/items/$itemId',
        data: dto.toJson(),
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
      return FridgeItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('품목을 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 냉장고 품목 수정 실패: ${e.message}');
      throw Exception('냉장고 품목 수정 실패: ${e.message}');
    }
  }

  Future<void> deleteFridgeItem(String itemId, {String? groupId}) async {
    try {
      await _dio.delete(
        '/fridge/items/$itemId',
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('품목을 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 냉장고 품목 삭제 실패: ${e.message}');
      throw Exception('냉장고 품목 삭제 실패: ${e.message}');
    }
  }

  Future<FridgeItemModel> updateFridgeItemQuantity(
      String itemId, int quantity, {String? groupId}) async {
    try {
      final response = await _dio.patch(
        '/fridge/items/$itemId/quantity',
        data: {'quantity': quantity},
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
      return FridgeItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('품목을 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 수량 변경 실패: ${e.message}');
      throw Exception('수량 변경 실패: ${e.message}');
    }
  }

  // ── FrequentItems ─────────────────────────────────────────────────────────

  Future<List<FrequentItemModel>> getFrequentItems({String? groupId}) async {
    try {
      final response = await _dio.get('/fridge/frequent-items', queryParameters: {
        if (groupId != null) 'groupId': groupId,
      });
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => FrequentItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 자주 사는 항목 조회 실패: ${e.message}');
      throw Exception('자주 사는 항목 조회 실패: ${e.message}');
    }
  }

  Future<FrequentItemModel> createFrequentItem(CreateFrequentItemDto dto) async {
    try {
      final response =
          await _dio.post('/fridge/frequent-items', data: dto.toJson());
      return FrequentItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 자주 사는 항목 생성 실패: ${e.message}');
      throw Exception('자주 사는 항목 생성 실패: ${e.message}');
    }
  }

  Future<void> reorderFrequentItems(List<String> ids) async {
    try {
      await _dio.patch('/fridge/frequent-items/reorder', data: {'ids': ids});
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 자주 사는 항목 순서 변경 실패: ${e.message}');
      throw Exception('자주 사는 항목 순서 변경 실패: ${e.message}');
    }
  }

  Future<FrequentItemModel> updateFrequentItem(
      String itemId, UpdateFrequentItemDto dto, {String? groupId}) async {
    try {
      final response = await _dio.patch(
        '/fridge/frequent-items/$itemId',
        data: dto.toJson(),
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
      return FrequentItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('자주 사는 항목을 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 자주 사는 항목 수정 실패: ${e.message}');
      throw Exception('자주 사는 항목 수정 실패: ${e.message}');
    }
  }

  Future<void> deleteFrequentItem(String itemId, {String? groupId}) async {
    try {
      await _dio.delete(
        '/fridge/frequent-items/$itemId',
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('자주 사는 항목을 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 자주 사는 항목 삭제 실패: ${e.message}');
      throw Exception('자주 사는 항목 삭제 실패: ${e.message}');
    }
  }

  // ── Cart ──────────────────────────────────────────────────────────────────

  Future<CartModel?> getCart({String? groupId}) async {
    try {
      final response = await _dio.get('/shopping/cart', queryParameters: {
        if (groupId != null) 'groupId': groupId,
      });
      if (response.data == null) return null;
      return CartModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      debugPrint('❌ [FridgeRepository] 장바구니 조회 실패: ${e.message}');
      throw Exception('장바구니 조회 실패: ${e.message}');
    }
  }

  Future<CartItemModel> addCartItem(AddCartItemDto dto) async {
    try {
      final response =
          await _dio.post('/shopping/cart/items', data: dto.toJson());
      return CartItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 장바구니 품목 추가 실패: ${e.message}');
      throw Exception('장바구니 품목 추가 실패: ${e.message}');
    }
  }

  Future<List<CartItemModel>> bulkAddCartItems(BulkAddCartItemDto dto) async {
    try {
      final response =
          await _dio.post('/shopping/cart/items/bulk', data: dto.toJson());
      final list = response.data as List<dynamic>;
      return list
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 장바구니 품목 일괄 추가 실패: ${e.message}');
      throw Exception('장바구니 품목 일괄 추가 실패: ${e.message}');
    }
  }

  Future<CartItemModel> updateCartItem(
      String itemId, UpdateCartItemDto dto, {String? groupId}) async {
    try {
      final response = await _dio.patch(
        '/shopping/cart/items/$itemId',
        data: dto.toJson(),
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
      return CartItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('품목을 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 장바구니 품목 수정 실패: ${e.message}');
      throw Exception('장바구니 품목 수정 실패: ${e.message}');
    }
  }

  Future<void> deleteCartItem(String itemId, {String? groupId}) async {
    try {
      await _dio.delete(
        '/shopping/cart/items/$itemId',
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('품목을 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 장바구니 품목 삭제 실패: ${e.message}');
      throw Exception('장바구니 품목 삭제 실패: ${e.message}');
    }
  }

  Future<CartModel> bulkUpdateCartItems(BulkUpdateCartItemDto dto) async {
    try {
      final response = await _dio.patch(
        '/shopping/cart/items/bulk',
        data: dto.toJson(),
      );
      return CartModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 장바구니 일괄 수정/삭제 실패: ${e.message}');
      throw Exception('장바구니 일괄 수정/삭제 실패: ${e.message}');
    }
  }

  Future<void> bulkUpdateFridgeItems(BulkUpdateFridgeItemDto dto) async {
    try {
      await _dio.patch('/fridge/items/bulk', data: dto.toJson());
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 냉장고 품목 일괄 수정/삭제 실패: ${e.message}');
      throw Exception('냉장고 품목 일괄 수정/삭제 실패: ${e.message}');
    }
  }

  Future<ShoppingHistoryModel> completeCart(CompleteCartDto dto) async {
    try {
      final response =
          await _dio.post('/shopping/cart/complete', data: dto.toJson());
      return ShoppingHistoryModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('장바구니가 비어 있습니다');
      if (e.response?.statusCode == 403) throw Exception('그룹 멤버만 접근할 수 있습니다');
      debugPrint('❌ [FridgeRepository] 장보기 완료 실패: ${e.message}');
      throw Exception('장보기 완료 실패: ${e.message}');
    }
  }

  // ── Shopping History ──────────────────────────────────────────────────────

  Future<ShoppingHistoryPageModel> getShoppingHistory({
    String? groupId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response =
          await _dio.get('/shopping/history', queryParameters: {
        if (groupId != null) 'groupId': groupId,
        'page': page,
        'limit': limit,
      });
      return ShoppingHistoryPageModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 구매 이력 조회 실패: ${e.message}');
      throw Exception('구매 이력 조회 실패: ${e.message}');
    }
  }

  Future<ShoppingHistoryModel> getShoppingHistoryById(
      String historyId, {String? groupId}) async {
    try {
      final response = await _dio.get(
        '/shopping/history/$historyId',
        queryParameters: {if (groupId != null) 'groupId': groupId},
      );
      return ShoppingHistoryModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw Exception('구매 이력을 찾을 수 없습니다');
      debugPrint('❌ [FridgeRepository] 구매 이력 상세 조회 실패: ${e.message}');
      throw Exception('구매 이력 상세 조회 실패: ${e.message}');
    }
  }

  // ── 자동완성 ────────────────────────────────────────────────────────────────

  Future<List<String>> getItemNameSuggestions({
    required String groupId,
    String? q,
  }) async {
    try {
      final response = await _dio.get('/fridge/item-names', queryParameters: {
        'groupId': groupId,
        if (q != null && q.isNotEmpty) 'q': q,
      });
      final data = response.data;
      if (data is List) {
        return data.map((e) => e as String).toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [FridgeRepository] 자동완성 조회 실패: ${e.message}');
      return [];
    }
  }
}
