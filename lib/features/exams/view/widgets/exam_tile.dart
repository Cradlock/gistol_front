import 'package:app_front/core/strings.dart';
import 'package:app_front/features/exams/domain/exam.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExamTile extends StatelessWidget {
  final ExamSummary exam;
  final VoidCallback onOpen;

  const ExamTile({super.key, required this.exam, required this.onOpen});

  String _scheduleText() {
    final start = DateFormat('dd.MM.yyyy HH:mm').format(exam.startAt.toLocal());
    if (!exam.hasStarted) {
      return AppStrings.exams.startsAt.tr(args: [start]);
    }
    return start;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final color = exam.hasStarted ? colors.primary : colors.tertiary;

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
                      _scheduleText(),
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
