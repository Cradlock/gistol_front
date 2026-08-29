

import 'package:app_front/features/auth/auth.dart';

class User {
  final int? _year;
  final Group? _group;

  final String? _name;
  final String? _surname;

  final int? _scores;

  
  const User({
    required this._name,
    required this._surname,
    required this._scores,
    required this._group,
    required this._year
  });


  int? get year => _year;
  Group? get group => _group;
  String? get name => _name;
  String? get surname => _surname;
  int? get scores => _scores;



  factory User.converter(dynamic json) {
   
    final map = json as Map<String, dynamic>;

    return User(
      name: map['name'] as String?,
      surname: map['surname'] as String?,
      scores: map['scores'] as int? ?? 0,
      year: map['year'] as int?,
      group: Group.converter(map['group'])
    );  }
}


