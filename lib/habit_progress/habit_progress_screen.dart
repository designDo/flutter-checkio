import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/habit_progress/week_month_chart.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/habit_util.dart';

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
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                WeekMonthChart(
                  habits: _habits,
                ),
                MostCheckAndStreaksView(
                  habits: _habits,
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

class MostCheckAndStreaksView extends StatelessWidget {
  final List<Habit> habits;

  const MostCheckAndStreaksView({Key key, this.habits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.34,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 16,
                          offset: Offset(4, 4))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${HabitUtil.getTotalDoNumsOfHistory(habits)}',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)
                          .copyWith(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '总记录(次)',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)
                          .copyWith(fontFamily: 'Montserrat'),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 32,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.34,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 16,
                          offset: Offset(4, 4))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${HabitUtil.getTotalDaysOfHistory(habits)}',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30)
                          .copyWith(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '总记录(天)',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)
                          .copyWith(fontFamily: 'Montserrat'),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
