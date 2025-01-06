import 'package:flutter/material.dart';

class CustomToggleButtonsTheme extends ThemeExtension<CustomToggleButtonsTheme> {
  final Color? selectedBorderColor;
  final Color? fillColor;
  final BorderRadius? borderRadius;

  const CustomToggleButtonsTheme({
    this.selectedBorderColor,
    this.fillColor,
    this.borderRadius,
  });

  CustomToggleButtonsTheme copyWith({
    Color? selectedBorderColor,
    Color? fillColor,
    BorderRadius? borderRadius,
  }) {
    return CustomToggleButtonsTheme(
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      fillColor: fillColor ?? this.fillColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ThemeExtension<CustomToggleButtonsTheme> lerp(covariant ThemeExtension<CustomToggleButtonsTheme>? other, double t) {
    if (other is! CustomToggleButtonsTheme) {
      return this;
    }

    return CustomToggleButtonsTheme(
      selectedBorderColor: Color.lerp(selectedBorderColor, other.selectedBorderColor, t),
      fillColor: Color.lerp(fillColor, other.fillColor, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
    );
  }
}
