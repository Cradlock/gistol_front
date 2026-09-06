

import 'package:app_front/core/core.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';

class User {
  final int? _year;
  final Group? _group;

  final String? _name;
  final String? _surname;

  final int? _scores;
  
  final bool? _confirmed;
  
  const User({
    required this._name,
    required this._surname,
    required this._scores,
    required this._group,
    required this._year,
    required this._confirmed
  });


  int? get year => _year;
  Group? get group => _group;
  String? get name => _name;
  String? get surname => _surname;
  int? get scores => _scores;
  bool? get confirmed => _confirmed;


  factory User.converter(dynamic json) {
   
    final map = json as Map<String, dynamic>;

    return User(
      name: map['name'] as String?,
      surname: map['surname'] as String?,
      scores: map['scores'] as int? ?? 0,
      year: map['year'] as int?,
      group:map['group'] != null ? Group.converter(map['group']) : null, 
      confirmed: map['confirmed'] != null ? map['confirmed'] as bool : false
    );  
    }
}


