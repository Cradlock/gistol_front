import 'package:app_front/features/tasks/domain/task_paste_guard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const title = 'Эмбриология';
  const content = 'Опишите стадии дробления зиготы и назовите итог каждой стадии.';

  TextEditingValue guard(String before, String after) {
    return TaskTextPasteGuard(title: title, content: content).formatEditUpdate(
      TextEditingValue(text: before),
      TextEditingValue(text: after),
    );
  }

  test('typing an ordinary answer is kept', () {
    final result = guard('Стадии: ', 'Стадии: морула');

    expect(result.text, 'Стадии: морула');
  });

  test('pasting the task text is rejected', () {
    final result = guard('', content);

    expect(result.text, isEmpty);
  });

  test('pasting the task inside an answer is rejected', () {
    final result = guard('Ответ. ', 'Ответ. $content');

    expect(result.text, 'Ответ. ');
  });

  test('a long excerpt of the task is rejected', () {
    final result = guard('', 'стадии дробления зиготы и назовите итог');

    expect(result.text, isEmpty);
  });
}
