import 'package:flutter/services.dart';

class TaskTextPasteGuard extends TextInputFormatter {
  TaskTextPasteGuard({required this.title, required this.content});

  final String title;
  final String content;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (introducesTaskText(
      oldValue.text,
      newValue.text,
      title: title,
      content: content,
    )) {
      return oldValue;
    }
    return newValue;
  }
}

bool introducesTaskText(
  String before,
  String after, {
  required String title,
  required String content,
}) {
  if (after.length <= before.length) return false;
  return _gained(before, after, title) || _gained(before, after, content);
}

bool _gained(String before, String after, String source) {
  final sourceNorm = _norm(source);
  if (sourceNorm.isEmpty) return false;
  final beforeNorm = _norm(before);
  final afterNorm = _norm(after);
  if (afterNorm.contains(sourceNorm) && !beforeNorm.contains(sourceNorm)) {
    return true;
  }

  final inserted = _norm(_inserted(before, after));
  if (inserted.length < 24) return false;
  return sourceNorm.contains(inserted);
}

String _inserted(String before, String after) {
  var start = 0;
  final shared = before.length < after.length ? before.length : after.length;
  while (start < shared && before.codeUnitAt(start) == after.codeUnitAt(start)) {
    start++;
  }
  var endBefore = before.length;
  var endAfter = after.length;
  while (endBefore > start &&
      endAfter > start &&
      before.codeUnitAt(endBefore - 1) == after.codeUnitAt(endAfter - 1)) {
    endBefore--;
    endAfter--;
  }
  return after.substring(start, endAfter);
}

String _norm(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
