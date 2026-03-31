import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/weather/models/weather_model.dart';

import 'package:family_planner/features/weather/providers/weather_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 날씨 아이콘 / 색상 헬퍼
/// 현재 날씨(WeatherModel)는 sky 필드가 없으므로 weatherDescription 또는 precipitationType 기반
class WeatherHelper {
  WeatherHelper._();

  /// precipitationType 기반 아이콘 (현재 날씨 / 예보 공용)
  /// 예보는 sky 값도 활용
  static IconData icon(int precipitationType, {int? sky}) {
    if (precipitationType == 1 || precipitationType == 4) {
      return Icons.umbrella_outlined; // 비 / 소나기
    }
    if (precipitationType == 2) return Icons.ac_unit; // 진눈깨비
    if (precipitationType == 3) return Icons.ac_unit; // 눈
    if (sky == 1) return Icons.wb_sunny_outlined; // 맑음
    if (sky == 3) return Icons.cloud_outlined; // 구름많음
    if (sky == 4) return Icons.cloud; // 흐림
    return Icons.wb_sunny_outlined; // 기본: 맑음
  }

  static Color color(int precipitationType, BuildContext context, {int? sky}) {
    final scheme = Theme.of(context).colorScheme;
    if (precipitationType == 3) return Colors.lightBlue.shade300; // 눈
    if (precipitationType > 0) return Colors.blueGrey; // 비/소나기
    if (sky == 1) return Colors.orange.shade400; // 맑음
    if (sky != null && sky > 1) return scheme.onSurfaceVariant; // 구름/흐림
    return Colors.orange.shade400; // 기본: 맑음
  }
}

/// 대시보드용 날씨 콤팩트 위젯
class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return DashboardCard(
      title: '오늘 날씨',
      icon: Icons.wb_sunny_outlined,
      action: TextButton(
        onPressed: () => context.push(AppRoutes.weather),
        child: const Text('자세히'),
      ),
      onTap: () => context.push(AppRoutes.weather),
      child: weatherAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, _) => _ErrorState(
          onRetry: () => ref.invalidate(weatherProvider),
        ),
        data: (weather) => _WeatherContent(weather: weather),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.weather});

  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final iconData = WeatherHelper.icon(weather.precipitationType);
    final iconColor = WeatherHelper.color(weather.precipitationType, context);
    final dateTimeText = DateFormat('M월 d일 (E) HH:mm', 'ko').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (weather.sidoName != null) ...[
              Icon(
                Icons.location_on_outlined,
                size: AppSizes.iconSmall,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 2),
              Text(
                weather.sidoName!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(width: AppSizes.spaceS),
            ],
            Text(
              dateTimeText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceXS),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, size: 48, color: iconColor),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${weather.temperature}°',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          weather.weatherDescription,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceXS),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.water_drop_outlined,
                        label: '${weather.humidity}%',
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      _InfoChip(
                        icon: Icons.air,
                        label: '${weather.windSpeed}m/s',
                      ),
                      if (weather.precipitation > 0) ...[
                        const SizedBox(width: AppSizes.spaceM),
                        _InfoChip(
                          icon: Icons.umbrella_outlined,
                          label: '${weather.precipitation}mm',
                        ),
                      ],
                    ],
                  ),
                  if (weather.pm10Grade != null || weather.pm25Grade != null) ...[
                    const SizedBox(height: AppSizes.spaceXS),
                    Row(
                      children: [
                        if (weather.pm10Grade != null) ...[
                          _DustChip(label: '미세', grade: weather.pm10Grade!),
                        ],
                        if (weather.pm10Grade != null && weather.pm25Grade != null)
                          const SizedBox(width: AppSizes.spaceM),
                        if (weather.pm25Grade != null) ...[
                          _DustChip(label: '초미세', grade: weather.pm25Grade!),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppSizes.iconSmall,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _DustChip extends StatelessWidget {
  const _DustChip({required this.label, required this.grade});

  final String label;
  final int grade;

  Color _gradeColor(BuildContext context) {
    switch (grade) {
      case 1:
        return Colors.blue.shade400;
      case 2:
        return Colors.green.shade600;
      case 3:
        return Colors.orange.shade600;
      case 4:
        return Colors.red.shade600;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  String _gradeLabel() => DustGrade.fromCode(grade)?.label ?? '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.masks_outlined,
          size: AppSizes.iconSmall,
          color: _gradeColor(context),
        ),
        const SizedBox(width: 2),
        Text(
          '$label ${_gradeLabel()}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _gradeColor(context),
              ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '날씨 정보를 불러올 수 없습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
