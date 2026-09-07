import 'package:flutter/material.dart';
import 'package:family_planner/l10n/app_localizations.dart';
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

  // 번역이 필요해 상수로 둘 수 없다.
  static List<_OnboardingSlide> _slidesOf(AppLocalizations l10n) => [
    _OnboardingSlide(
      title: l10n.intro_slide1_title,
      subtitle: l10n.intro_slide1_subtitle,
      description: l10n.intro_slide1_desc,
      preview: const GroupPreviewWidget(),
      accentColor: AppColors.primary,
    ),
    _OnboardingSlide(
      title: l10n.intro_slide2_title,
      subtitle: l10n.intro_slide2_subtitle,
      description: l10n.intro_slide2_desc,
      preview: const CalendarPreviewWidget(),
      accentColor: Color(0xFF1976D2),
    ),
    _OnboardingSlide(
      title: l10n.intro_slide3_title,
      subtitle: l10n.intro_slide3_subtitle,
      description: l10n.intro_slide3_desc,
      preview: const TodoPreviewWidget(),
      accentColor: Colors.green,
    ),
    _OnboardingSlide(
      title: l10n.intro_slide4_title,
      subtitle: l10n.intro_slide4_subtitle,
      description: l10n.intro_slide4_desc,
      preview: const HouseholdPreviewWidget(),
      accentColor: Colors.orange,
    ),
    _OnboardingSlide(
      title: l10n.intro_slide5_title,
      subtitle: l10n.intro_slide5_subtitle,
      description: l10n.intro_slide5_desc,
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
    final l10n = AppLocalizations.of(context)!;
    if (_currentPage < _slidesOf(l10n).length - 1) {
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
    final l10n = AppLocalizations.of(context)!;
    final slide = _slidesOf(l10n)[_currentPage];

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
                  l10n.common_skip,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ),
            ),
            // 슬라이드 페이지뷰
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slidesOf(l10n).length,
                itemBuilder: (_, i) => _SlidePage(slide: _slidesOf(l10n)[i]),
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
                      _slidesOf(l10n).length,
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
                        _currentPage == _slidesOf(l10n).length - 1 ? l10n.intro_start : l10n.intro_next,
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
