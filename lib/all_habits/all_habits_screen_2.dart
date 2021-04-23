import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timefly/add_habit/habit_edit_page.dart';
import 'package:timefly/all_habits/all_habit_list_view.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/system_util.dart';
import 'package:timefly/widget/clip/bottom_cliper.dart';
import 'package:timefly/widget/tab_indicator.dart';

class AllHabitScreen extends StatefulWidget {
  @override
  _AllHabitScreenState createState() => _AllHabitScreenState();
}

class _AllHabitScreenState extends State<AllHabitScreen> {
  @override
  Widget build(BuildContext context) {
    SystemUtil.changeStateBarMode(
        AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark);
    return Stack(
      children: [
        ClipPath(
          clipper: BottomClipper(),
          child: Container(
            decoration: BoxDecoration(
                gradient: AppTheme.appTheme.containerGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
            height: 240,
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top + 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 8, bottom: 16),
                child: Row(
                  children: [
                    Text(
                      '所有习惯',
                      style: AppTheme.appTheme.headline1(
                          textColor: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(CupertinoPageRoute(builder: (context) {
                          return HabitEditPage(
                            isModify: false,
                            habit: null,
                          );
                        }));
                      },
                      child: SvgPicture.asset(
                        'assets/images/jia.svg',
                        color: Colors.white,
                        width: 30,
                        height: 30,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    )
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<HabitsBloc, HabitsState>(
                  builder: (context, state) {
                    if (state is HabitsLoadInProgress) {
                      return Container(
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    }
                    if (state is HabitsLodeFailure) {
                      return Container(
                        child: Center(
                          child: Text('加载出错啦...'),
                        ),
                      );
                    }
                    List<Habit> habits = (state as HabitLoadSuccess).habits;

                    List<CompleteTime> tabs = filterCompleteTime(habits);
                    return DefaultTabController(
                      length: tabs.length,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 16, right: 16),
                            child: TabBar(
                              tabs: tabs
                                  .map((time) => Container(
                                        alignment: Alignment.center,
                                        width: 60,
                                        height: 38,
                                        child: Text(
                                            '${CompleteTime.getTime(time.time)}'),
                                      ))
                                  .toList(),
                              labelColor: Colors.white,
                              labelStyle: AppTheme.appTheme.headline1(
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              unselectedLabelColor: Colors.white70,
                              unselectedLabelStyle: AppTheme.appTheme.headline1(
                                  textColor: Colors.white70,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                              indicator: BorderTabIndicator(
                                  indicatorHeight: 36, textScaleFactor: 0.8),
                              isScrollable: true,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: tabs
                                  .map((time) => AllHabitListView(
                                        habits: filterHabits(habits, time.time),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  List<CompleteTime> filterCompleteTime(List<Habit> habits) {
    List<CompleteTime> times = [];
    times.add(CompleteTime(-1));
    habits.forEach((habit) {
      CompleteTime completeTime = CompleteTime(habit.completeTime);
      times.firstWhere((time) => time.time == habit.completeTime, orElse: () {
        times.add(completeTime);
        return null;
      });
    });
    times.sort((a, b) => a.time - b.time);
    return times;
  }

  List<Habit> filterHabits(List<Habit> habits, int complete) {
    if (complete == -1) {
      return List.from(habits);
    }
    return List<Habit>.from(habits)
        .where((habit) => habit.completeTime == complete)
        .toList();
  }
}
