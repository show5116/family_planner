import 'package:go_router/go_router.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/presentation/screens/questions_screen.dart';
import 'package:family_planner/features/qna/presentation/screens/question_detail_screen.dart';
import 'package:family_planner/features/qna/presentation/screens/question_form_screen.dart';

/// Q&A 관련 라우트 목록
///
/// 포함되는 화면:
/// - Questions (Q&A 목록 - 공개/내 질문 통합)
/// - Question Detail (질문 상세)
/// - Question Create (질문 작성)
/// - Question Edit (질문 수정)
List<RouteBase> getQnaRoutes() {
  return [
    // Q&A 목록 (통합)
    GoRoute(
      path: AppRoutes.questions,
      name: 'questions',
      builder: (context, state) => const QuestionsScreen(),
    ),

    // 질문 상세
    GoRoute(
      path: AppRoutes.questionDetail,
      name: 'questionDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return QuestionDetailScreen(questionId: id);
      },
    ),

    // 질문 작성
    GoRoute(
      path: AppRoutes.questionCreate,
      name: 'questionCreate',
      builder: (context, state) => const QuestionFormScreen(),
    ),

    // 질문 수정
    GoRoute(
      path: AppRoutes.questionEdit,
      name: 'questionEdit',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final question = state.extra as QuestionModel?;
        return QuestionFormScreen(
          questionId: id,
          question: question,
        );
      },
    ),
  ];
}

