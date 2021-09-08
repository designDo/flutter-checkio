import 'package:equatable/equatable.dart';
import 'package:timefly/app_theme.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeChangeEvent extends ThemeEvent {
  ThemeChangeEvent(this.themeMode, this.themeColorMode, this.fontMode);

  @override
  List<Object> get props => [themeMode, themeColorMode, fontMode];

  final AppThemeMode themeMode;
  final AppThemeColorMode themeColorMode;
  final AppFontMode fontMode;
}

class ThemeLoadEvnet extends ThemeEvent {
  @override
  List<Object> get props => [];
}
