

import 'package:app_front/core/core.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';

class User {
  final int? _year;
  final Group? _group;
  final int? _groupId;

  final String? _name;
  final String? _surname;

  final int? _scores;
  
  final bool? _confirmed;
  
  const User({
    required this._name,
    required this._surname,
    required this._scores,
    required this._group,
    this._groupId,
    required this._year,
    required this._confirmed
  });


  int? get year => _year;
  Group? get group => _group;
  int? get groupId => _groupId ?? _group?.id;
  String? get name => _name;
  String? get surname => _surname;
  int? get scores => _scores;
  bool? get confirmed => _confirmed;


  factory User.converter(dynamic json) {
    if (json is! Map) {
      throw const FormatException('User payload must be an object');
    }
    final map = Map<String, dynamic>.from(json);
    final group = map['group'] != null ? Group.converter(map['group']) : null;
    final groupId = (map['group_id'] as num?)?.toInt() ?? group?.id;

    return User(
      name: map['name'] as String?,
      surname: map['surname'] as String?,
      scores: (map['scores'] as num?)?.toInt() ?? 0,
      year: (map['year'] as num?)?.toInt(),
      group: group,
      groupId: groupId,
      confirmed: map['confirmed'] as bool? ?? false,
    );
  }
}


