import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/features/tasks/domain/task.dart';
import 'package:app_front/features/tasks/view/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> showTaskAnswerSheet(BuildContext context, StudentTask task) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => TaskAnswerSheet(task: task),
  );
}

class TaskAnswerSheet extends StatefulWidget {
  final StudentTask task;

  const TaskAnswerSheet({super.key, required this.task});

  @override
  State<TaskAnswerSheet> createState() => _TaskAnswerSheetState();
}

class _TaskAnswerSheetState extends State<TaskAnswerSheet> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = AppStrings.common.errorBlankInput.tr());
      return;
    }

    try {
      await context.read<TasksProvider>().submitAnswer(widget.task, text);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.tasks.answerSent.tr())),
      );
    } on Exception catch (error) {
      if (!mounted) return;
      ErrorHandler.handle(error, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasksProvider>();
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(widget.task.content),
            const SizedBox(height: 20),
            AppInput(
              controller: _controller,
              placeholder: AppStrings.tasks.answerPlaceholder.tr(),
              errorText: _error,
              maxLines: 5,
              formatters: [LengthLimitingTextInputFormatter(255)],
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppBtn(
                onPressed: provider.isSubmitting ? null : _submit,
                text: AppStrings.common.submit.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
