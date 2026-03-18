import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/votes/data/repositories/vote_repository.dart';
import 'package:family_planner/features/votes/providers/vote_list_provider.dart';

class VoteCreateScreen extends ConsumerStatefulWidget {
  const VoteCreateScreen({super.key});

  @override
  ConsumerState<VoteCreateScreen> createState() => _VoteCreateScreenState();
}

class _VoteCreateScreenState extends ConsumerState<VoteCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  bool _isMultiple = false;
  bool _isAnonymous = false;
  DateTime? _endsAt;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> get _validOptions =>
      _optionControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final options = _validOptions;
    if (options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('선택지를 2개 이상 입력해주세요')),
      );
      return;
    }

    final groupId = ref.read(voteSelectedGroupIdProvider);
    if (groupId == null) return;

    setState(() => _isSubmitting = true);

    final dto = CreateVoteDto(
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      isMultiple: _isMultiple,
      isAnonymous: _isAnonymous,
      endsAt: _endsAt?.toUtc().toIso8601String(),
      options: options,
    );

    final result = await ref
        .read(voteManagementProvider.notifier)
        .createVote(groupId: groupId, dto: dto);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('투표 생성에 실패했습니다')),
      );
    }
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 23, minute: 59),
    );
    if (time == null) return;

    setState(() {
      _endsAt = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('새 투표 만들기'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '투표 제목 *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '제목을 입력해주세요' : null,
                maxLength: 100,
              ),
              const SizedBox(height: AppSizes.spaceM),
              // 설명
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: '설명 (선택)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                maxLength: 300,
              ),
              const SizedBox(height: AppSizes.spaceM),
              // 선택지
              Row(
                children: [
                  Text('선택지',
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => setState(
                        () => _optionControllers.add(TextEditingController())),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('추가'),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8)),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              ..._optionControllers.asMap().entries.map((entry) {
                final i = entry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            hintText: '선택지 ${i + 1}',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      if (_optionControllers.length > 2)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              size: 20),
                          onPressed: () => setState(() {
                            _optionControllers[i].dispose();
                            _optionControllers.removeAt(i);
                          }),
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSizes.spaceM),
              const Divider(),
              // 옵션
              SwitchListTile(
                title: const Text('복수 선택 허용'),
                subtitle: const Text('여러 항목을 동시에 선택할 수 있습니다'),
                value: _isMultiple,
                onChanged: (v) => setState(() => _isMultiple = v),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: const Text('익명 투표'),
                subtitle: const Text('투표자 이름이 공개되지 않습니다'),
                value: _isAnonymous,
                onChanged: (v) => setState(() => _isAnonymous = v),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              // 마감 시각
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('마감 시각'),
                subtitle: Text(
                  _endsAt == null
                      ? '설정 안 함 (수동 종료)'
                      : _formatDateTime(_endsAt!),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_endsAt != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => setState(() => _endsAt = null),
                      ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _pickDeadline,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('투표 만들기'),
              ),
              const SizedBox(height: AppSizes.spaceM),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
