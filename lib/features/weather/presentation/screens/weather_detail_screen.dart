import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/weather/models/weather_model.dart';
import 'package:family_planner/features/weather/providers/weather_provider.dart';
import 'package:family_planner/features/weather/presentation/widgets/weather_widget.dart';

/// 날씨 상세 화면
class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    final forecastAsync = ref.watch(weatherForecastProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('날씨'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
            onPressed: () {
              ref.invalidate(locationProvider);
              ref.invalidate(weatherProvider);
              ref.invalidate(weatherForecastProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(locationProvider);
          ref.invalidate(weatherProvider);
          ref.invalidate(weatherForecastProvider);
          await Future.wait([
            ref.read(weatherProvider.future),
            ref.read(weatherForecastProvider.future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            // 현재 날씨 섹션
            weatherAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.spaceXL),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, _) => _RetryCard(
                message: '현재 날씨를 불러올 수 없습니다',
                onRetry: () => ref.invalidate(weatherProvider),
              ),
              data: (weather) => _CurrentWeatherCard(weather: weather),
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 시간별 / 날짜별 예보 섹션
            forecastAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.spaceXL),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, _) => _RetryCard(
                message: '예보를 불러올 수 없습니다',
                onRetry: () => ref.invalidate(weatherForecastProvider),
              ),
              data: (forecast) => _ForecastSection(forecast: forecast),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 현재 날씨 카드 ───────────────────────────────────────────────────────────

class _CurrentWeatherCard extends StatelessWidget {
  const _CurrentWeatherCard({required this.weather});

  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    final iconData = WeatherHelper.icon(weather.precipitationType);
    final iconColor = WeatherHelper.color(weather.precipitationType, context);
    final now = DateTime.now();
    final dateTimeText = DateFormat('yyyy년 M월 d일 (E) HH:mm', 'ko').format(now);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          children: [
            // 날짜 및 시간
            Text(
              dateTimeText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, size: 72, color: iconColor),
                const SizedBox(width: AppSizes.spaceM),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature}°C',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      weather.weatherDescription,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceL),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DetailStat(
                  icon: Icons.water_drop_outlined,
                  label: '습도',
                  value: '${weather.humidity}%',
                ),
                _DetailStat(
                  icon: Icons.air,
                  label: '풍속',
                  value: '${weather.windSpeed}m/s',
                ),
                _DetailStat(
                  icon: Icons.umbrella_outlined,
                  label: '강수량',
                  value: '${weather.precipitation}mm',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: AppSizes.iconLarge, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: AppSizes.spaceXS),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
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

// ─── 예보 섹션 ────────────────────────────────────────────────────────────────

class _ForecastSection extends StatefulWidget {
  const _ForecastSection({required this.forecast});

  final WeatherForecastModel forecast;

  @override
  State<_ForecastSection> createState() => _ForecastSectionState();
}

class _ForecastSectionState extends State<_ForecastSection> {
  final ScrollController _hourlyScrollController = ScrollController();

  // 아이템 너비 + separator
  static const double _itemWidth = 72.0;
  static const double _separatorWidth = AppSizes.spaceS;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
  }

  @override
  void dispose() {
    _hourlyScrollController.dispose();
    super.dispose();
  }

  /// 현재 시간에 해당하는 아이템 인덱스로 자동 스크롤
  void _scrollToNow() {
    final items = _buildHourlyItems();
    if (items.isEmpty) return;

    final now = DateTime.now();
    // 현재 시각 이후의 첫 번째 아이템 인덱스 찾기
    int targetIndex = items.indexWhere((item) {
      return item.forecastDateTime.isAfter(now) ||
          item.forecastDateTime.hour == now.hour;
    });
    if (targetIndex < 0) targetIndex = 0;

    final offset = targetIndex * (_itemWidth + _separatorWidth);
    if (_hourlyScrollController.hasClients) {
      _hourlyScrollController.jumpTo(
        offset.clamp(0.0, _hourlyScrollController.position.maxScrollExtent),
      );
    }
  }

  /// 오늘 + 내일 시간별 예보 아이템 목록
  List<ForecastItemModel> _buildHourlyItems() {
    final now = DateTime.now();
    final today = DateFormat('yyyyMMdd').format(now);
    final tomorrow = DateFormat('yyyyMMdd').format(now.add(const Duration(days: 1)));

    return widget.forecast.forecasts
        .where((e) => e.fcstDate == today || e.fcstDate == tomorrow)
        .toList();
  }

  DateTime _parseDate(String yyyyMMdd) {
    return DateTime(
      int.parse(yyyyMMdd.substring(0, 4)),
      int.parse(yyyyMMdd.substring(4, 6)),
      int.parse(yyyyMMdd.substring(6, 8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final byDate = widget.forecast.byDate;
    final hourlyItems = _buildHourlyItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 시간별 예보 (오늘 + 내일)
        Text(
          '시간별 예보',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        if (hourlyItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
            child: Text(
              '시간별 예보 정보가 없습니다',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: ListView.separated(
                controller: _hourlyScrollController,
                scrollDirection: Axis.horizontal,
                primary: false,
                physics: const ClampingScrollPhysics(),
                itemCount: hourlyItems.length,
                separatorBuilder: (_, _) => const SizedBox(width: _separatorWidth),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: _itemWidth,
                    child: _HourlyItem(item: hourlyItems[index]),
                  );
                },
              ),
            ),
          ),
        const SizedBox(height: AppSizes.spaceL),

        // 날짜별 예보
        Text(
          '날짜별 예보',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        ...byDate.entries.map((entry) {
          final items = entry.value;
          final date = _parseDate(entry.key);
          final minTemp = items
              .map((e) => e.minTemperature ?? e.temperature)
              .reduce((a, b) => a < b ? a : b);
          final maxTemp = items
              .map((e) => e.maxTemperature ?? e.temperature)
              .reduce((a, b) => a > b ? a : b);
          final maxPrecipProb = items
              .map((e) => e.precipitationProbability)
              .reduce((a, b) => a > b ? a : b);
          final repItem = items[items.length ~/ 2];

          return _DayCard(
            date: date,
            minTemp: minTemp,
            maxTemp: maxTemp,
            maxPrecipProb: maxPrecipProb,
            representativeItem: repItem,
            hourlyItems: items,
          );
        }),
      ],
    );
  }
}

class _HourlyItem extends StatelessWidget {
  const _HourlyItem({required this.item});

  final ForecastItemModel item;

  @override
  Widget build(BuildContext context) {
    final hour = item.fcstTime.substring(0, 2);
    final isMidnight = hour == '00';
    final iconData = WeatherHelper.icon(item.precipitationType, sky: item.sky);
    final iconColor = WeatherHelper.color(item.precipitationType, context, sky: item.sky);

    // 자정(00시)에는 날짜 표시
    final timeLabel = isMidnight
        ? '${item.fcstDate.substring(4, 6)}/${item.fcstDate.substring(6, 8)}'
        : '$hour시';

    return Card(
      color: isMidnight
          ? Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS,
          vertical: AppSizes.spaceXS,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isMidnight
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isMidnight ? FontWeight.bold : null,
                  ),
            ),
            Icon(iconData, size: AppSizes.iconMedium, color: iconColor),
            Text(
              '${item.temperature}°',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              item.precipitationProbability > 0
                  ? '${item.precipitationProbability}%'
                  : '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blueGrey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCard extends StatefulWidget {
  const _DayCard({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.maxPrecipProb,
    required this.representativeItem,
    required this.hourlyItems,
  });

  final DateTime date;
  final int minTemp;
  final int maxTemp;
  final int maxPrecipProb;
  final ForecastItemModel representativeItem;
  final List<ForecastItemModel> hourlyItems;

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday = widget.date.year == today.year &&
        widget.date.month == today.month &&
        widget.date.day == today.day;
    final dayLabel = isToday
        ? '오늘'
        : DateFormat('M/d (E)', 'ko').format(widget.date);

    final iconData = WeatherHelper.icon(
      widget.representativeItem.precipitationType,
      sky: widget.representativeItem.sky,
    );
    final iconColor = WeatherHelper.color(
      widget.representativeItem.precipitationType,
      context,
      sky: widget.representativeItem.sky,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Column(
        children: [
          // 날짜 요약 행 (탭으로 펼치기/접기)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: _expanded
                ? const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusMedium))
                : BorderRadius.circular(AppSizes.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      dayLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isToday ? FontWeight.bold : null,
                          ),
                    ),
                  ),
                  Icon(iconData, size: AppSizes.iconMedium, color: iconColor),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: Text(
                      widget.representativeItem.weatherDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSizes.spaceM),
                    child: Text(
                      widget.maxPrecipProb > 0 ? '${widget.maxPrecipProb}%' : '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blueGrey,
                          ),
                    ),
                  ),
                  Text(
                    '${widget.minTemp}° / ${widget.maxTemp}°',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: AppSizes.iconMedium,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          // 펼쳐진 시간별 상세 (수평 스크롤)
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
              child: SizedBox(
                height: 120,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    primary: false,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
                    itemCount: widget.hourlyItems.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSizes.spaceS),
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 72,
                        child: _HourlyItem(item: widget.hourlyItems[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── 에러 카드 ────────────────────────────────────────────────────────────────

class _RetryCard extends StatelessWidget {
  const _RetryCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: AppSizes.iconXLarge,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(message),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
