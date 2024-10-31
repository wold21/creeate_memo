import 'package:flutter/material.dart';

class CustomTheme extends ThemeExtension<CustomTheme> {
  final Color colorSubGrey;
  final Color colorDeepGrey;
  final Color backgroundColor;
  final Color calenderColor;
  final Color borderColor;
  final Color recordCreateColor;
  final Color recordTileBorderColor;

  const CustomTheme(
      {required this.colorSubGrey,
      required this.colorDeepGrey,
      required this.backgroundColor,
      required this.calenderColor,
      required this.borderColor,
      required this.recordCreateColor,
      required this.recordTileBorderColor});

  @override
  CustomTheme copyWith({
    Color? colorSubGrey,
    Color? colorDeepGrey,
    Color? backgroundColor,
    Color? calenderColor,
    Color? borderColor,
    Color? recordCreateColor,
    Color? recordTileBorderColor,
  }) {
    return CustomTheme(
        colorSubGrey: colorSubGrey ?? this.colorSubGrey,
        colorDeepGrey: colorDeepGrey ?? this.colorDeepGrey,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        calenderColor: calenderColor ?? this.calenderColor,
        borderColor: borderColor ?? this.borderColor,
        recordCreateColor: recordCreateColor ?? this.recordCreateColor,
        recordTileBorderColor:
            recordTileBorderColor ?? this.recordTileBorderColor);
  }

  @override
  CustomTheme lerp(ThemeExtension<CustomTheme>? other, double t) {
    if (other is! CustomTheme) return this;
    return CustomTheme(
        colorSubGrey: Color.lerp(colorSubGrey, other.colorSubGrey, t)!,
        colorDeepGrey: Color.lerp(colorDeepGrey, other.colorDeepGrey, t)!,
        backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
        calenderColor: Color.lerp(calenderColor, other.calenderColor, t)!,
        borderColor: Color.lerp(borderColor, other.borderColor, t)!,
        recordCreateColor:
            Color.lerp(recordCreateColor, other.recordCreateColor, t)!,
        recordTileBorderColor:
            Color.lerp(recordTileBorderColor, other.recordTileBorderColor, t)!);
  }
}
