import 'package:app_front/core/strings.dart';
import 'package:app_front/features/exams/domain/exam.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExamTile extends StatelessWidget {
  final ExamSummary exam;
  final VoidCallback onOpen;

  const ExamTile({super.key, required this.exam, required this.onOpen});

  String _remainingText() {
    final left = exam.deadline.difference(DateTime.now());
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
    final left = exam.deadline.difference(DateTime.now());
    final color = left <= const Duration(hours: 1)
        ? colors.error
        : left <= const Duration(days: 1)
        ? colors.tertiary
        : colors.primary;

    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exam.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(exam.theme, maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 18, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${_remainingText()} · '
                      '${DateFormat('dd.MM.yyyy HH:mm').format(exam.deadline.toLocal())}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    AppStrings.exams.durationMinutes.tr(
                      args: ['${exam.durationMinutes}'],
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
