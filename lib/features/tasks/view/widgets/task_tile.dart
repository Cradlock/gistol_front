import 'package:app_front/core/strings.dart';
import 'package:app_front/features/tasks/domain/task.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum TaskUrgency { critical, urgent, soon, normal }

TaskUrgency urgencyForDeadline(DateTime deadline, {DateTime? now}) {
  final left = deadline.difference(now ?? DateTime.now());
  if (left <= const Duration(hours: 1)) return TaskUrgency.critical;
  if (left <= const Duration(days: 1)) return TaskUrgency.urgent;
  if (left <= const Duration(days: 3)) return TaskUrgency.soon;
  return TaskUrgency.normal;
}

class TaskTile extends StatelessWidget {
  final StudentTask task;
  final VoidCallback onAnswer;

  const TaskTile({super.key, required this.task, required this.onAnswer});

  String _remainingText() {
    final left = task.endAt.difference(DateTime.now());
    if (left.isNegative) {
      return AppStrings.tasks.minutesLeft.tr(args: ['0']);
    }
    if (left.inMinutes < 60) {
      return AppStrings.tasks.minutesLeft.tr(args: ['${left.inMinutes}']);
    }
    if (left.inHours < 48) {
      return AppStrings.tasks.hoursLeft.tr(args: ['${left.inHours}']);
    }
    return AppStrings.tasks.daysLeft.tr(args: ['${left.inDays}']);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final urgency = urgencyForDeadline(task.endAt);
    final (color, label) = switch (urgency) {
      TaskUrgency.critical => (colors.error, AppStrings.tasks.critical.tr()),
      TaskUrgency.urgent => (colors.tertiary, AppStrings.tasks.urgent.tr()),
      TaskUrgency.soon => (colors.secondary, AppStrings.tasks.soon.tr()),
      TaskUrgency.normal => (colors.primary, AppStrings.tasks.normal.tr()),
    };

    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onAnswer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(task.content, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 18, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${_remainingText()} · '
                      '${DateFormat('dd.MM.yyyy HH:mm').format(task.endAt.toLocal())}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  const Icon(Icons.stars_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text('${task.points}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
