

import 'package:app_front/features/auth/auth.dart';

class User {
  final Year _year;
  final Group _group;

  final String _name;
  final String _surname;

  final int _scores;

  
  const User({
    required this._name,
    required this._surname,
    required this._scores,
    required this._group,
    required this._year
  });


  Year get year => _year;
  Group get group => _group;
  String get name => _name;
  String get surname => _surname;
  int get scores => _scores;


}


