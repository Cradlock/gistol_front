import 'package:app_front/core/widgets/app_btn.dart';
import 'package:app_front/core/widgets/app_dropdown.dart';
import 'package:app_front/core/widgets/app_input.dart';
import 'package:app_front/core/widgets/loader_wrapper.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompleteProfileCard extends StatefulWidget {
  const CompleteProfileCard({super.key});

  @override
  State<CompleteProfileCard> createState() => _CompleteProfileCardState();
}

class _CompleteProfileCardState extends State<CompleteProfileCard> {
  // Контроллеры для полей ввода
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  // Выбранные значения
  String? _selectedCourse;
  String? _selectedGroup;

  // Фейковые данные (в будущем можно заменить на данные из провайдера/сервиса)
  final List<String> _mockCourses = ['1 курс', '2 курс', '3 курс', '4 курс'];
  final List<String> _mockGroups = ['ПИ-1-23', 'ПИ-2-23', 'ИВТ-1-23', 'ПМ-1-23'];

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pr = context.watch<AuthProvider>();
    final mediaQuery = MediaQuery.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 440, // Ограничение ширины для больших экранов и планшетов
        ),
        child: LoaderWrapper(
          loading: pr.isLoading,
          child: SingleChildScrollView(
            // Делает контент прокручиваемым, защищая от переполнения при появлении клавиатуры
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                
                // Поле Имя
                AppInput(
                  controller: _nameController,
                  placeholder: 'Имя',
                ),
                const SizedBox(height: 16),
                
                // Поле Фамилия
                AppInput(
                  controller: _surnameController,
                  placeholder: 'Фамилия',
                ),
                const SizedBox(height: 16),
                
                // Выбор курса
                AppDropdown<String>(
                  items: _mockCourses,
                  itemAsString: (item) => item,
                  placeholder: 'Курс',
                  onChanged: (val) {
                    setState(() {
                      _selectedCourse = val;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Выбор группы
                AppDropdown<String>(
                  items: _mockGroups,
                  itemAsString: (item) => item,
                  placeholder: 'Группа',
                  onChanged: (val) {
                    setState(() {
                      _selectedGroup = val;
                    });
                  },
                ),
                const SizedBox(height: 32),
                
                // Кнопки управления (на мобилках в портретной ориентации лучше сделать их на всю ширину или через Wrap/Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AppBtn(
                        text: 'Отмена',
                        type: AppButtonType.text,
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppBtn(
                        text: 'Сохранить',
                        type: AppButtonType.filled,
                        onPressed: () {
                          // Здесь можно передать собранные данные назад через Navigator.pop
                          // или вызвать метод провайдера
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
