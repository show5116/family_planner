import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';

/// API 통신 중 전체 화면 로딩 오버레이
class ManagementLoadingOverlay extends ConsumerWidget {
  const ManagementLoadingOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      childcareManagementProvider.select((s) => s.isLoading),
    );

    return Stack(
      children: [
        child,
        if (isLoading) ...[
          const ModalBarrier(dismissible: false, color: Colors.transparent),
          const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
