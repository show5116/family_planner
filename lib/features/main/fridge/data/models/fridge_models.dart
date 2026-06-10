import 'package:family_planner/features/main/household/data/models/expense_model.dart';

/// 보관소 타입
enum StorageType { fridge, freezer, pantry }

StorageType _parseStorageType(String value) {
  switch (value) {
    case 'FREEZER':
      return StorageType.freezer;
    case 'PANTRY':
      return StorageType.pantry;
    default:
      return StorageType.fridge;
  }
}

String storageTypeToString(StorageType type) {
  switch (type) {
    case StorageType.fridge:
      return 'FRIDGE';
    case StorageType.freezer:
      return 'FREEZER';
    case StorageType.pantry:
      return 'PANTRY';
  }
}

// ── Storage ──────────────────────────────────────────────────────────────────

class StorageModel {
  final String id;
  final String groupId;
  final String name;
  final StorageType type;
  final int sortOrder;
  final DateTime createdAt;

  const StorageModel({
    required this.id,
    required this.groupId,
    required this.name,
    required this.type,
    required this.sortOrder,
    required this.createdAt,
  });

  factory StorageModel.fromJson(Map<String, dynamic> json) {
    return StorageModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      name: json['name'] as String,
      type: _parseStorageType(json['type'] as String),
      sortOrder: int.parse(json['sortOrder'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }

  StorageModel copyWith({
    String? id,
    String? groupId,
    String? name,
    StorageType? type,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return StorageModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// GET /fridge/items 응답 — 보관소별 품목 목록
class StorageWithItemsModel {
  final StorageModel storage;
  final List<FridgeItemModel> items;

  const StorageWithItemsModel({required this.storage, required this.items});

  factory StorageWithItemsModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .map((e) => FridgeItemModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <FridgeItemModel>[];
    return StorageWithItemsModel(
      storage: StorageModel.fromJson(json),
      items: items,
    );
  }
}

class CreateStorageDto {
  final String groupId;
  final String name;
  final StorageType type;

  const CreateStorageDto({
    required this.groupId,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'name': name,
        'type': storageTypeToString(type),
      };
}

class UpdateStorageDto {
  final String? name;
  final StorageType? type;

  const UpdateStorageDto({this.name, this.type});

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (type != null) 'type': storageTypeToString(type!),
      };
}

// ── FridgeItem ───────────────────────────────────────────────────────────────

class FridgeItemModel {
  final String id;
  final String groupId;
  final String storageLocationId;
  final String name;
  final int quantity;
  final String? unit;
  final DateTime registeredAt;
  final DateTime? expiresAt;
  final int alertDaysBefore;
  final String? memo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FridgeItemModel({
    required this.id,
    required this.groupId,
    required this.storageLocationId,
    required this.name,
    required this.quantity,
    this.unit,
    required this.registeredAt,
    this.expiresAt,
    required this.alertDaysBefore,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FridgeItemModel.fromJson(Map<String, dynamic> json) {
    return FridgeItemModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      storageLocationId: json['storageLocationId'] as String,
      name: json['name'] as String,
      quantity: int.parse(json['quantity'].toString()),
      unit: json['unit'] as String?,
      registeredAt: DateTime.parse(json['registeredAt'] as String).toLocal(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String).toLocal()
          : null,
      alertDaysBefore: json['alertDaysBefore'] != null ? int.parse(json['alertDaysBefore'].toString()) : 3,
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  /// 유통기한까지 남은 일수 (null이면 유통기한 없음)
  int? get daysUntilExpiry {
    if (expiresAt == null) return null;
    final now = DateTime.now();
    final diff = expiresAt!.difference(DateTime(now.year, now.month, now.day));
    return diff.inDays;
  }

  FridgeItemModel copyWith({
    String? id,
    String? groupId,
    String? storageLocationId,
    String? name,
    int? quantity,
    String? unit,
    DateTime? registeredAt,
    DateTime? expiresAt,
    int? alertDaysBefore,
    String? memo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FridgeItemModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      storageLocationId: storageLocationId ?? this.storageLocationId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      registeredAt: registeredAt ?? this.registeredAt,
      expiresAt: expiresAt ?? this.expiresAt,
      alertDaysBefore: alertDaysBefore ?? this.alertDaysBefore,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateFridgeItemDto {
  final String groupId;
  final String storageLocationId;
  final String name;
  final int quantity;
  final String? unit;
  final String? expiresAt; // YYYY-MM-DD
  final int? alertDaysBefore;
  final String? memo;

  const CreateFridgeItemDto({
    required this.groupId,
    required this.storageLocationId,
    required this.name,
    required this.quantity,
    this.unit,
    this.expiresAt,
    this.alertDaysBefore,
    this.memo,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'storageLocationId': storageLocationId,
        'name': name,
        'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (alertDaysBefore != null) 'alertDaysBefore': alertDaysBefore,
        if (memo != null) 'memo': memo,
      };
}

class UpdateFridgeItemDto {
  final String? storageLocationId;
  final String? name;
  final int? quantity;
  final String? unit;
  final String? expiresAt;
  final int? alertDaysBefore;
  final String? memo;

  const UpdateFridgeItemDto({
    this.storageLocationId,
    this.name,
    this.quantity,
    this.unit,
    this.expiresAt,
    this.alertDaysBefore,
    this.memo,
  });

  Map<String, dynamic> toJson() => {
        if (storageLocationId != null) 'storageLocationId': storageLocationId,
        if (name != null) 'name': name,
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (alertDaysBefore != null) 'alertDaysBefore': alertDaysBefore,
        if (memo != null) 'memo': memo,
      };
}

// ── FrequentItem ──────────────────────────────────────────────────────────────

class FrequentItemModel {
  final String id;
  final String groupId;
  final String name;
  final String? defaultUnit;
  final bool autoAdd;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FrequentItemModel({
    required this.id,
    required this.groupId,
    required this.name,
    this.defaultUnit,
    required this.autoAdd,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FrequentItemModel.fromJson(Map<String, dynamic> json) {
    return FrequentItemModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      name: json['name'] as String,
      defaultUnit: json['defaultUnit'] as String?,
      autoAdd: (json['autoAdd'] as bool?) ?? false,
      sortOrder: int.parse(json['sortOrder'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  FrequentItemModel copyWith({
    String? id,
    String? groupId,
    String? name,
    String? defaultUnit,
    bool? autoAdd,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FrequentItemModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      autoAdd: autoAdd ?? this.autoAdd,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateFrequentItemDto {
  final String groupId;
  final String name;
  final String? defaultUnit;
  final bool? autoAdd;

  const CreateFrequentItemDto({
    required this.groupId,
    required this.name,
    this.defaultUnit,
    this.autoAdd,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'name': name,
        if (defaultUnit != null) 'defaultUnit': defaultUnit,
        if (autoAdd != null) 'autoAdd': autoAdd,
      };
}

class UpdateFrequentItemDto {
  final String? name;
  final String? defaultUnit;
  final bool? autoAdd;

  const UpdateFrequentItemDto({this.name, this.defaultUnit, this.autoAdd});

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (defaultUnit != null) 'defaultUnit': defaultUnit,
        if (autoAdd != null) 'autoAdd': autoAdd,
      };
}

// ── Cart ─────────────────────────────────────────────────────────────────────

class CartItemModel {
  final String id;
  final String cartId;
  final String name;
  final int quantity;
  final String? unit;
  final double? price;
  final bool isChecked;
  final String? memo;
  final DateTime createdAt;

  const CartItemModel({
    required this.id,
    required this.cartId,
    required this.name,
    required this.quantity,
    this.unit,
    this.price,
    required this.isChecked,
    this.memo,
    required this.createdAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      cartId: json['cartId'] as String,
      name: json['name'] as String,
      quantity: int.parse(json['quantity'].toString()),
      unit: json['unit'] as String?,
      price: json['price'] != null ? double.parse(json['price'].toString()) : null,
      isChecked: (json['isChecked'] as bool?) ?? false,
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }

  CartItemModel copyWith({
    String? id,
    String? cartId,
    String? name,
    int? quantity,
    String? unit,
    double? price,
    bool? isChecked,
    String? memo,
    DateTime? createdAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      isChecked: isChecked ?? this.isChecked,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CartModel {
  final String id;
  final String groupId;
  final List<CartItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartModel({
    required this.id,
    required this.groupId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <CartItemModel>[];
    return CartModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      items: items,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  CartModel copyWith({
    String? id,
    String? groupId,
    List<CartItemModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


class UpdateCartItemDto {
  final int? quantity;
  final String? unit;
  final bool? isChecked;
  final String? memo;

  const UpdateCartItemDto({this.quantity, this.unit, this.isChecked, this.memo});

  Map<String, dynamic> toJson() => {
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (isChecked != null) 'isChecked': isChecked,
        if (memo != null) 'memo': memo,
      };
}

// PATCH /shopping/cart/items/bulk — inserts 항목
class CartItemEntryDto {
  final String name;
  final int quantity;
  final String? unit;
  final double? price;
  final String? memo;

  const CartItemEntryDto({
    required this.name,
    required this.quantity,
    this.unit,
    this.price,
    this.memo,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (price != null) 'price': price,
        if (memo != null) 'memo': memo,
      };
}

// PATCH /shopping/cart/items/bulk
class CartItemUpdateEntryDto {
  final String id;
  final String? name;
  final int? quantity;
  final String? unit;
  final bool? isChecked;
  final double? price;
  final String? memo;

  const CartItemUpdateEntryDto({
    required this.id,
    this.name,
    this.quantity,
    this.unit,
    this.isChecked,
    this.price,
    this.memo,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        if (name != null) 'name': name,
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (isChecked != null) 'isChecked': isChecked,
        if (price != null) 'price': price,
        if (memo != null) 'memo': memo,
      };
}

class BulkUpdateCartItemDto {
  final String groupId;
  final List<CartItemEntryDto>? inserts;
  final List<CartItemUpdateEntryDto>? updates;
  final List<String>? deletes;

  const BulkUpdateCartItemDto({
    required this.groupId,
    this.inserts,
    this.updates,
    this.deletes,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        if (inserts != null && inserts!.isNotEmpty)
          'inserts': inserts!.map((e) => e.toJson()).toList(),
        if (updates != null && updates!.isNotEmpty)
          'updates': updates!.map((e) => e.toJson()).toList(),
        if (deletes != null && deletes!.isNotEmpty) 'deletes': deletes,
      };
}

// POST /fridge/items/bulk
class FridgeItemEntryDto {
  final String storageLocationId;
  final String name;
  final int quantity;
  final String? unit;
  final String? expiresAt;
  final int? alertDaysBefore;
  final String? memo;

  const FridgeItemEntryDto({
    required this.storageLocationId,
    required this.name,
    required this.quantity,
    this.unit,
    this.expiresAt,
    this.alertDaysBefore,
    this.memo,
  });

  Map<String, dynamic> toJson() => {
        'storageLocationId': storageLocationId,
        'name': name,
        'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (alertDaysBefore != null) 'alertDaysBefore': alertDaysBefore,
        if (memo != null) 'memo': memo,
      };
}

class BulkCreateFridgeItemDto {
  final String groupId;
  final List<FridgeItemEntryDto> items;

  const BulkCreateFridgeItemDto({required this.groupId, required this.items});

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

// PATCH /fridge/items/bulk
class FridgeItemUpdateEntryDto {
  final String id;
  final String? storageLocationId;
  final String? name;
  final int? quantity;
  final String? unit;
  final String? expiresAt;
  final int? alertDaysBefore;
  final String? memo;

  const FridgeItemUpdateEntryDto({
    required this.id,
    this.storageLocationId,
    this.name,
    this.quantity,
    this.unit,
    this.expiresAt,
    this.alertDaysBefore,
    this.memo,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        if (storageLocationId != null) 'storageLocationId': storageLocationId,
        if (name != null) 'name': name,
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (alertDaysBefore != null) 'alertDaysBefore': alertDaysBefore,
        if (memo != null) 'memo': memo,
      };
}

class BulkUpdateFridgeItemDto {
  final String groupId;
  final List<FridgeItemUpdateEntryDto>? updates;
  final List<String>? deletes;

  const BulkUpdateFridgeItemDto({
    required this.groupId,
    this.updates,
    this.deletes,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        if (updates != null && updates!.isNotEmpty)
          'updates': updates!.map((e) => e.toJson()).toList(),
        if (deletes != null && deletes!.isNotEmpty) 'deletes': deletes,
      };
}


// ── ExpiryPresetModel ─────────────────────────────────────────────────────────
// API 응답: { category, storageType(nullable), days, keywords(nullable), isCustom, customPresetId(nullable) }

class ExpiryPresetModel {
  final String globalPresetId;
  final String category;
  final String keyword;
  final StorageType? storageType; // null = 보관방식 무관
  final int days;
  final bool isCustom;
  final String? customPresetId; // 커스텀인 경우에만 존재 (DELETE 시 사용)

  const ExpiryPresetModel({
    required this.globalPresetId,
    required this.category,
    required this.keyword,
    this.storageType,
    required this.days,
    required this.isCustom,
    this.customPresetId,
  });

  factory ExpiryPresetModel.fromJson(Map<String, dynamic> json) {
    final storageTypeRaw = json['storageType'];
    return ExpiryPresetModel(
      globalPresetId: json['globalPresetId'] as String,
      category: json['category'] as String,
      keyword: json['keyword'] as String,
      storageType: storageTypeRaw != null
          ? _parseStorageType(storageTypeRaw as String)
          : null,
      days: (json['days'] as num).toInt(),
      isCustom: json['isCustom'] as bool,
      customPresetId: json['customPresetId'] as String?,
    );
  }
}

class UpsertExpiryPresetDto {
  final String groupId;
  final String globalPresetId;
  final int customDays;

  const UpsertExpiryPresetDto({
    required this.groupId,
    required this.globalPresetId,
    required this.customDays,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'globalPresetId': globalPresetId,
        'customDays': customDays,
      };
}

/// 장보기 완료 시 냉장고로 이관할 품목
class TransferItemDto {
  final String cartItemId;
  final String storageLocationId;
  final int? quantity;
  final String? unit;
  final double? price;
  final String? expiresAt;
  final int? alertDaysBefore;

  const TransferItemDto({
    required this.cartItemId,
    required this.storageLocationId,
    this.quantity,
    this.unit,
    this.price,
    this.expiresAt,
    this.alertDaysBefore,
  });

  Map<String, dynamic> toJson() => {
        'cartItemId': cartItemId,
        'storageLocationId': storageLocationId,
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
        if (price != null) 'price': price,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (alertDaysBefore != null) 'alertDaysBefore': alertDaysBefore,
      };
}

/// 장보기 완료 시 가계부 등록 DTO
class ShoppingExpenseDto {
  final double? amount; // null이면 품목별 price 합계로 자동 계산
  final PaymentMethod? paymentMethod;
  final String? date;
  final String? description;
  final ExpenseCategory? category;
  final String? merchantId;

  const ShoppingExpenseDto({
    this.amount,
    this.paymentMethod,
    this.date,
    this.description,
    this.category,
    this.merchantId,
  });

  Map<String, dynamic> toJson() => {
        if (amount != null) 'amount': amount,
        if (paymentMethod != null)
          'paymentMethod': _paymentMethodToString(paymentMethod!),
        if (date != null) 'date': date,
        if (description != null) 'description': description,
        if (category != null) 'category': _categoryToString(category!),
        if (merchantId != null) 'merchantId': merchantId,
      };

  static String _paymentMethodToString(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.card:
        return 'CARD';
      case PaymentMethod.transfer:
        return 'TRANSFER';
    }
  }

  static String _categoryToString(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.groceries:
        return 'GROCERIES';
      case ExpenseCategory.food:
        return 'FOOD';
      case ExpenseCategory.living:
        return 'LIVING';
      case ExpenseCategory.other:
        return 'OTHER';
      default:
        return 'GROCERIES';
    }
  }
}

class CompleteCartDto {
  final String groupId;
  final String? completedAt; // ISO8601, 기본: 서버 현재 시각
  final List<TransferItemDto> transfers;
  final List<String>? excludes; // 장바구니에 잔류시킬 항목 ID 목록
  final ShoppingExpenseDto? expense;

  const CompleteCartDto({
    required this.groupId,
    this.completedAt,
    required this.transfers,
    this.excludes,
    this.expense,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        if (completedAt != null) 'completedAt': completedAt,
        'transfers': transfers.map((t) => t.toJson()).toList(),
        if (excludes != null && excludes!.isNotEmpty) 'excludes': excludes,
        if (expense != null) 'expense': expense!.toJson(),
      };
}

// ── Shopping History ──────────────────────────────────────────────────────────

class ShoppingHistoryItemModel {
  final String id;
  final String name;
  final int quantity;
  final String? unit;
  final double? price;
  final bool transferredToFridge;
  final String? fridgeItemId;

  const ShoppingHistoryItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    this.unit,
    this.price,
    required this.transferredToFridge,
    this.fridgeItemId,
  });

  factory ShoppingHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return ShoppingHistoryItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: int.parse(json['quantity'].toString()),
      unit: json['unit'] as String?,
      price: json['price'] != null ? double.parse(json['price'].toString()) : null,
      transferredToFridge: (json['transferredToFridge'] as bool?) ?? false,
      fridgeItemId: json['fridgeItemId'] as String?,
    );
  }
}

class LinkedExpenseModel {
  final String id;
  final double amount;
  final String? category;
  final String? paymentMethod;
  final DateTime date;
  final String? description;

  const LinkedExpenseModel({
    required this.id,
    required this.amount,
    this.category,
    this.paymentMethod,
    required this.date,
    this.description,
  });

  factory LinkedExpenseModel.fromJson(Map<String, dynamic> json) {
    return LinkedExpenseModel(
      id: json['id'] as String,
      amount: double.parse(json['amount'].toString()),
      category: json['category'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      date: DateTime.parse(json['date'] as String).toLocal(),
      description: json['description'] as String?,
    );
  }
}

class ShoppingHistoryModel {
  final String id;
  final String groupId;
  final DateTime completedAt;
  final List<ShoppingHistoryItemModel> items;
  final LinkedExpenseModel? expense;

  const ShoppingHistoryModel({
    required this.id,
    required this.groupId,
    required this.completedAt,
    required this.items,
    this.expense,
  });

  factory ShoppingHistoryModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final List<ShoppingHistoryItemModel> items;
    if (rawItems is List) {
      items = rawItems
          .map((e) => ShoppingHistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (rawItems is Map<String, dynamic>) {
      items = [ShoppingHistoryItemModel.fromJson(rawItems)];
    } else {
      items = [];
    }

    return ShoppingHistoryModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String).toLocal(),
      items: items,
      expense: json['expense'] != null
          ? LinkedExpenseModel.fromJson(json['expense'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ShoppingHistoryPageModel {
  final List<ShoppingHistoryModel> data;
  final int total;
  final int page;
  final int limit;

  const ShoppingHistoryPageModel({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory ShoppingHistoryPageModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List?;
    return ShoppingHistoryPageModel(
      data: rawData
              ?.map((e) =>
                  ShoppingHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
    );
  }

  bool get hasMore => data.length < total;
}
