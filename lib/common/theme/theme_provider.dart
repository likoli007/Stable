import 'package:flutter/material.dart';
import 'package:stable/common/theme/color_extension.dart';
import 'package:stable/common/theme/toggle_buttons_theme.dart';
import 'package:stable/common/util/shared_ui_constants.dart';

const _PRIMARY_COLOR = Color(0xFFF57C00);

class ThemeProvider {
  ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: _PRIMARY_COLOR,
          onPrimary: Colors.white,
          primaryContainer: Colors.orange.shade100,
          onPrimaryContainer: Colors.orange.shade900,
          secondary: Colors.deepOrange.shade400,
          onSecondary: Colors.white,
          secondaryContainer: Colors.deepOrange.shade100,
          onSecondaryContainer: Colors.deepOrange.shade900,
          tertiary: Colors.amber.shade600,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.amber.shade100,
          onTertiaryContainer: Colors.amber.shade900,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.orange.shade50,
          onSurface: Colors.black,
          error: Colors.red.shade700,
          onError: Colors.white,
          outline: Colors.orange.shade300,
          shadow: Colors.black,
          surfaceTint: Colors.orange.shade700,
        ),
        cardTheme: CardTheme(
          clipBehavior: Clip.hardEdge,
          surfaceTintColor: Colors.transparent,
          color: Colors.deepOrangeAccent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,
        ),
        // extensions: [
        //   CustomToggleButtonsTheme(
        //     borderRadius: BorderRadius.circular(10.0),
        //     selectedBorderColor: _PRIMARY_COLOR,
        //     fillColor: _PRIMARY_COLOR.withOpacity(0.1),
        //   ),
        // ],
      );

  ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.orange.shade300,
          onPrimary: Colors.black,
          primaryContainer: Colors.orange.shade900,
          onPrimaryContainer: Colors.white,
          secondary: Colors.deepOrange.shade200,
          onSecondary: Colors.black,
          secondaryContainer: Colors.deepOrange.shade700,
          onSecondaryContainer: Colors.white,
          tertiary: Colors.amber.shade300,
          onTertiary: Colors.black,
          tertiaryContainer: Colors.amber.shade700,
          onTertiaryContainer: Colors.white,
          background: Colors.grey.shade900,
          onBackground: Colors.white,
          surface: Colors.orange.shade800,
          onSurface: Colors.white,
          error: Colors.red.shade400,
          onError: Colors.black,
          outline: Colors.orange.shade400,
          shadow: Colors.black,
          surfaceTint: Colors.orange.shade300,
        ),
      );

  ThemeData themeSeeded(
      {required Color seedColor, Brightness brightness = Brightness.light}) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.hardEdge,
        surfaceTintColor: Colors.transparent,
        color: seedColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: seedColor.getForegroundColorDependingOnBackground(),
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          color: seedColor.getForegroundColorDependingOnBackground(),
        ),
        displaySmall: TextStyle(
          color: seedColor.getForegroundColorDependingOnBackground(),
        ),
        labelMedium: TextStyle(
          fontSize: MEDIUM_FONT_SIZE,
        ),
      ),
      extensions: [
        CustomToggleButtonsTheme(
          borderRadius: BorderRadius.circular(10.0),
          selectedBorderColor: seedColor,
          fillColor: seedColor.withOpacity(0.1),
        ),
      ],
    );
  }
}
