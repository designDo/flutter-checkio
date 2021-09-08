import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/theme/theme_event.dart';
import 'package:timefly/blocs/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(
            AppThemeMode.Light, AppThemeColorMode.Blue, AppFontMode.Roboto)) {
    AppTheme.appTheme
        .setThemeState(state.themeMode, state.themeColorMode, state.fontMode);
  }

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeChangeEvent) {
      ThemeState state =
          ThemeState(event.themeMode, event.themeColorMode, event.fontMode);
      AppTheme.appTheme
          .setThemeState(state.themeMode, state.themeColorMode, state.fontMode);
      yield state;
    } else if (event is ThemeLoadEvnet) {
      SharedPreferences shared = await SharedPreferences.getInstance();
      AppThemeMode appThemeMode =
          getInitThemeMode(shared.getString(THEME_MODE));
      AppThemeColorMode colorMode =
          getInitColorMode(shared.getString(COLOR_MODE));
      ThemeState state =
          ThemeState(appThemeMode, colorMode, AppFontMode.Roboto);
      AppTheme.appTheme
          .setThemeState(state.themeMode, state.themeColorMode, state.fontMode);
      yield state;
    }
  }
}
