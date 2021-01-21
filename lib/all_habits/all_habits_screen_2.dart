import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timefly/all_habits/all_habit_list_view.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/db/database_provider.dart';
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
  List<CompleteTime> tabs;

  List<Habit> _habits;

  @override
  Widget build(BuildContext context) {
    SystemUtil.changeStateBarMode(Brightness.light);
    return Stack(
      children: [
        ClipPath(
          clipper: BottomClipper(),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: <Color>[
                Color(0xFF738AE6),
                Color(0xFF5C5EDD),
              ],
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
                child: Text(
                  '所有习惯',
                  style: AppTheme.appTheme.textStyle(
                      textColor: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Habit>>(
                  future: DatabaseProvider.db.getHabitsWithRecords(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    }
                    _habits = snapshot.data;
                    tabs = filterCompleteTime();
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
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              unselectedLabelColor: Colors.white70,
                              unselectedLabelStyle: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
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
                                        habits: filterHabits(time.time),
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

  List<CompleteTime> filterCompleteTime() {
    List<CompleteTime> times = [];
    times.add(CompleteTime(-1));
    _habits.forEach((habit) {
      CompleteTime completeTime = CompleteTime(habit.completeTime);
      times.firstWhere((time) => time.time == habit.completeTime, orElse: () {
        times.add(completeTime);
        return null;
      });
    });
    times.sort((a, b) => a.time - b.time);
    return times;
  }

  List<Habit> filterHabits(int complete) {
    if (complete == -1) {
      return List.from(_habits);
    }
    return List<Habit>.from(_habits)
        .where((habit) => habit.completeTime == complete)
        .toList();
  }
}