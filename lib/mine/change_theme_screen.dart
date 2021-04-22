import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_event.dart';
import 'package:timefly/blocs/theme/theme_state.dart';

import '../app_theme.dart';

class ChangeThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          AppTheme appTheme = state.appTheme;

          return ListView(
            children: [
              Row(
                children: AppThemeMode.values
                    .map((mode) => GestureDetector(
                          onTap: () {
                            BlocProvider.of<ThemeBloc>(context).add(
                                ThemeChangeEvent(
                                    mode,
                                    appTheme.currentColorMode,
                                    appTheme.currentFontMode));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 32),
                            width: 100,
                            height: 100,
                            color: AppTheme.modeMainColor(mode),
                            child: mode == appTheme.currentThemeMode
                                ? Icon(Icons.check)
                                : SizedBox(),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        BlocProvider.of<ThemeBloc>(context).add(
                            ThemeChangeEvent(
                                appTheme.currentThemeMode,
                                AppThemeColorMode.values[index],
                                appTheme.currentFontMode));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 32),
                        height: 100,
                        width: 100,
                        color: AppTheme.themeMainColor(
                            AppThemeColorMode.values[index]),
                        child: AppThemeColorMode.values[index] ==
                                appTheme.currentColorMode
                            ? Icon(Icons.check)
                            : SizedBox(),
                      ),
                    );
                  },
                  itemCount: AppThemeColorMode.values.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
