import 'package:go_router/go_router.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/presentation/screens/public_questions_screen.dart';
import 'package:family_planner/features/qna/presentation/screens/my_questions_screen.dart';
import 'package:family_planner/features/qna/presentation/screens/question_detail_screen.dart';
import 'package:family_planner/features/qna/presentation/screens/question_form_screen.dart';

/// Q&A 관련 라우트 목록
///
/// 포함되는 화면:
/// - Public Questions (공개 Q&A 목록)
/// - Public Question Detail (공개 질문 상세)
/// - My Questions (내 질문 목록)
/// - My Question Detail (내 질문 상세)
/// - Question Create (질문 작성)
/// - Question Edit (질문 수정)
List<RouteBase> getQnaRoutes() {
  return [
    // 공개 Q&A 목록
    GoRoute(
      path: AppRoutes.publicQuestions,
      name: 'publicQuestions',
      builder: (context, state) => const PublicQuestionsScreen(),
    ),

    // 공개 질문 상세
    GoRoute(
      path: AppRoutes.publicQuestionDetail,
      name: 'publicQuestionDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return QuestionDetailScreen(questionId: id);
      },
    ),

    // 내 질문 목록
    GoRoute(
      path: AppRoutes.myQuestions,
      name: 'myQuestions',
      builder: (context, state) => const MyQuestionsScreen(),
    ),

    // 내 질문 상세
    GoRoute(
      path: AppRoutes.myQuestionDetail,
      name: 'myQuestionDetail',
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
