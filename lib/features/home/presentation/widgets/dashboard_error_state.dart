import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 대시보드 요약 위젯 전용 에러 상태
///
/// 위젯 대부분이 에러를 빈 상태와 똑같이 그리고 있어서, 데이터가 없는 것인지
/// 불러오기가 실패한 것인지 구분할 수 없었습니다. 그 탓에 응답 파싱이 깨져도
/// "일정이 없습니다"처럼 정상 화면으로 보여 원인을 찾기 어려웠습니다.
///
/// 카드 안에 들어가야 하므로 [AppErrorState]보다 작게 만들고,
/// 다시 시도 버튼으로 즉시 재조회할 수 있게 합니다.
class DashboardErrorState extends StatelessWidget {
  const DashboardErrorState({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: AppSizes.iconLarge,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            l10n.dashboard_loadFailed,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.spaceXS),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceS,
                ),
              ),
              child: Text(l10n.common_retry),
            ),
          ],
        ],
      ),
    );
  }
}
