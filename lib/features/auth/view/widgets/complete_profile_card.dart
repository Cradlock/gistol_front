

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


class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}



class CompleteProfileCard extends StatefulWidget {
  
  @override
    State<CompleteProfileCard> createState() {
      return _CompleteProfileCard();
    }

}

class _CompleteProfileCard extends State<CompleteProfileCard> {
  ProfileErrors _errors = const ProfileErrors();  
  
  bool _isGroupsLoading = false;
  bool _isDataLoading = false;

  // Data 
  final _nameC = TextEditingController();
  final _surnameC = TextEditingController();
  int? _year;
  int? _groupId;

  List<Group> _groups = [];

  late List<int> years = [];

  Future<void> updateGroups() async {
    setState(() {
      _isGroupsLoading = true;
    }); 
  
    final res = await context.read<AuthProvider>().getGroups(_year!);
    
    if(res != null){
      setState(() {        
        _groups = res;
      });
    } else {
      await showActionConfirmDialog(
        context: context, 
        message: AppStrings.auth.please_select_other_year.tr(),
        isCancel: false
      );


    }

    setState(() {
      _isGroupsLoading = false;
    });
  } 
  
  bool _validate() {
    ProfileErrors newErrors = const ProfileErrors();

    if (_nameC.text.trim().isEmpty) {
      newErrors = newErrors.copyWith(name: AppStrings.auth.comp_name_error);
    }
    
    if (_surnameC.text.trim().isEmpty) {
      newErrors = newErrors.copyWith(surname: AppStrings.auth.comp_surname_error);
    }
    setState(() {
      _errors = newErrors;
    });

    return _errors.name == null && 
           _errors.surname == null && 
           _errors.group == null && 
           _errors.year == null;
  }
  
  @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
              _init();
      });
      
    }

  Future<void> _init() async {
    final provider = context.read<AuthProvider>();
    try{ 
      final lyears = await provider.initDataComplete();
      setState(() {
              years = lyears;
            }); 
    } on AppException catch (e) {
      ErrorHandler.handle(e);
    }
  }
    
  Future<void> _submit() async {
    if(!_validate()) return;
    setState(() {
      _isDataLoading = true;             
    });
    final data = UserCompleteRequest(
      name: _nameC.text, 
      surname: _surnameC.text, 
      groupId: _groupId!, year: _year!
    );
    
    await context.read<AuthProvider>().completeProfile(data);

    setState(() {
      _isDataLoading = false;
    });
    
  }

  @override
    Widget build(BuildContext context) {

      return PopScope(
        child: LocalLoaderWrapper(
        isLoading: _isDataLoading,
        child: Column( 
          mainAxisSize: MainAxisSize.min,
          children: [
            //Title 
            Text(AppStrings.auth.complete_data_please,style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),

            // Name 
            LabelWrapper(
              label: AppStrings.auth.name_label.tr(), 
              child: AppInput( 
                controller: _nameC,
                errorText: _errors.name?.tr(),
              )
            ),
            const SizedBox(height: 16),
            // Surname 
            LabelWrapper(
              label: AppStrings.auth.surname_label.tr(), 
              child: AppInput( 
                controller: _surnameC,
                errorText: _errors.surname?.tr()
              )
            ),
            // Course 
            const SizedBox(height: 16),

            LabelWrapper(
              label: AppStrings.auth.year_label.tr(), 
              child: AppDropdown(
                items: years,
                value: _year,
                itemAsString:(i) => i.toString(), 
                onChanged: (i) async {
                  setState(() {
                    _year = i;
                  });
                  await updateGroups();
                } 
              )
            ),
const SizedBox(height: 16),

// Group 
            LocalLoaderWrapper(
              isLoading: _isGroupsLoading, 
              child: AppDropdownInput<Group>(
                items: _groups,
                itemAsString: (i) => i.title, 
                onChanged: (val) {
                  setState(() {
                    _groupId = val!.id;                   
                  });
                }
              )
            ),
            const SizedBox(height: 16),
            
               AppBtn(
                type: AppButtonType.filled,
                text: AppStrings.common.submit,
                onPressed: _submit,
              )
          ]
        )
      ));  
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
