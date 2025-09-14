import 'package:flutter/material.dart';

class AppColorSchemes {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF3F51B5), // Indigo
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE8EAF6),
    onPrimaryContainer: Color(0xFF1A237E),
    secondary: Color(0xFF0288D1), // Light Blue
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFB3E5FC),
    onSecondaryContainer: Color(0xFF01579B),
    tertiary: Color(0xFF7B1FA2), // Purple
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE1BEE7),
    onTertiaryContainer: Color(0xFF4A0072),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFCDD2),
    onErrorContainer: Color(0xFFB71C1C),
    background: Color(0xFFFFFFFF),
    onBackground: Color(0xFF212121),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF212121),
    surfaceVariant: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF757575),
    outline: Color(0xFFB0BEC5),
    outlineVariant: Color(0xFFCFD8DC),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF37474F),
    onInverseSurface: Color(0xFFECEFF1),
    inversePrimary: Color(0xFFC5CAE9),
    surfaceTint: Color(0xFF3F51B5),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC5CAE9), // Light Indigo
    onPrimary: Color(0xFF1A237E),
    primaryContainer: Color(0xFF3F51B5),
    onPrimaryContainer: Color(0xFFE8EAF6),
    secondary: Color(0xFF4FC3F7), // Light Blue
    onSecondary: Color(0xFF01579B),
    secondaryContainer: Color(0xFF0288D1),
    onSecondaryContainer: Color(0xFFB3E5FC),
    tertiary: Color(0xFFCE93D8), // Light Purple
    onTertiary: Color(0xFF4A0072),
    tertiaryContainer: Color(0xFF7B1FA2),
    onTertiaryContainer: Color(0xFFE1BEE7),
    error: Color(0xFFEF5350),
    onError: Color(0xFF380000),
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFCDD2),
    background: Color(0xFF212121),
    onBackground: Color(0xFFECEFF1),
    surface: Color(0xFF212121),
    onSurface: Color(0xFFECEFF1),
    surfaceVariant: Color(0xFF424242),
    onSurfaceVariant: Color(0xFFB0BEC5),
    outline: Color(0xFF78909C),
    outlineVariant: Color(0xFF546E7A),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFECEFF1),
    onInverseSurface: Color(0xFF212121),
    inversePrimary: Color(0xFF3F51B5),
    surfaceTint: Color(0xFFC5CAE9),
  );
}