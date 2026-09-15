import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/features/exams/domain/exam.dart';
import 'package:app_front/features/exams/view/provider.dart';
import 'package:app_front/features/exams/view/widgets/exam_take_sheet.dart';
import 'package:app_front/features/exams/view/widgets/exam_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamsList extends StatefulWidget {
  const ExamsList({super.key});

  @override
  State<ExamsList> createState() => _ExamsListState();
}

class _ExamsListState extends State<ExamsList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    context.read<ExamsProvider>().loadMoreExams(_controller);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _open(ExamSummary exam) async {
    final provider = context.read<ExamsProvider>();
    try {
      final take = await provider.openExam(exam);
      if (!mounted) return;
      await showExamTakeSheet(context, take);
    } on Exception catch (error) {
      if (mounted) ErrorHandler.handle(error, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamsProvider>();

    if (provider.exams.isEmpty && provider.isExamsLoading) {
      return const Center(child: StandardSpinner());
    }
    if (provider.exams.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => provider.fetchExams(refresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 160),
            Icon(
              Icons.school_outlined,
              size: 52,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Center(child: Text(AppStrings.exams.empty.tr())),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchExams(refresh: true),
      child: ListView.separated(
        controller: _controller,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: provider.exams.length + (provider.hasMoreExams ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == provider.exams.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: StandardSpinner()),
            );
          }
          final exam = provider.exams[index];
          return ExamTile(exam: exam, onOpen: () => _open(exam));
        },
      ),
    );
  }
}
