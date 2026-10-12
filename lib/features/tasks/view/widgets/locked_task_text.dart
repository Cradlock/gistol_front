import 'package:flutter/material.dart';

class LockedTaskText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const LockedTaskText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: Text(text, style: style, maxLines: maxLines, overflow: overflow),
    );
  }
}
