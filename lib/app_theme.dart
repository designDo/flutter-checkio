import 'package:flutter/material.dart';

/// app theme
///

enum AppThemes {
  ///蓝色
  Blue,

  ///紫色
  Purple,
}

enum Fonts {
  ///默认字体
  Roboto,

  ///三方字体
  MaShanZheng,
}

class AppTheme {
  ThemeData createTheme(AppThemes targetTheme, Fonts targetFont) {
    return ThemeData.light().copyWith(
        primaryColor: primaryColor(targetTheme),
        primaryColorLight: primaryColorLight(targetTheme),
        primaryColorDark: primaryColorDark(targetTheme),
        accentColor: accentColor(targetTheme),
        textTheme: TextTheme(
            headline5:
                TextStyle(fontFamily: fontFamily(targetFont), fontSize: 23),
            headline6: TextStyle(
              fontFamily: fontFamily(targetFont),
              fontSize: 20,
            ),
            subtitle1: TextStyle(
              fontFamily: fontFamily(targetFont),
              fontSize: 18,
            ),
            subtitle2: TextStyle(
              fontFamily: fontFamily(targetFont),
              fontSize: 16,
            )));
  }

  Color primaryColor(AppThemes theme) {
    switch (theme) {
      case AppThemes.Blue:
        return normal_blue;
      case AppThemes.Purple:
        return normal_purple;
    }
    return Colors.white;
  }

  Color primaryColorLight(AppThemes theme) {
    switch (theme) {
      case AppThemes.Blue:
        return light_blue;
      case AppThemes.Purple:
        return light_purple;
    }
    return Colors.white;
  }

  Color primaryColorDark(AppThemes theme) {
    switch (theme) {
      case AppThemes.Blue:
        return dark_blue;
      case AppThemes.Purple:
        return dark_purple;
    }
    return Colors.white;
  }

  Color accentColor(AppThemes theme) {
    switch (theme) {
      case AppThemes.Blue:
        return accent_blue;
      case AppThemes.Purple:
        return accent_purple;
    }
    return Colors.white;
  }

  String fontFamily(Fonts fonts) {
    switch (fonts) {
      case Fonts.MaShanZheng:
        return 'MaShanZheng';
    }
    return 'Roboto';
  }

  static const Color normal_blue = Color(0xff3f9bad);
  static const Color light_blue = Color(0xff7599f6);
  static const Color dark_blue = Color(0xff4392b2);
  static const Color accent_blue = Color(0xff7599f6);

  ///渐变色深
  static const Color normal_purple = Color(0xFF7a70c5);

  ///渐变色浅
  static const Color light_purple = Color(0xFF8389ea);

  ///深色button
  static const Color dark_purple = Color(0xFF7b7ad1);

  ///浅色颜色
  static const Color accent_purple = Color(0xff5696c9);

  ///不可用字体颜色
  static const Color text_unable = Color(0xFFbcbaea);

  ///可用字体颜色
  static const Color text_enable = Color(0xffe7e7fa);

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
