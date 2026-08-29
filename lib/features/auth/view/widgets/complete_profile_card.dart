import 'package:app_front/core/widgets/app_btn.dart';
import 'package:app_front/core/widgets/app_dropdown.dart';
import 'package:app_front/core/widgets/app_input.dart';
import 'package:app_front/core/widgets/loader_wrapper.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Предполагается, что AppBtn, AppDropdown, AppInput и LoaderWrapper уже импортированы

class CompleteProfileCard extends StatefulWidget {
  const CompleteProfileCard({super.key});

  @override
  State<StatefulWidget> createState() => _CompleteProfileCardState();
}

class _CompleteProfileCardState extends State<CompleteProfileCard> {
  // Фейковые данные чисто для визуализации UI
  final List<String> _mockCourses = ['1 курс', '2 курс', '3 курс', '4 курс'];
  final List<String> _mockGroups = ['ПИ-1-23', 'ПИ-2-23', 'ИВТ-1-23', 'ПМ-1-23'];

  @override
  Widget build(BuildContext context) {
    final pr = context.watch<AuthProvider>();


    // Используем Dialog вместо Card, так как это идеальная обертка для showDialog
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: LoaderWrapper(
        loading: pr.isLoading,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Важно для диалога, чтобы он не занял весь экран
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Завершение профиля',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Поле Имя (предполагается, что AppInput у тебя поддерживает просто placeholder)
              const AppInput(
                placeholder: 'Имя',
              ),
              const SizedBox(height: 16),
              
              // Поле Фамилия
              const AppInput(
                placeholder: 'Фамилия',
              ),
              const SizedBox(height: 16),
              
              // Выбор курса
              AppDropdown<String>(
                items: _mockCourses,
                itemAsString: (item) => item,
                placeholder: 'Курс',
                onChanged: (val) {
                  // Логика выбора курса
                },
              ),
              const SizedBox(height: 16),
              
              // Выбор группы
              AppDropdown<String>(
                items: _mockGroups,
                itemAsString: (item) => item,
                placeholder: 'Группа',
                onChanged: (val) {
                  // Логика выбора группы
                },
              ),
              const SizedBox(height: 32),
              
              // Кнопки управления
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppBtn(
                    text: 'Отмена',
                    type: AppButtonType.text,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  const SizedBox(width: 8),
                  AppBtn(
                    text: 'Сохранить',
                    type: AppButtonType.filled,
                    onPressed: () {
                      // В будущем здесь будет валидация и отправка на бэкенд
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
