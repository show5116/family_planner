import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';

/// QuestionCategory 확장 메서드
extension QuestionCategoryExtension on QuestionCategory {
  /// 카테고리명 (한글)
  String get displayName {
    switch (this) {
      case QuestionCategory.bug:
        return '버그 신고';
      case QuestionCategory.feature:
        return '기능 제안';
      case QuestionCategory.usage:
        return '사용법 문의';
      case QuestionCategory.account:
        return '계정 문제';
      case QuestionCategory.payment:
        return '결제/요금제';
      case QuestionCategory.etc:
        return '기타';
    }
  }

  /// 카테고리 아이콘
  IconData get icon {
    switch (this) {
      case QuestionCategory.bug:
        return Icons.bug_report;
      case QuestionCategory.feature:
        return Icons.lightbulb;
      case QuestionCategory.usage:
        return Icons.help;
      case QuestionCategory.account:
        return Icons.person;
      case QuestionCategory.payment:
        return Icons.payment;
      case QuestionCategory.etc:
        return Icons.chat;
    }
  }

  /// 카테고리 색상
  Color get color {
    switch (this) {
      case QuestionCategory.bug:
        return AppColors.error;
      case QuestionCategory.feature:
        return AppColors.warning;
      case QuestionCategory.usage:
        return AppColors.info;
      case QuestionCategory.account:
        return AppColors.primary;
      case QuestionCategory.payment:
        return AppColors.success;
      case QuestionCategory.etc:
        return AppColors.textSecondary;
    }
  }
}

/// QuestionStatus 확장 메서드
extension QuestionStatusExtension on QuestionStatus {
  /// 상태명 (한글)
  String get displayName {
    switch (this) {
      case QuestionStatus.pending:
        return '대기 중';
      case QuestionStatus.answered:
        return '답변 완료';
      case QuestionStatus.resolved:
        return '해결 완료';
    }
  }

  /// 상태 색상
  Color get color {
    switch (this) {
      case QuestionStatus.pending:
        return AppColors.warning;
      case QuestionStatus.answered:
        return AppColors.info;
      case QuestionStatus.resolved:
        return AppColors.success;
    }
  }

  /// 상태 아이콘
  IconData get icon {
    switch (this) {
      case QuestionStatus.pending:
        return Icons.schedule;
      case QuestionStatus.answered:
        return Icons.chat_bubble;
      case QuestionStatus.resolved:
        return Icons.check_circle;
    }
  }
}

/// QuestionVisibility 확장 메서드
extension QuestionVisibilityExtension on QuestionVisibility {
  /// 공개 여부명 (한글)
  String get displayName {
    switch (this) {
      case QuestionVisibility.public:
        return '공개';
      case QuestionVisibility.private:
        return '비공개';
    }
  }

  /// 공개 여부 아이콘
  IconData get icon {
    switch (this) {
      case QuestionVisibility.public:
        return Icons.public;
      case QuestionVisibility.private:
        return Icons.lock;
    }
  }

  /// 공개 여부 색상
  Color get color {
    switch (this) {
      case QuestionVisibility.public:
        return AppColors.success;
      case QuestionVisibility.private:
        return AppColors.textSecondary;
    }
  }

  /// 설명 문구
  String get description {
    switch (this) {
      case QuestionVisibility.public:
        return '다른 사용자도 볼 수 있습니다 (FAQ로 활용)';
      case QuestionVisibility.private:
        return '나와 관리자만 볼 수 있습니다';
    }
  }
}
