import 'package:app_front/core/core.dart';

enum QuestionType {
  choice('choise'),
  input('input');

  const QuestionType(this.value);
  final String value;

  static QuestionType fromJson(String? value) => values.firstWhere(
    (item) => item.value == value,
    orElse: () => QuestionType.input,
  );
}

enum ExamSessionStatus {
  started('started'),
  submitted('submitted'),
  expired('expired');

  const ExamSessionStatus(this.value);
  final String value;

  static ExamSessionStatus fromJson(String? value) => values.firstWhere(
    (item) => item.value == value,
    orElse: () => ExamSessionStatus.submitted,
  );
}

class ExamSummary {
  const ExamSummary({
    required this.id,
    required this.title,
    required this.theme,
    required this.startAt,
    required this.durationMinutes,
    required this.deadline,
  });

  final int id;
  final String title;
  final String theme;
  final DateTime startAt;
  final int durationMinutes;
  final DateTime deadline;

  factory ExamSummary.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return ExamSummary(
      id: json['id'] as int,
      title: json['title'] as String,
      theme: json['theme'] as String,
      startAt: DateTime.parse(json['start_at'] as String),
      durationMinutes: json['duration_minutes'] as int,
      deadline: DateTime.parse(json['deadline'] as String),
    );
  }
}

class ExamListResponse {
  const ExamListResponse({required this.total, required this.exams});

  final int total;
  final List<ExamSummary> exams;

  factory ExamListResponse.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return ExamListResponse(
      total: json['total'] as int? ?? 0,
      exams: (json['exams'] as List<dynamic>? ?? [])
          .map(ExamSummary.converter)
          .toList(),
    );
  }
}

class StudentChoice {
  const StudentChoice({required this.id, required this.text});

  final int id;
  final String text;

  factory StudentChoice.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return StudentChoice(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}

class StudentQuestion {
  const StudentQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.points,
    required this.position,
    required this.choices,
  });

  final int id;
  final String text;
  final QuestionType type;
  final int points;
  final int position;
  final List<StudentChoice> choices;

  factory StudentQuestion.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return StudentQuestion(
      id: json['id'] as int,
      text: json['text'] as String,
      type: QuestionType.fromJson(json['type'] as String?),
      points: json['points'] as int,
      position: json['position'] as int? ?? 0,
      choices: (json['choices'] as List<dynamic>? ?? [])
          .map(StudentChoice.converter)
          .toList(),
    );
  }
}

class StudentSavedAnswer {
  const StudentSavedAnswer({required this.questionId, this.choiceId, this.text});

  final int questionId;
  final int? choiceId;
  final String? text;

  factory StudentSavedAnswer.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return StudentSavedAnswer(
      questionId: json['question_id'] as int,
      choiceId: json['choice_id'] as int?,
      text: json['text'] as String?,
    );
  }
}

class SessionStart {
  const SessionStart({
    required this.id,
    required this.examId,
    required this.status,
    required this.startedAt,
    required this.deadline,
  });

  final int id;
  final int examId;
  final ExamSessionStatus status;
  final DateTime startedAt;
  final DateTime deadline;

  factory SessionStart.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return SessionStart(
      id: json['id'] as int,
      examId: json['exam_id'] as int,
      status: ExamSessionStatus.fromJson(json['status'] as String?),
      startedAt: DateTime.parse(json['started_at'] as String),
      deadline: DateTime.parse(json['deadline'] as String),
    );
  }
}

class SessionTake {
  const SessionTake({
    required this.id,
    required this.examId,
    required this.status,
    required this.startedAt,
    required this.deadline,
    required this.title,
    required this.theme,
    required this.questions,
    required this.answers,
  });

  final int id;
  final int examId;
  final ExamSessionStatus status;
  final DateTime startedAt;
  final DateTime deadline;
  final String title;
  final String theme;
  final List<StudentQuestion> questions;
  final List<StudentSavedAnswer> answers;

  factory SessionTake.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    final questions = (json['questions'] as List<dynamic>? ?? [])
        .map(StudentQuestion.converter)
        .toList();
    questions.sort((a, b) => a.position.compareTo(b.position));
    return SessionTake(
      id: json['id'] as int,
      examId: json['exam_id'] as int,
      status: ExamSessionStatus.fromJson(json['status'] as String?),
      startedAt: DateTime.parse(json['started_at'] as String),
      deadline: DateTime.parse(json['deadline'] as String),
      title: json['title'] as String,
      theme: json['theme'] as String,
      questions: questions,
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map(StudentSavedAnswer.converter)
          .toList(),
    );
  }
}

class AnswerUpsertRequest implements ToJsonable {
  const AnswerUpsertRequest({this.choiceId, this.text});

  final int? choiceId;
  final String? text;

  @override
  Map<String, dynamic> toJson() {
    if (choiceId != null) return {'choice_id': choiceId};
    return {'text': text};
  }
}

class SessionSubmit {
  const SessionSubmit({
    required this.id,
    required this.examId,
    required this.status,
    required this.submittedAt,
    this.reviewedAt,
    this.score,
  });

  final int id;
  final int examId;
  final ExamSessionStatus status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final int? score;

  factory SessionSubmit.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return SessionSubmit(
      id: json['id'] as int,
      examId: json['exam_id'] as int,
      status: ExamSessionStatus.fromJson(json['status'] as String?),
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      score: json['score'] as int?,
    );
  }
}

class ExamHistoryAnswer {
  const ExamHistoryAnswer({
    required this.questionId,
    required this.questionText,
    required this.questionType,
    required this.questionPoints,
    this.choiceId,
    this.choiceText,
    this.text,
    this.awardedPoints,
  });

  final int questionId;
  final String questionText;
  final QuestionType questionType;
  final int questionPoints;
  final int? choiceId;
  final String? choiceText;
  final String? text;
  final int? awardedPoints;

  String get submittedText => text ?? choiceText ?? '';

  factory ExamHistoryAnswer.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return ExamHistoryAnswer(
      questionId: json['question_id'] as int,
      questionText: json['question_text'] as String,
      questionType: QuestionType.fromJson(json['question_type'] as String?),
      questionPoints: json['question_points'] as int,
      choiceId: json['choice_id'] as int?,
      choiceText: json['choice_text'] as String?,
      text: json['text'] as String?,
      awardedPoints: json['awarded_points'] as int?,
    );
  }
}

class ExamHistoryItem {
  const ExamHistoryItem({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.examTheme,
    required this.status,
    required this.startedAt,
    this.submittedAt,
    this.reviewedAt,
    this.score,
    required this.answers,
  });

  final int id;
  final int examId;
  final String examTitle;
  final String examTheme;
  final ExamSessionStatus status;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final int? score;
  final List<ExamHistoryAnswer> answers;

  factory ExamHistoryItem.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return ExamHistoryItem(
      id: json['id'] as int,
      examId: json['exam_id'] as int,
      examTitle: json['exam_title'] as String,
      examTheme: json['exam_theme'] as String,
      status: ExamSessionStatus.fromJson(json['status'] as String?),
      startedAt: DateTime.parse(json['started_at'] as String),
      submittedAt: json['submitted_at'] == null
          ? null
          : DateTime.parse(json['submitted_at'] as String),
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      score: json['score'] as int?,
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map(ExamHistoryAnswer.converter)
          .toList(),
    );
  }
}

class ExamHistoryResponse {
  const ExamHistoryResponse({required this.total, required this.sessions});

  final int total;
  final List<ExamHistoryItem> sessions;

  factory ExamHistoryResponse.converter(dynamic raw) {
    final json = raw as Map<String, dynamic>;
    return ExamHistoryResponse(
      total: json['total'] as int? ?? 0,
      sessions: (json['sessions'] as List<dynamic>? ?? [])
          .map(ExamHistoryItem.converter)
          .toList(),
    );
  }
}
