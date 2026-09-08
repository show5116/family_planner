import 'package:flutter/material.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/constants/app_colors.dart';

/// 슬라이드별 앱 UI 미리보기 위젯 모음

// ────────────────────────────────────────────
// 슬라이드 1: 그룹 & 멀티 관계 소개
// ────────────────────────────────────────────
class GroupPreviewWidget extends StatelessWidget {
  const GroupPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = [
      (Icons.home_rounded, l10n.demo_group_family, AppColors.primary, 4),
      (Icons.favorite_rounded, '❤️ ${l10n.intro_preview_couple}', Colors.pink, 2),
      (Icons.people_rounded, l10n.intro_preview_friends, Colors.green, 6),
      (Icons.work_rounded, l10n.intro_preview_team, Colors.orange, 3),
    ];

    return _PhoneMockup(
      child: Column(
        children: [
          _MockAppBar(title: l10n.intro_preview_mygroups),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: groups.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final (icon, name, color, count) = groups[i];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          l10n.intro_preview_members('$count'),
                          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// 슬라이드 2: 캘린더 미리보기
// ────────────────────────────────────────────
class CalendarPreviewWidget extends StatelessWidget {
  const CalendarPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now();
    final events = [
      (Colors.blue, l10n.intro_preview_dining, '오후 6:00'),
      (Colors.green, l10n.intro_preview_hospital, '오전 10:30'),
      (Colors.orange, l10n.intro_preview_birthday, '오후 3:00'),
    ];

    return _PhoneMockup(
      child: Column(
        children: [
          _MockAppBar(title: l10n.calendar_type_event),
          // 미니 달력 헤더
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Column(
              children: [
                // 요일 헤더
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['일', '월', '화', '수', '목', '금', '토']
                      .map((d) => Text(d, style: const TextStyle(color: Colors.white70, fontSize: 9)))
                      .toList(),
                ),
                const SizedBox(height: 4),
                // 날짜 행 (현재 주)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (i) {
                    final day = today.day - today.weekday % 7 + i;
                    final isToday = day == today.day;
                    return Container(
                      width: 22,
                      height: 22,
                      decoration: isToday
                          ? const BoxDecoration(color: Colors.white, shape: BoxShape.circle)
                          : null,
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: isToday ? AppColors.primary : Colors.white,
                            fontSize: 11,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          // 일정 목록
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: events.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (_, i) {
                final (color, title, time) = events[i];
                return Row(
                  children: [
                    Container(width: 3, height: 36, color: color, margin: const EdgeInsets.only(right: 8)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// 슬라이드 3: Todo 미리보기
// ────────────────────────────────────────────
class TodoPreviewWidget extends StatelessWidget {
  const TodoPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final todos = [
      (true, l10n.intro_preview_todo1, l10n.intro_preview_today),
      (true, l10n.intro_preview_todo2, l10n.intro_preview_today),
      (false, l10n.intro_preview_todo3, l10n.intro_preview_tomorrow),
      (false, l10n.intro_preview_todo4, l10n.intro_preview_thisweek),
      (false, l10n.intro_preview_todo5, l10n.intro_preview_thisweek),
    ];

    return _PhoneMockup(
      child: Column(
        children: [
          _MockAppBar(title: l10n.calendar_type_todo),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                _StatusChip(label: l10n.intro_preview_total('${todos.length}'), color: AppColors.primary),
                const SizedBox(width: 6),
                _StatusChip(label: l10n.intro_preview_done('2'), color: Colors.green),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: todos.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final (done, title, due) = todos[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      Icon(
                        done ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: done ? Colors.green : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            color: done ? AppColors.textSecondary : AppColors.textPrimary,
                            decoration: done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      Text(due, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// 슬라이드 4: 가계부 미리보기
// ────────────────────────────────────────────
class HouseholdPreviewWidget extends StatelessWidget {
  const HouseholdPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expenses = [
      (Icons.local_grocery_store, l10n.intro_preview_mart, '-42,000원', Colors.red),
      (Icons.restaurant, l10n.intro_preview_eatout, '-28,500원', Colors.red),
      (Icons.account_balance, l10n.intro_preview_salary, '+3,200,000원', Colors.green),
      (Icons.directions_bus, l10n.intro_preview_transport, '-15,000원', Colors.red),
    ];

    return _PhoneMockup(
      child: Column(
        children: [
          _MockAppBar(title: l10n.nav_household),
          // 요약 카드
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryItem(label: l10n.childcare_income, amount: '3,200,000', color: Colors.greenAccent),
                Container(width: 1, height: 30, color: Colors.white30),
                _SummaryItem(label: l10n.childcare_expense, amount: '85,500', color: Colors.redAccent),
                Container(width: 1, height: 30, color: Colors.white30),
                _SummaryItem(label: l10n.asset_balance, amount: '3,114,500', color: Colors.white),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: expenses.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final (icon, cat, amount, color) = expenses[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(cat, style: const TextStyle(fontSize: 12))),
                      Text(amount, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// 슬라이드 5: 더보기(기타 기능) 미리보기
// ────────────────────────────────────────────
class MoreFeaturesPreviewWidget extends StatelessWidget {
  const MoreFeaturesPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final features = [
      (Icons.account_balance_wallet, l10n.intro_preview_assets, AppColors.primary),
      (Icons.edit_note, l10n.memo_title, Colors.orange),
      (Icons.savings, l10n.intro_preview_savings, Colors.green),
      (Icons.child_care, l10n.childcare_title, Colors.purple),
      (Icons.how_to_vote, l10n.vote_title, Colors.teal),
      (Icons.games, l10n.minigame_title, Colors.pink),
    ];

    return _PhoneMockup(
      child: Column(
        children: [
          _MockAppBar(title: l10n.nav_more),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.1,
              children: features.map((f) {
                final (icon, label, color) = f;
                return Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: color, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────
// 공통 내부 위젯들
// ────────────────────────────────────────────

class _PhoneMockup extends StatelessWidget {
  const _PhoneMockup({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 360,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: child,
        ),
      ),
    );
  }
}

class _MockAppBar extends StatelessWidget {
  const _MockAppBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.amount, required this.color});
  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
        const SizedBox(height: 2),
        Text(amount, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
