import 'package:flutter/material.dart';

///  theme mode
enum AppThemeMode {
  Light,
  Dark,
}

///字体模式
enum AppFontMode {
  ///默认字体
  Roboto,

  ///三方字体
  MaShanZheng,
}

///颜色模式，特定view背景颜色
enum AppThemeColorMode { Blue, Purple }

class AppTheme {
  AppTheme._();

  static final AppTheme appTheme = AppTheme._();

  AppThemeMode currentThemeMode;
  AppThemeColorMode currentColorMode;
  AppFontMode currentFontMode;

  String fontFamliy;

  String numFontFamliy = 'Montserrat';

  ThemeData createTheme(AppThemeMode themeMode,
      AppThemeColorMode themeColorMode, AppFontMode fontMode) {
    currentThemeMode = themeMode;
    currentColorMode = themeColorMode;
    currentFontMode = fontMode;
    fontFamliy = fontFamily(currentFontMode);
    if (themeMode == AppThemeMode.Dark) {
      return darkTheme();
    } else {
      return lightTheme();
    }
  }

  /// 黑/白
  TextStyle headline1({FontWeight fontWeight, double fontSize}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: isDark() ? Colors.white : Colors.black,
        fontFamily: fontFamliy);
  }

  /// 黑/灰色
  TextStyle headline2({FontWeight fontWeight, double fontSize}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: isDark() ? Colors.grey : Colors.black,
        fontFamily: fontFamliy);
  }

  /// Edit hint text
  TextStyle hint({FontWeight fontWeight, double fontSize}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: isDark() ? Colors.white : Colors.black.withOpacity(0.5),
        fontFamily: fontFamliy);
  }

  /// Edit hint text
  TextStyle themeText({FontWeight fontWeight, double fontSize}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: gradientColorDark(),
        fontFamily: fontFamliy);
  }


  ///数字 粗体 28
  TextStyle numHeadline1() {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: isDark() ? Colors.white : Colors.black,
        fontFamily: numFontFamliy);
  }

  ///数字 粗体 27
  TextStyle numHeadline2() {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 27,
        color: isDark() ? Colors.white : Colors.black,
        fontFamily: numFontFamliy);
  }

  bool isDark() {
    return currentThemeMode == AppThemeMode.Dark;
  }

  TextStyle textStyle(
      {Color textColor, FontWeight fontWeight, double fontSize}) {
    return TextStyle(
        fontFamily: fontFamily(currentFontMode),
        fontSize: fontSize ?? 20,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: textColor ?? (isDark() ? Colors.white70 : Colors.black));
  }

  Color textColorMain() {
    return isDark() ? Color(0xFFF2F7FB) : Color(0xFF294261);
  }

  Color textColorSecond() {
    return isDark() ? Colors.white30 : Colors.black54;
  }

  Color containerBackgroundColor() {
    return isDark() ? Color(0xFF233355) : Color(0xFFF2F7FB);
  }

  Color cardBackgroundColor() {
    return isDark() ? Color(0xFF294261) : Colors.white;
  }

  Color selectColor() {
    return isDark() ? Colors.white : Colors.black;
  }

  Color addHabitSheetBgDark() {
    if (isDark()) {
      return Color(0xFF233355);
    }
    return gradientColorDark();
  }

  Color addHabitSheetBgLight() {
    if (isDark()) {
      return Color(0xFF294261);
    }
    return gradientColorLight();
  }

  Color gradientColorDark() {
    switch (currentColorMode) {
      case AppThemeColorMode.Blue:
        return Color(0xFF5C5EDD);
      case AppThemeColorMode.Purple:
        return Colors.deepPurple;
    }
    return Colors.white70;
  }

  Color gradientColorLight() {
    switch (currentColorMode) {
      case AppThemeColorMode.Blue:
        return Color(0xFF738AE6);
      case AppThemeColorMode.Purple:
        return Colors.purple;
    }
    return Colors.white70;
  }

  static const Color iconColor = Colors.grey;

  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
        primaryColor: Color(0xFFF2F7FB),
        primaryColorDark: Color(0xFF6B6B6B),
        primaryColorLight: Colors.blueAccent);
  }

  ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      primaryColor: Color(0xFF17262A),
      primaryColorDark: Color(0xFF6B6B6B),
    );
  }

  String fontFamily(AppFontMode fontMode) {
    switch (fontMode) {
      case AppFontMode.MaShanZheng:
        return 'MaShanZheng';
    }
    return 'Roboto';
  }

  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'Roboto';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: Colors.deepPurple,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}
