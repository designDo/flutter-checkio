import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_event.dart';

class MineScreen extends StatefulWidget {
  @override
  _MineScreenState createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppThemes.values.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ThemeBloc>(context).add(
                            ThemeChangeEvent(
                                AppThemes.values[index], Fonts.Roboto));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        color: AppTheme()
                            .createTheme(AppThemes.values[index], Fonts.Roboto)
                            .primaryColor,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
