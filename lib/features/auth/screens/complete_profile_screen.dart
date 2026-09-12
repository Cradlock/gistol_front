import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/core/widgets/app_dropdown.dart';
import 'package:app_front/core/widgets/app_input.dart';
import 'package:app_front/core/widgets/label_wrapper.dart';
import 'package:app_front/core/widgets/loader_wrapper.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  ProfileErrors _errors = const ProfileErrors();

  bool _isGroupsLoading = false;
  bool _isDataLoading = false;

  final _nameC = TextEditingController();
  final _surnameC = TextEditingController();
  int? _year;
  int? _groupId;

  List<Group> _groups = [];
  List<int> _years = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _nameC.dispose();
    _surnameC.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final provider = context.read<AuthProvider>();
    try {
      final lyears = await provider.initDataComplete();
      if (mounted) {
        setState(() {
          _years = lyears;
        });
      }
    } on AppException catch (e) {
      ErrorHandler.handle(e);
    }
  }

  Future<void> _updateGroups() async {
    if (_year == null) return;

    setState(() {
      _isGroupsLoading = true;
      _groupId = null; // Сбрасываем выбранную группу при смене года
      _groups = [];
    });

    try {
      final res = await context.read<AuthProvider>().getGroups(_year!);
      if (mounted) {
        if (res != null && res.isNotEmpty) {
          setState(() {
            _groups = res;
          });
        } else {
          await showActionConfirmDialog(
            context: context,
            message: AppStrings.auth.please_select_other_year.tr(),
            isCancel: false,
          );
        }
      }
    } on AppException catch (e) {
      ErrorHandler.handle(e);
    } finally {
      if (mounted) {
        setState(() {
          _isGroupsLoading = false;
        });
      }
    }
  }

  bool _validate() {
    ProfileErrors newErrors = const ProfileErrors();

    if (_nameC.text.trim().isEmpty) {
      newErrors = newErrors.copyWith(name: AppStrings.auth.comp_name_error);
    }

    if (_surnameC.text.trim().isEmpty) {
      newErrors = newErrors.copyWith(surname: AppStrings.auth.comp_surname_error);
    }

    if (_year == null) {
      newErrors = newErrors.copyWith(year: AppStrings.auth.comp_year_error);
    }

    if (_groupId == null) {
      newErrors = newErrors.copyWith(group: AppStrings.auth.comp_group_error);
    }

    setState(() {
      _errors = newErrors;
    });

    return newErrors.name == null &&
        newErrors.surname == null &&
        newErrors.group == null &&
        newErrors.year == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    setState(() {
      _isDataLoading = true;
    });

    final data = UserCompleteRequest(
      name: _nameC.text.trim(),
      surname: _surnameC.text.trim(),
      groupId: _groupId!,
      year: _year!,
    );

    try {
      await context.read<AuthProvider>().completeProfile(data);
      // При использовании GoRouter с подпиской на AuthProvider,
      // редирект на /home произойдёт автоматически из-за обновления состояния пользователя.
    } on AppException catch (e) {
      ErrorHandler.handle(e);
    } finally {
      if (mounted) {
        setState(() {
          _isDataLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return PopScope(
      canPop: false, // Запрещаем свайп/кнопку «Назад», так как заполнение профиля обязательно
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Скрываем стрелку назад
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: LocalLoaderWrapper(
          isLoading: _isDataLoading,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 450 : double.infinity,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      AppStrings.auth.complete_data_please.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Name
                    LabelWrapper(
                      label: AppStrings.auth.name_label.tr(),
                      child: AppInput(
                        controller: _nameC,
                        errorText: _errors.name?.tr(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Surname
                    LabelWrapper(
                      label: AppStrings.auth.surname_label.tr(),
                      child: AppInput(
                        controller: _surnameC,
                        errorText: _errors.surname?.tr(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Course / Year
                    LabelWrapper(
                      label: AppStrings.auth.year_label.tr(),
                      child: AppDropdown<int>(
                        items: _years,
                        value: _year,
                        errorText: _errors.year?.tr(),
                        itemAsString: (i) => i.toString(),
                        onChanged: (i) async {
                          if (i == _year) return;
                          setState(() {
                            _year = i;
                          });
                          await _updateGroups();
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Group
                    LabelWrapper(
                      label: AppStrings.auth.group_label.tr(), // Предполагаемый лейбл группы
                      child: LocalLoaderWrapper(
                        isLoading: _isGroupsLoading,
                        child: AppDropdownInput<Group>(
                          items: _groups,
                          errorText: _errors.group?.tr(),
                          itemAsString: (i) => i.title,
                          onChanged: (val) {
                            setState(() {
                              _groupId = val?.id;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Submit Button
                    AppBtn(
                      type: AppButtonType.filled,
                      text: AppStrings.common.submit.tr(),
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileErrors {
  final String? name;
  final String? surname;
  final String? group;
  final String? year;

  const ProfileErrors({
    this.name,
    this.surname,
    this.group,
    this.year,
  });

  ProfileErrors copyWith({
    String? name,
    String? surname,
    String? group,
    String? year,
  }) {
    return ProfileErrors(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      group: group ?? this.group,
      year: year ?? this.year,
    );
  }
}
