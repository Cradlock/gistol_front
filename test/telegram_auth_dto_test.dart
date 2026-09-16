import 'package:app_front/features/auth/domain/telegram_user.dart';
import 'package:app_front/features/auth/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('new telegram user without profile still parses', () {
    final user = User.converter({
      'id': 11,
      'name': null,
      'surname': null,
      'scores': 0,
      'year': 1,
      'group_id': null,
      'group': null,
      'role': 3,
      'confirmed': false,
    });

    expect(user.name, isNull);
    expect(user.group, isNull);
    expect(user.groupId, isNull);
    expect(user.year, 1);
    expect(user.confirmed, isFalse);
  });

  test('complete profile response can use group_id without nested group', () {
    final user = User.converter({
      'id': 11,
      'name': 'Ann',
      'surname': 'Lee',
      'scores': 0,
      'year': 2,
      'group_id': 4,
      'group': null,
      'confirmed': false,
    });

    expect(user.groupId, 4);
    expect(user.name, 'Ann');
  });

  test('telegram auth response maps tokens and nullable user fields', () {
    final response = TelegramAuthResponse.converter({
      'access_token': 'access',
      'refresh_token': 'refresh',
      'user': {
        'id': 11,
        'name': null,
        'surname': null,
        'scores': 0,
        'year': 1,
        'group': null,
        'confirmed': false,
      },
    });

    expect(response.tokens.access_token, 'access');
    expect(response.tokens.refresh_token, 'refresh');
    expect(response.user.year, 1);
  });
}
