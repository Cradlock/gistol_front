import 'package:app_front/entry/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unconfirmed student is sent to profile from tasks and exams', () {
    final fromTasks = resolveAuthRedirect(
      isLoading: false,
      isLoggedIn: true,
      isProfileComplete: true,
      isConfirmed: false,
      location: '/tasks',
    );
    final fromExams = resolveAuthRedirect(
      isLoading: false,
      isLoggedIn: true,
      isProfileComplete: true,
      isConfirmed: false,
      location: '/exams',
    );

    expect(fromTasks.path, '/profile');
    expect(fromTasks.warnNotConfirmed, isTrue);
    expect(fromExams.path, '/profile');
    expect(fromExams.warnNotConfirmed, isTrue);
  });

  test('unconfirmed student can stay on profile', () {
    final result = resolveAuthRedirect(
      isLoading: false,
      isLoggedIn: true,
      isProfileComplete: true,
      isConfirmed: false,
      location: '/profile',
    );

    expect(result.path, isNull);
    expect(result.warnNotConfirmed, isFalse);
  });

  test('confirmed student can open tasks', () {
    final result = resolveAuthRedirect(
      isLoading: false,
      isLoggedIn: true,
      isProfileComplete: true,
      isConfirmed: true,
      location: '/tasks',
    );

    expect(result.path, isNull);
    expect(result.warnNotConfirmed, isFalse);
  });

  test('unconfirmed student can open public legal pages', () {
    final result = resolveAuthRedirect(
      isLoading: false,
      isLoggedIn: true,
      isProfileComplete: true,
      isConfirmed: false,
      location: '/policy',
    );

    expect(result.path, isNull);
    expect(result.warnNotConfirmed, isFalse);
  });

  test('login of unconfirmed student goes to profile with warning', () {
    final result = resolveAuthRedirect(
      isLoading: false,
      isLoggedIn: true,
      isProfileComplete: true,
      isConfirmed: false,
      location: '/login',
    );

    expect(result.path, '/profile');
    expect(result.warnNotConfirmed, isTrue);
  });
}
