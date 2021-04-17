import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_event.dart';
import 'package:timefly/mine/mine_screen_views.dart';
import 'package:timefly/utils/system_util.dart';

class MineScreen extends StatefulWidget {
  @override
  _MineScreenState createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  @override
  Widget build(BuildContext context) {
    SystemUtil.changeStateBarMode(Brightness.dark);
    return Stack(
      children: [
        ListView(physics: ClampingScrollPhysics(), children: [
          UserInfoView(),
          HabitsTotalView(),
          UserProView(),

        ]),
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 26),
          height: 45,
          child: Container(
            width: 90,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    bottomLeft: Radius.circular(26)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: Offset(10, 2))
                ]),
          ),
        )
      ],
    );

    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppThemeMode.values.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        BlocProvider.of<ThemeBloc>(context).add(
                            ThemeChangeEvent(AppThemeMode.values[index],
                                AppThemeColorMode.Blue, AppFontMode.Roboto));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        color: AppTheme.appTheme.containerBackgroundColor(),
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
