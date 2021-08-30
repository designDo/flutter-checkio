import 'package:data_plugin/bmob/bmob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_state.dart';
import 'package:timefly/home_screen.dart';
import 'package:timefly/notification/notification_plugin.dart';
import 'package:timefly/utils/date_util.dart';

import 'blocs/bloc_observer.dart';
import 'models/user.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationPlugin.ensureInitialized();
  Bmob.init("https://api2.bmob.cn", '28009b3f686439f09b5f81da404177fb',
      'e9f5e4b15c5b57631d280d0bcd49330d');
  await SessionUtils.sharedInstance().init();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: BlocProvider<HabitsBloc>(
        create: (context) => HabitsBloc()..add(HabitsLoad()),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            Future.delayed(
                Duration(milliseconds: DateUtil.millisecondsUntilTomorrow()),
                () {
              BlocProvider.of<HabitsBloc>(context).add(HabitsLoad());
            });
            SessionUtils.sharedInstance()
                .setBloc(BlocProvider.of<HabitsBloc>(context));
            return MaterialApp(
              title: 'Time Fly',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.appTheme
                  .themeData()
                  .copyWith(platform: TargetPlatform.iOS),
              home: HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
