import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/features/exams/view/provider.dart';
import 'package:app_front/features/exams/view/widgets/exams_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await context.read<ExamsProvider>().fetchExams(refresh: true);
      } on Exception catch (error) {
        if (mounted) ErrorHandler.handle(error, context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              AppStrings.exams.title.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const Expanded(child: ExamsList()),
        ],
      ),
    );
  }
}
