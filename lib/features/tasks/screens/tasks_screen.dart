import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/features/tasks/view/provider.dart';
import 'package:app_front/features/tasks/view/widgets/tasks_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await context.read<TasksProvider>().fetchTasks(refresh: true);
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
              AppStrings.tasks.title.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const Expanded(child: TasksList()),
        ],
      ),
    );
  }
}
