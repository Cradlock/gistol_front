import 'package:app_front/core/core.dart';

enum TaskAnswerStatus {
  pending('pending'),
  positive('positive'),
  negative('negative');

  final String value;
  const TaskAnswerStatus(this.value);

  factory TaskAnswerStatus.fromJson(String? value) {
    return TaskAnswerStatus.values.firstWhere(
      (item) => item.value == value,
      orElse: () => TaskAnswerStatus.pending,
    );
  }
}

class StudentTask {
  final int id;
  final String title;
  final String content;
  final int groupId;
  final DateTime startAt;
  final DateTime endAt;
  final int points;

  const StudentTask({
    required this.id,
    required this.title,
    required this.content,
    required this.groupId,
    required this.startAt,
    required this.endAt,
    required this.points,
  });

  factory StudentTask.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return StudentTask(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      groupId: json['group_id'] as int,
      startAt: DateTime.parse(json['start_at'] as String),
      endAt: DateTime.parse(json['end_at'] as String),
      points: json['points'] as int,
    );
  }
}

class StudentTaskListResponse {
  final int total;
  final List<StudentTask> tasks;

  const StudentTaskListResponse({required this.total, required this.tasks});

  factory StudentTaskListResponse.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return StudentTaskListResponse(
      total: json['total'] as int? ?? 0,
      tasks: (json['tasks'] as List<dynamic>? ?? [])
          .map(StudentTask.converter)
          .toList(),
    );
  }
}

class TaskAnswer {
  final int id;
  final int userId;
  final int taskId;
  final String text;
  final TaskAnswerStatus status;
  final DateTime submittedAt;

  const TaskAnswer({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.text,
    required this.status,
    required this.submittedAt,
  });

  factory TaskAnswer.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return TaskAnswer(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      taskId: json['task_id'] as int,
      text: json['text'] as String,
      status: TaskAnswerStatus.fromJson(json['status'] as String?),
      submittedAt: DateTime.parse(json['submitted_at'] as String),
    );
  }
}

class TaskAnswerRequest implements ToJsonable {
  final String text;

  const TaskAnswerRequest(this.text);

  @override
  Map<String, dynamic> toJson() => {'text': text};
}

class TaskHistoryItem {
  final int id;
  final int taskId;
  final String taskTitle;
  final String taskContent;
  final DateTime taskEndAt;
  final int points;
  final String text;
  final TaskAnswerStatus status;
  final DateTime submittedAt;

  const TaskHistoryItem({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.taskContent,
    required this.taskEndAt,
    required this.points,
    required this.text,
    required this.status,
    required this.submittedAt,
  });

  factory TaskHistoryItem.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return TaskHistoryItem(
      id: json['id'] as int,
      taskId: json['task_id'] as int,
      taskTitle: json['task_title'] as String,
      taskContent: json['task_content'] as String,
      taskEndAt: DateTime.parse(json['task_end_at'] as String),
      points: json['points'] as int,
      text: json['text'] as String,
      status: TaskAnswerStatus.fromJson(json['status'] as String?),
      submittedAt: DateTime.parse(json['submitted_at'] as String),
    );
  }
}

class TaskHistoryResponse {
  final int total;
  final List<TaskHistoryItem> answers;

  const TaskHistoryResponse({required this.total, required this.answers});

  factory TaskHistoryResponse.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return TaskHistoryResponse(
      total: json['total'] as int? ?? 0,
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map(TaskHistoryItem.converter)
          .toList(),
    );
  }
}
