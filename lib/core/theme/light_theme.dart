import 'package:flutter/material.dart';
import 'package:tickit/core/utils/app_colors.dart';

final ThemeData light = ThemeData(
  scaffoldBackgroundColor: AppColor.white,
  colorScheme: ColorScheme.light(
    primary: AppColor.white,
    secondary: AppColor.white),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColor.white,
    surfaceTintColor: AppColor.white),
  iconTheme: IconThemeData(
    color: AppColor.white),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColor.blue_1,
    selectionColor: AppColor.blue_1.withAlpha(100),
    selectionHandleColor: AppColor.blue_1),
);
