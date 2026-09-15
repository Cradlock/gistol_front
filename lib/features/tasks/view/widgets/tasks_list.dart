import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/features/tasks/view/provider.dart';
import 'package:app_front/features/tasks/view/widgets/task_answer_sheet.dart';
import 'package:app_front/features/tasks/view/widgets/task_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    context.read<TasksProvider>().loadMoreTasks(_controller);
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
    final provider = context.watch<TasksProvider>();

    if (provider.tasks.isEmpty && provider.isTasksLoading) {
      return const Center(child: StandardSpinner());
    }
    if (provider.tasks.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => provider.fetchTasks(refresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 160),
            Icon(
              Icons.task_alt,
              size: 52,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Center(child: Text(AppStrings.tasks.empty.tr())),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchTasks(refresh: true),
      child: ListView.separated(
        controller: _controller,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: provider.tasks.length + (provider.hasMoreTasks ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == provider.tasks.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: StandardSpinner()),
            );
          }
          final task = provider.tasks[index];
          return TaskTile(
            task: task,
            onAnswer: () => showTaskAnswerSheet(context, task),
          );
        },
      ),
    );
  }
}
