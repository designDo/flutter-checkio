import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timefly/app_theme.dart';

class SystemUtil {
  static void changeStateBarMode(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: AppTheme.appTheme.cardBackgroundColor(),
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: brightness,
    ));
  }

  static SystemUiOverlayStyle getSystemUiOverlayStyle(Brightness brightness) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: AppTheme.appTheme.cardBackgroundColor(),
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: brightness,
    );
  }
}
