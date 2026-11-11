import 'package:app_front/entry/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unconfirmed student is sent to profile from tasks and exams', () {
    final fromTasks = resolveAuthRedirect(
      isInitialized: true,
      isLoading: false,
      isLoggedIn: true,
      isProfileComplete: true,
      isConfirmed: false,
      location: '/tasks',
    );
    final fromExams = resolveAuthRedirect(
      isInitialized: true,
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
      isInitialized: true,
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
      isInitialized: true,
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
      isInitialized: true,
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
      isInitialized: true,
      isLoading: false,
      isLoggedIn: true,
      isProfileComplete: true,
      isConfirmed: false,
      location: '/login',
    );

    expect(result.path, '/profile');
    expect(result.warnNotConfirmed, isTrue);
  });

  group('startup: splash first, decision after the token check', () {
    AuthRedirect resolve({
      bool isInitialized = true,
      bool isLoading = false,
      bool isLoggedIn = false,
      bool isProfileComplete = false,
      bool isConfirmed = false,
      required String location,
    }) => resolveAuthRedirect(
      isInitialized: isInitialized,
      isLoading: isLoading,
      isLoggedIn: isLoggedIn,
      isProfileComplete: isProfileComplete,
      isConfirmed: isConfirmed,
      location: location,
    );

    test('before the check the app stays on splash instead of going to login',
        () {
      final result = resolve(isInitialized: false, location: '/');

      expect(result.path, isNull);
    });

    test('before the check any other page is sent back to splash', () {
      for (final location in ['/login', '/tasks', '/exams', '/profile']) {
        final result = resolve(isInitialized: false, location: location);
        expect(result.path, '/', reason: location);
      }
    });

    test('before the check public legal pages stay reachable', () {
      for (final location in ['/policy', '/service']) {
        final result = resolve(isInitialized: false, location: location);
        expect(result.path, isNull, reason: location);
      }
    });

    test('while the check is running nobody is redirected', () {
      final result = resolve(isLoading: true, location: '/');

      expect(result.path, isNull);
    });

    test('no session after the check: splash goes to login', () {
      final result = resolve(location: '/');

      expect(result.path, '/login');
    });

    test('no session after the check: private pages go to login', () {
      final result = resolve(location: '/tasks');

      expect(result.path, '/login');
    });

    test('no session: login and public pages are not redirected', () {
      expect(resolve(location: '/login').path, isNull);
      expect(resolve(location: '/policy').path, isNull);
    });

    test('session with an incomplete profile goes to the questionnaire', () {
      final result = resolve(isLoggedIn: true, location: '/');

      expect(result.path, '/complete');
    });

    test('confirmed student goes from splash to profile', () {
      final result = resolve(
        isLoggedIn: true,
        isProfileComplete: true,
        isConfirmed: true,
        location: '/',
      );

      expect(result.path, '/profile');
      expect(result.warnNotConfirmed, isFalse);
    });

    test('unconfirmed student goes from splash to profile with a warning', () {
      final result = resolve(
        isLoggedIn: true,
        isProfileComplete: true,
        location: '/',
      );

      expect(result.path, '/profile');
      expect(result.warnNotConfirmed, isTrue);
    });
  });
}
