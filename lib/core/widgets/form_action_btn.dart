import 'package:app_front/core/widgets/app_btn.dart';
import 'package:flutter/material.dart';

class FormActionButtons extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final String cancelText;
  final String saveText;

  const FormActionButtons({
    super.key,
    this.onCancel,
    this.onSave,
    this.cancelText = 'Отмена',
    this.saveText = 'Сохранить',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
          AppBtn(
            text: cancelText,
            type: AppButtonType.text,
            onPressed: onCancel,
          ),
        const SizedBox(width: 12),
          AppBtn(
            text: saveText,
            type: AppButtonType.filled,
            onPressed: onSave,
          ),
      ],
    );
  }
}
