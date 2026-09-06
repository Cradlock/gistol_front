import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF415f91),
        brightness: Brightness.light,
      ),
      textTheme: _buildTextTheme(),
      elevatedButtonTheme: _buildButtonTheme(isDark: false),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFaaccff),
        brightness: Brightness.dark,
      ),
      textTheme: _buildTextTheme(isDark: true),
      elevatedButtonTheme: _buildButtonTheme(isDark: true),
    );
  }
  
  static TextTheme _buildTextTheme({bool isDark = false}) {
    final baseColor = isDark ? Colors.white70 : Colors.black87;
    final secondaryColor = isDark ? Colors.white54 : Colors.black54;

    return TextTheme(
      displayLarge: TextStyle(fontSize: 46.sp, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.normal, letterSpacing: 0.5),
      bodyLarge: TextStyle(fontSize: 16.sp, color: baseColor, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14.sp, color: secondaryColor),
      labelLarge: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
    );
  }

  static ElevatedButtonThemeData _buildButtonTheme({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? const Color(0xFFaaccff) : Colors.blue,
        foregroundColor: isDark ? const Color(0xFF0a305f) : Colors.white,
        shadowColor: isDark ? Colors.black54 : Colors.blueGrey,
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
