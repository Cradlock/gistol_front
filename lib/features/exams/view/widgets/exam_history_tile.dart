import 'package:app_front/core/strings.dart';
import 'package:app_front/features/exams/domain/exam.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExamHistoryTile extends StatelessWidget {
  final ExamHistoryItem item;

  const ExamHistoryTile({super.key, required this.item});

  (String, Color) _status(ColorScheme colors) {
    if (item.status == ExamSessionStatus.expired) {
      return (AppStrings.exams.statusExpired.tr(), colors.error);
    }
    if (item.reviewedAt == null || item.score == null) {
      return (AppStrings.exams.statusPending.tr(), colors.onSurfaceVariant);
    }
    return (AppStrings.exams.statusReviewed.tr(), colors.primary);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final (label, color) = _status(colors);
    final submitted = item.submittedAt ?? item.startedAt;

    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(item.examTitle),
        subtitle: Text(
          '${DateFormat('dd.MM.yyyy HH:mm').format(submitted.toLocal())}'
          ' · $label'
          '${item.score == null ? '' : ' · ${item.score}'}',
          style: TextStyle(color: color),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.examTheme),
          const SizedBox(height: 12),
          for (final answer in item.answers) ...[
            Text(
              AppStrings.exams.question.tr(),
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(answer.questionText),
            const SizedBox(height: 8),
            Text(
              AppStrings.exams.yourAnswer.tr(),
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(
              answer.submittedText.isEmpty
                  ? AppStrings.exams.noAnswer.tr()
                  : answer.submittedText,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.stars_outlined, size: 18),
                const SizedBox(width: 4),
                Text(
                  answer.awardedPoints == null
                      ? '${answer.questionPoints}'
                      : '${answer.awardedPoints} / ${answer.questionPoints}',
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
