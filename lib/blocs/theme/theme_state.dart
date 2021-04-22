import 'package:equatable/equatable.dart';

import '../../app_theme.dart';

class ThemeState extends Equatable {
  ThemeState(this.appTheme);

  @override
  List<Object> get props => [
        appTheme.currentThemeMode,
        appTheme.currentColorMode,
        appTheme.currentFontMode
      ];

  final AppTheme appTheme;
}
