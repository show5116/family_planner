import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/onboarding/providers/onboarding_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/onboarding_slide_preview.dart';

/// 온보딩 슬라이드 데이터
class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.preview,
    required this.accentColor,
  });

  final String title;
  final String subtitle;
  final String description;
  final Widget preview;
  final Color accentColor;
}

/// 앱 최초 진입 시 표시되는 온보딩 슬라이드 화면
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static final List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      title: '우리만의 플래너',
      subtitle: '가족, 연인, 친구, 팀까지',
      description: '하나의 앱으로 여러 그룹을 관리하세요.\n관계마다 다른 공간에서 함께 계획할 수 있어요.',
      preview: const GroupPreviewWidget(),
      accentColor: AppColors.primary,
    ),
    _OnboardingSlide(
      title: '일정을 함께',
      subtitle: '공유 캘린더',
      description: '그룹 구성원 모두의 일정을 한눈에.\n중요한 날을 절대 놓치지 않아요.',
      preview: const CalendarPreviewWidget(),
      accentColor: Color(0xFF1976D2),
    ),
    _OnboardingSlide(
      title: '할 일 관리',
      subtitle: '공동 TodoList',
      description: '누가 무엇을 해야 하는지 명확하게.\n역할을 나누고 함께 완료해 나가세요.',
      preview: const TodoPreviewWidget(),
      accentColor: Colors.green,
    ),
    _OnboardingSlide(
      title: '가계를 한눈에',
      subtitle: '공동 가계부',
      description: '수입과 지출을 함께 기록하고 분석하세요.\n재정 목표를 그룹과 함께 달성해요.',
      preview: const HouseholdPreviewWidget(),
      accentColor: Colors.orange,
    ),
    _OnboardingSlide(
      title: '그 외 다양한 기능',
      subtitle: '자산·메모·적금·투표 등',
      description: '일상에 필요한 모든 것을 한 곳에서.\n지금 바로 시작해보세요!',
      preview: const MoreFeaturesPreviewWidget(),
      accentColor: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    // provider.complete()가 state를 true로 바꾸면
    // app_router의 listener가 notifier를 increment → redirect가 홈으로 이동
    await ref.read(onboardingProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 건너뛰기 버튼
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  '건너뛰기',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ),
            ),
            // 슬라이드 페이지뷰
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlidePage(slide: _slides[i]),
              ),
            ),
            // 하단 영역
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceL,
                AppSizes.spaceM,
                AppSizes.spaceL,
                AppSizes.spaceL,
              ),
              child: Column(
                children: [
                  // 페이지 인디케이터
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage ? slide.accentColor : AppColors.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceL),
                  // 다음/시작 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: slide.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                        elevation: AppSizes.elevation2,
                      ),
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _slides.length - 1 ? '시작하기' : '다음',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  const _SlidePage({required this.slide});
  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceL),
      child: Column(
        children: [
          const SizedBox(height: AppSizes.spaceM),
          // UI 미리보기
          Expanded(
            flex: 5,
            child: slide.preview,
          ),
          const SizedBox(height: AppSizes.spaceL),
          // 텍스트 영역
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // 부제목 뱃지
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: slide.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    slide.subtitle,
                    style: TextStyle(
                      color: slide.accentColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceS),
                // 메인 제목
                Text(
                  slide.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.spaceM),
                // 설명
                Text(
                  slide.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
