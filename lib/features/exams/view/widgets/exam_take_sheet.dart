import 'dart:async';

import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/features/exams/domain/exam.dart';
import 'package:app_front/features/exams/view/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> showExamTakeSheet(BuildContext context, SessionTake take) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => ExamTakeSheet(take: take),
  );
}

class ExamTakeSheet extends StatefulWidget {
  final SessionTake take;

  const ExamTakeSheet({super.key, required this.take});

  @override
  State<ExamTakeSheet> createState() => _ExamTakeSheetState();
}

class _ExamTakeSheetState extends State<ExamTakeSheet> {
  late final Map<int, int?> _choices;
  late final Map<int, TextEditingController> _texts;
  final Map<int, Timer> _debounces = {};
  Timer? _clock;
  String? _error;

  @override
  void initState() {
    super.initState();
    _choices = {
      for (final question in widget.take.questions)
        if (question.type == QuestionType.choice) question.id: null,
    };
    _texts = {
      for (final question in widget.take.questions)
        if (question.type == QuestionType.input)
          question.id: TextEditingController(),
    };
    for (final answer in widget.take.answers) {
      if (_choices.containsKey(answer.questionId)) {
        _choices[answer.questionId] = answer.choiceId;
      }
      final controller = _texts[answer.questionId];
      if (controller != null && answer.text != null) {
        controller.text = answer.text!;
      }
    }
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clock?.cancel();
    for (final timer in _debounces.values) {
      timer.cancel();
    }
    for (final controller in _texts.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Duration get _left {
    final left = widget.take.deadline.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  String _remainingLabel() {
    final left = _left;
    if (left.inMinutes < 60) {
      return AppStrings.tasks.minutesLeft.tr(args: ['${left.inMinutes}']);
    }
    return AppStrings.tasks.hoursLeft.tr(args: ['${left.inHours}']);
  }

  Future<void> _saveChoice(int questionId, int choiceId) async {
    setState(() => _choices[questionId] = choiceId);
    try {
      await context.read<ExamsProvider>().saveAnswer(
        questionId,
        AnswerUpsertRequest(choiceId: choiceId),
      );
    } on Exception catch (error) {
      if (mounted) ErrorHandler.handle(error, context: context);
    }
  }

  void _scheduleTextSave(int questionId) {
    _debounces[questionId]?.cancel();
    _debounces[questionId] = Timer(const Duration(milliseconds: 500), () {
      _saveText(questionId);
    });
  }

  Future<void> _saveText(int questionId) async {
    final text = _texts[questionId]?.text.trim() ?? '';
    if (text.isEmpty) return;
    try {
      await context.read<ExamsProvider>().saveAnswer(
        questionId,
        AnswerUpsertRequest(text: text),
      );
    } on Exception catch (error) {
      if (mounted) ErrorHandler.handle(error, context: context);
    }
  }

  Future<void> _flushPending() async {
    for (final timer in _debounces.values) {
      timer.cancel();
    }
    _debounces.clear();
    for (final questionId in _texts.keys) {
      await _saveText(questionId);
    }
  }

  Future<void> _submit() async {
    if (_left == Duration.zero) {
      setState(() => _error = AppStrings.exams.unavailable.tr());
      return;
    }

    final confirmed = await showActionConfirmDialog(
      context: context,
      message: AppStrings.exams.submitConfirm.tr(),
    );
    if (confirmed != true || !mounted) return;

    try {
      await _flushPending();
      if (!mounted) return;
      await context.read<ExamsProvider>().submitExam();
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.exams.submitted.tr())),
      );
    } on Exception catch (error) {
      if (mounted) ErrorHandler.handle(error, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamsProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final expired = _left == Duration.zero;

    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.take.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(widget.take.theme, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 18,
                  color: expired ? colors.error : colors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  expired
                      ? AppStrings.exams.unavailable.tr()
                      : _remainingLabel(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: expired ? colors.error : null,
                  ),
                ),
                if (provider.isSaving) ...[
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.exams.saving.tr(),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: colors.error)),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: widget.take.questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final question = widget.take.questions[index];
                  return _QuestionCard(
                    index: index,
                    question: question,
                    selectedChoiceId: _choices[question.id],
                    textController: _texts[question.id],
                    onChoice: (choiceId) => _saveChoice(question.id, choiceId),
                    onTextChanged: () => _scheduleTextSave(question.id),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: AppBtn(
                onPressed: provider.isSubmitting || expired ? null : _submit,
                text: AppStrings.common.submit.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int index;
  final StudentQuestion question;
  final int? selectedChoiceId;
  final TextEditingController? textController;
  final ValueChanged<int> onChoice;
  final VoidCallback onTextChanged;

  const _QuestionCard({
    required this.index,
    required this.question,
    required this.selectedChoiceId,
    required this.textController,
    required this.onChoice,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colors.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${question.text}',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                const Icon(Icons.stars_outlined, size: 16),
                const SizedBox(width: 4),
                Text('${question.points}'),
              ],
            ),
            const SizedBox(height: 10),
            if (question.type == QuestionType.choice)
              RadioGroup<int>(
                groupValue: selectedChoiceId,
                onChanged: (value) {
                  if (value != null) onChoice(value);
                },
                child: Column(
                  children: [
                    for (final choice in question.choices)
                      RadioListTile<int>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(choice.text),
                        value: choice.id,
                      ),
                  ],
                ),
              )
            else
              AppInput(
                controller: textController,
                placeholder: AppStrings.exams.answerPlaceholder.tr(),
                maxLines: 4,
                formatters: [LengthLimitingTextInputFormatter(1000)],
                onChanged: (_) => onTextChanged(),
              ),
          ],
        ),
      ),
    );
  }
}
