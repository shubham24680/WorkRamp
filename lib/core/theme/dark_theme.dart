import 'package:flutter/material.dart';
import 'package:tickit/core/utils/app_colors.dart';

final ThemeData dark = ThemeData(
  scaffoldBackgroundColor: black,
  appBarTheme: AppBarTheme(
    backgroundColor: black,
    surfaceTintColor: black,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: white,
    selectionColor: white.withOpacity(0.4),
    selectionHandleColor: white,
  ),
);
