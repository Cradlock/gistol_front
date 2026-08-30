import 'package:app_front/core/core.dart';
import 'package:app_front/core/widgets/app_btn.dart';
import 'package:app_front/core/widgets/app_dropdown.dart';
import 'package:app_front/core/widgets/app_input.dart';
import 'package:app_front/core/widgets/loader_wrapper.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Выбор : имя фамилия курс группа
class CompleteProfileCard extends StatefulWidget {
  const CompleteProfileCard({super.key});

  @override
  State<CompleteProfileCard> createState() => _CompleteProfileCardState();
}

class _CompleteProfileCardState extends State<CompleteProfileCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  int? _selectedCourse;
  int? _selectedGroupId;
  
  String? errorName;
  String? errorSurname;
  String? errorCourse;
  String? errorGroupId;

  List<int> _courses = [];
  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }
  
  Future<void> _initData() async {
    final provider = context.read<AuthProvider>();
    await provider.initDataComplete();
    if (mounted) {
      setState(() {
        _courses = provider.years;
      });
    }
  }

  Future<void> _onCourseChanged(int? course) async {
    setState(() {
      _selectedCourse = course;
      _selectedGroupId = null; // Сбрасываем выбранную группу при смене курса
      _groups = [];
      errorCourse = null;
    });

    if (course != null) {
      final provider = context.read<AuthProvider>();
      await provider.getGroups(course);
      if (mounted) {
        setState(() {
          _groups = provider.groups.value; // Берем группы из провайдера
        });
      }
    }
  }

  bool _check() {
    bool isValid = true;
    setState(() {
      errorName = _nameController.text.trim().isEmpty ? "field_required".tr() : null;
      errorSurname = _surnameController.text.trim().isEmpty ? "field_required".tr() : null;
      errorCourse = _selectedCourse == null ? "field_required".tr() : null;
      errorGroupId = _selectedGroupId == null ? "field_required".tr() : null;
    });

    if (errorName != null || errorSurname != null || errorCourse != null || errorGroupId != null) {
      isValid = false;
    }

    return isValid;
  }

  Future<void> _submit() async {  
    if (!_check()) return;
    
    final provider = context.read<AuthProvider>();
    await provider.completeProfile(
      _nameController.text.trim(),
      _surnameController.text.trim(),
      _selectedGroupId!,
      _selectedCourse!,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pr = context.watch<AuthProvider>();

    return CardResponsive(
      child: LoaderWrapper(  
        loading: pr.isLoading,
        child: Column( 
          mainAxisSize: MainAxisSize.min,

          children: [
            // Имя
            AppInput(
              controller: _nameController,
              placeholder: "name".tr(),
              errorText: errorName,
              onChanged: (_) => setState(() => errorName = null),
            ),
            const SizedBox(height: 12),

            // Фамилия  
            AppInput(
              controller: _surnameController,
              placeholder: "surname".tr(),
              errorText: errorSurname,
              onChanged: (_) => setState(() => errorSurname = null),
            ),
            const SizedBox(height: 12),

            // Курс  
            AppDropdown<int>(
              items: _courses,  
              itemAsString: (value) => "$value ${"course_label".tr()}", 
              errorText: errorCourse,
              onChanged: _onCourseChanged,
            ),
            const SizedBox(height: 12),

            // Группы
            LoaderWrapper(
              loading: pr.isGroupsLoading,  
              child: AppDropdown<Group>(
                items: _groups,  
                itemAsString: (value) => value.title,
                errorText: errorGroupId,
                onChanged: (value) {
                  setState(() {
                    _selectedGroupId = value?.id;
                    errorGroupId = null;
                  });
                },
              ),
            ),
            

            const SizedBox(height: 24),
            
            FormActionButtons(
              cancelText: "cancel".tr(),
              saveText: "save".tr(),
              onCancel: () => Navigator.pop(context, false),
              onSave: _submit,
            ),
          ],
        ),
      ),
    );  
  }
}
