import 'package:flutter/material.dart';

const kColorPrimary = Color(0xFF864D36);
const kColorPrimaryLight = Color(0xFFBF6E4C);
const kColorSecondary = Color(0xFF605226);
const kColorSecondaryLight = Color(0xFF867950);
const kColorBackgroundLight = Color(0xFFEDE7D8);
const kColorWhite = Colors.white;
const kColorError = Colors.redAccent;

class GlobalTheme {
  final globalTheme = ThemeData(
    colorScheme: _customColorScheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: kColorSecondary,
        onPrimary: kColorWhite,
      ),
    ),
  );
}

const ColorScheme _customColorScheme = ColorScheme(
  primary: kColorPrimary,
  secondary: kColorSecondary,
  surface: kColorBackgroundLight,
  background: kColorWhite,
  error: kColorError,
  onPrimary: kColorPrimaryLight,
  onSecondary: kColorSecondaryLight,
  onSurface: kColorPrimary,
  onBackground: kColorPrimary,
  onError: kColorBackgroundLight,
  brightness: Brightness.light,
);
