import 'package:family_planner/features/main/household/data/models/expense_model.dart';

/// 카테고리별 통계
class CategoryStatModel {
  final ExpenseCategory? category;
  final double total;
  final int count;
  final double? budget;
  final double? budgetRatio;

  const CategoryStatModel({
    this.category,
    required this.total,
    required this.count,
    this.budget,
    this.budgetRatio,
  });

  factory CategoryStatModel.fromJson(Map<String, dynamic> json) {
    return CategoryStatModel(
      category: json['category'] != null
          ? ExpenseModel.parseCategory(json['category'] as String)
          : null,
      total: double.parse(json['total'].toString()),
      count: json['count'] as int,
      budget: json['budget'] != null
          ? double.parse(json['budget'].toString())
          : null,
      budgetRatio: json['budgetRatio'] != null
          ? (json['budgetRatio'] as num).toDouble()
          : null,
    );
  }
}

/// 월간 통계 모델
class MonthlyStatisticsModel {
  final String month;
  final double totalExpense;
  final double totalBudget;
  final List<CategoryStatModel> categories;

  const MonthlyStatisticsModel({
    required this.month,
    required this.totalExpense,
    required this.totalBudget,
    required this.categories,
  });

  factory MonthlyStatisticsModel.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'] as List<dynamic>? ?? [];
    return MonthlyStatisticsModel(
      month: json['month'] as String,
      totalExpense: double.parse(json['totalExpense'].toString()),
      totalBudget: double.parse(json['totalBudget'].toString()),
      categories: categoriesJson
          .map((e) => CategoryStatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 월별 합계 (연간 통계용)
class MonthlyTotalModel {
  final String month;
  final double total;
  final int count;

  const MonthlyTotalModel({
    required this.month,
    required this.total,
    required this.count,
  });

  factory MonthlyTotalModel.fromJson(Map<String, dynamic> json) {
    return MonthlyTotalModel(
      month: json['month'] as String,
      total: double.parse(json['total'].toString()),
      count: json['count'] as int,
    );
  }
}

/// 연간 통계 모델
class YearlyStatisticsModel {
  final String year;
  final double totalExpense;
  final List<MonthlyTotalModel> months;

  const YearlyStatisticsModel({
    required this.year,
    required this.totalExpense,
    required this.months,
  });

  factory YearlyStatisticsModel.fromJson(Map<String, dynamic> json) {
    final monthsJson = json['months'] as List<dynamic>? ?? [];
    return YearlyStatisticsModel(
      year: json['year'] as String,
      totalExpense: double.parse(json['totalExpense'].toString()),
      months: monthsJson
          .map((e) => MonthlyTotalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
