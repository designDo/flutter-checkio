import 'package:equatable/equatable.dart';

import '../../app_theme.dart';

class ThemeState extends Equatable {
  ThemeState(this.themeMode, this.themeColorMode, this.fontMode);

  @override
  List<Object> get props => [themeMode, themeColorMode, fontMode];

  final AppThemeMode themeMode;
  final AppThemeColorMode themeColorMode;
  final AppFontMode fontMode;
}
