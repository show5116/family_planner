import 'package:family_planner/features/main/household/data/models/expense_model.dart';

// ─────────────────────────────────────────────
// 카테고리별 예산
// ─────────────────────────────────────────────

/// 카테고리별 예산 모델 (category 필수)
class BudgetModel {
  final String id;
  final String? groupId; // 개인 모드에서는 null
  final ExpenseCategory category;
  final double amount;
  final DateTime month;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetModel({
    required this.id,
    required this.groupId,
    required this.category,
    required this.amount,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      category: json['category'] != null
          ? ExpenseModel.parseCategory(json['category'] as String)
          : ExpenseCategory.other,
      amount: double.parse(json['amount'].toString()),
      month: DateTime.parse(json['month'] as String).toLocal(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 카테고리별 예산 설정 DTO
class SetBudgetDto {
  final String? groupId; // null이면 개인 모드
  final ExpenseCategory category;
  final double amount;
  final String month; // YYYY-MM

  const SetBudgetDto({
    this.groupId,
    required this.category,
    required this.amount,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      if (groupId != null) 'groupId': groupId,
      'category': categoryToString(category),
      'amount': amount,
      'month': month,
    };
  }

  static String categoryToString(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.transportation:
        return 'TRANSPORTATION';
      case ExpenseCategory.food:
        return 'FOOD';
      case ExpenseCategory.leisure:
        return 'LEISURE';
      case ExpenseCategory.living:
        return 'LIVING';
      case ExpenseCategory.medical:
        return 'MEDICAL';
      case ExpenseCategory.education:
        return 'EDUCATION';
      case ExpenseCategory.other:
        return 'OTHER';
    }
  }
}

// ─────────────────────────────────────────────
// 카테고리별 예산 템플릿
// ─────────────────────────────────────────────

/// 카테고리별 예산 템플릿 모델 (매월 자동 적용)
class BudgetTemplateModel {
  final String id;
  final String? groupId; // 개인 모드에서는 null
  final ExpenseCategory category;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetTemplateModel({
    required this.id,
    required this.groupId,
    required this.category,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetTemplateModel.fromJson(Map<String, dynamic> json) {
    return BudgetTemplateModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      category: json['category'] != null
          ? ExpenseModel.parseCategory(json['category'] as String)
          : ExpenseCategory.other,
      amount: double.parse(json['amount'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 카테고리별 예산 템플릿 설정 DTO
class SetBudgetTemplateDto {
  final String? groupId; // null이면 개인 모드
  final ExpenseCategory category;
  final double amount;

  const SetBudgetTemplateDto({
    this.groupId,
    required this.category,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      if (groupId != null) 'groupId': groupId,
      'category': SetBudgetDto.categoryToString(category),
      'amount': amount,
    };
  }
}

// ─────────────────────────────────────────────
// 그룹 전체 예산
// ─────────────────────────────────────────────

/// 그룹 전체 예산 모델
class GroupBudgetModel {
  final String id;
  final String? groupId; // 개인 모드에서는 null
  final double amount;
  final DateTime month;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GroupBudgetModel({
    required this.id,
    required this.groupId,
    required this.amount,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupBudgetModel.fromJson(Map<String, dynamic> json) {
    return GroupBudgetModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      amount: double.parse(json['amount'].toString()),
      month: DateTime.parse(json['month'] as String).toLocal(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 그룹 전체 예산 설정 DTO
class SetGroupBudgetDto {
  final String? groupId; // null이면 개인 모드
  final double amount;
  final String month; // YYYY-MM

  const SetGroupBudgetDto({
    this.groupId,
    required this.amount,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      if (groupId != null) 'groupId': groupId,
      'amount': amount,
      'month': month,
    };
  }
}

// ─────────────────────────────────────────────
// 그룹 전체 예산 템플릿
// ─────────────────────────────────────────────

/// 그룹 전체 예산 템플릿 모델
class GroupBudgetTemplateModel {
  final String id;
  final String? groupId; // 개인 모드에서는 null
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GroupBudgetTemplateModel({
    required this.id,
    required this.groupId,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupBudgetTemplateModel.fromJson(Map<String, dynamic> json) {
    return GroupBudgetTemplateModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String?,
      amount: double.parse(json['amount'].toString()),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 그룹 전체 예산 템플릿 설정 DTO
class SetGroupBudgetTemplateDto {
  final String? groupId; // null이면 개인 모드
  final double amount;

  const SetGroupBudgetTemplateDto({
    this.groupId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      if (groupId != null) 'groupId': groupId,
      'amount': amount,
    };
  }
}

// ─────────────────────────────────────────────
// Bulk DTO
// ─────────────────────────────────────────────

/// 카테고리별 예산 항목 (bulk용)
class CategoryBudgetItemDto {
  final ExpenseCategory category;
  final double amount;

  const CategoryBudgetItemDto({required this.category, required this.amount});

  Map<String, dynamic> toJson() => {
        'category': SetBudgetDto.categoryToString(category),
        'amount': amount,
      };
}

/// 예산 일괄 설정 DTO (POST /household/budgets/bulk)
class BulkSetBudgetDto {
  final String? groupId; // null이면 개인 모드
  final String month; // YYYY-MM
  final double? total;
  final List<CategoryBudgetItemDto> categories;

  const BulkSetBudgetDto({
    this.groupId,
    required this.month,
    this.total,
    required this.categories,
  });

  Map<String, dynamic> toJson() => {
        if (groupId != null) 'groupId': groupId,
        'month': month,
        if (total != null) 'total': total,
        'categories': categories.map((c) => c.toJson()).toList(),
      };
}

/// 예산 일괄 설정 응답
class BulkBudgetResult {
  final GroupBudgetModel? total;
  final List<BudgetModel> categories;

  const BulkBudgetResult({this.total, required this.categories});

  factory BulkBudgetResult.fromJson(Map<String, dynamic> json) {
    return BulkBudgetResult(
      total: json['total'] != null
          ? GroupBudgetModel.fromJson(json['total'] as Map<String, dynamic>)
          : null,
      categories: (json['categories'] as List? ?? [])
          .map((e) => BudgetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 카테고리별 예산 템플릿 항목 (bulk용)
class CategoryTemplateItemDto {
  final ExpenseCategory category;
  final double amount;

  const CategoryTemplateItemDto({required this.category, required this.amount});

  Map<String, dynamic> toJson() => {
        'category': SetBudgetDto.categoryToString(category),
        'amount': amount,
      };
}

/// 예산 템플릿 일괄 설정 DTO (POST /household/budget-templates/bulk)
class BulkSetBudgetTemplateDto {
  final String? groupId; // null이면 개인 모드
  final double? total;
  final List<CategoryTemplateItemDto> categories;

  const BulkSetBudgetTemplateDto({
    this.groupId,
    this.total,
    required this.categories,
  });

  Map<String, dynamic> toJson() => {
        if (groupId != null) 'groupId': groupId,
        if (total != null) 'total': total,
        'categories': categories.map((c) => c.toJson()).toList(),
      };
}

/// 예산 템플릿 일괄 설정 응답
class BulkBudgetTemplateResult {
  final GroupBudgetTemplateModel? total;
  final List<BudgetTemplateModel> categories;

  const BulkBudgetTemplateResult({this.total, required this.categories});

  factory BulkBudgetTemplateResult.fromJson(Map<String, dynamic> json) {
    return BulkBudgetTemplateResult(
      total: json['total'] != null
          ? GroupBudgetTemplateModel.fromJson(json['total'] as Map<String, dynamic>)
          : null,
      categories: (json['categories'] as List? ?? [])
          .map((e) => BudgetTemplateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
