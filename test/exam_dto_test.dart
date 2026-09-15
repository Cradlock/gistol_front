import 'package:app_front/features/exams/domain/exam.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('choice answer upsert sends only choice_id', () {
    const request = AnswerUpsertRequest(choiceId: 11);

    expect(request.toJson(), {'choice_id': 11});
  });

  test('text answer upsert sends only text', () {
    const request = AnswerUpsertRequest(text: 'variable');

    expect(request.toJson(), {'text': 'variable'});
  });

  test('student question converter ignores answer keys', () {
    final question = StudentQuestion.converter({
      'id': 1,
      'text': 'Two plus two?',
      'type': 'choise',
      'points': 2,
      'position': 0,
      'expected_answer': '4',
      'choices': [
        {'id': 8, 'text': '4', 'is_correct': true},
        {'id': 9, 'text': '5', 'is_correct': false},
      ],
    });

    expect(question.type, QuestionType.choice);
    expect(question.choices.map((item) => item.id), [8, 9]);
    expect(question.choices.first.text, '4');
  });

  test('history item keeps submitted answers without teacher keys', () {
    final item = ExamHistoryItem.converter({
      'id': 4,
      'exam_id': 3,
      'exam_title': 'Midterm',
      'exam_theme': 'Algebra',
      'status': 'submitted',
      'started_at': '2026-09-15T10:00:00Z',
      'submitted_at': '2026-09-15T10:40:00Z',
      'reviewed_at': '2026-09-15T11:00:00Z',
      'score': 2,
      'answers': [
        {
          'question_id': 1,
          'question_text': 'Two plus two?',
          'question_type': 'choise',
          'question_points': 2,
          'choice_id': 8,
          'choice_text': '4',
          'text': null,
          'awarded_points': 2,
        },
      ],
    });

    expect(item.examTitle, 'Midterm');
    expect(item.answers.single.submittedText, '4');
    expect(item.answers.single.awardedPoints, 2);
  });
}
