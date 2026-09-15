import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/features/exams/view/provider.dart';
import 'package:app_front/features/exams/view/widgets/exam_history_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamHistorySheet extends StatefulWidget {
  const ExamHistorySheet({super.key});

  @override
  State<ExamHistorySheet> createState() => _ExamHistorySheetState();
}

class _ExamHistorySheetState extends State<ExamHistorySheet> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    try {
      await context.read<ExamsProvider>().fetchHistory(refresh: true);
    } on Exception catch (error) {
      if (mounted) ErrorHandler.handle(error, context: context);
    }
  }

  void _onScroll() {
    context.read<ExamsProvider>().loadMoreHistory(_controller).catchError((
      Object error,
    ) {
      if (mounted && error is Exception) {
        ErrorHandler.handle(error, context: context);
      }
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamsProvider>();

    return FractionallySizedBox(
      heightFactor: 0.82,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Text(
              AppStrings.profile.examHistory.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (provider.history.isEmpty && provider.isHistoryLoading) {
                    return const Center(child: StandardSpinner());
                  }
                  if (provider.history.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Text(
                              AppStrings.profile.examHistoryEmpty.tr(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.separated(
                      controller: _controller,
                      itemCount:
                          provider.history.length +
                          (provider.hasMoreHistory ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        if (index == provider.history.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: StandardSpinner()),
                          );
                        }
                        return ExamHistoryTile(item: provider.history[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
