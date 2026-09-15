import 'package:app_front/core/strings.dart';
import 'package:app_front/features/tasks/domain/task.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TaskHistoryTile extends StatelessWidget {
  final TaskHistoryItem item;

  const TaskHistoryTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final (label, color) = switch (item.status) {
      TaskAnswerStatus.pending => (
        AppStrings.tasks.statusPending.tr(),
        colors.onSurfaceVariant,
      ),
      TaskAnswerStatus.positive => (
        AppStrings.tasks.statusPositive.tr(),
        colors.primary,
      ),
      TaskAnswerStatus.negative => (
        AppStrings.tasks.statusNegative.tr(),
        colors.error,
      ),
    };

    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(item.taskTitle),
        subtitle: Text(
          '${DateFormat('dd.MM.yyyy HH:mm').format(item.submittedAt.toLocal())}'
          ' · $label',
          style: TextStyle(color: color),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tasks.question.tr(),
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Align(alignment: Alignment.centerLeft, child: Text(item.taskContent)),
          const SizedBox(height: 12),
          Text(
            AppStrings.tasks.yourAnswer.tr(),
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Align(alignment: Alignment.centerLeft, child: Text(item.text)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.stars_outlined, size: 18),
              const SizedBox(width: 4),
              Text('${item.points}'),
            ],
          ),
        ],
      ),
    );
  }
}
