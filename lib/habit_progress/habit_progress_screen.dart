import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/habit_progress/week_month_chart.dart';
import 'package:timefly/models/habit.dart';

class HabitProgressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitProgressScreenState();
  }
}

class _HabitProgressScreenState extends State<HabitProgressScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  List<Habit> _habits;

  Map<String, List<HabitRecord>> recordMap;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print(_tabController.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: FutureBuilder(
          future: DatabaseProvider.db.getHabitsWithRecords(),
          builder: (context, data) {
            if (!data.hasData) {
              return CupertinoActivityIndicator();
            }
            _habits = data.data;
            return ListView(
              physics:
              ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                WeekMonthChart(
                  habits: _habits,
                ),
                Container(
                  height: 800,
                )
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
