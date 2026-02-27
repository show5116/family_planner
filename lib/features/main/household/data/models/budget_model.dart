import 'package:family_planner/features/main/household/data/models/expense_model.dart';

/// 예산 모델
class BudgetModel {
  final String id;
  final String groupId;
  final ExpenseCategory? category;
  final double amount;
  final DateTime month;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetModel({
    required this.id,
    required this.groupId,
    this.category,
    required this.amount,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      category: json['category'] != null
          ? ExpenseModel.parseCategory(json['category'] as String)
          : null,
      amount: double.parse(json['amount'].toString()),
      month: DateTime.parse(json['month'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

/// 예산 설정 DTO
class SetBudgetDto {
  final String groupId;
  final ExpenseCategory? category;
  final double amount;
  final String month; // YYYY-MM

  const SetBudgetDto({
    required this.groupId,
    this.category,
    required this.amount,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      if (category != null) 'category': categoryToString(category!),
      'amount': amount,
      'month': month,
    };
  }

  static String categoryToString(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return 'FOOD';
      case ExpenseCategory.transport:
        return 'TRANSPORT';
      case ExpenseCategory.leisure:
        return 'LEISURE';
      case ExpenseCategory.living:
        return 'LIVING';
      case ExpenseCategory.health:
        return 'HEALTH';
      case ExpenseCategory.education:
        return 'EDUCATION';
      case ExpenseCategory.clothing:
        return 'CLOTHING';
      case ExpenseCategory.other:
        return 'OTHER';
    }
  }
}
