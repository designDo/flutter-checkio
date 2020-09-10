import 'package:equatable/equatable.dart';
import 'package:timefly/app_theme.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ThemeChangeEvent extends ThemeEvent {
  ThemeChangeEvent(this.themes, this.fonts);

  @override
  List<Object> get props => [themes, fonts];

  final AppThemes themes;
  final Fonts fonts;
}
