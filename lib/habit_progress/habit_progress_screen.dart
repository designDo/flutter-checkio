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
              padding: EdgeInsets.only(
                  top: 0, bottom: MediaQuery.of(context).padding.bottom),
              children: [
                WeekMonthChart(
                  habits: _habits,
                ),
                TotalCheckAndDaysView(
                  habits: _habits,
                ),
                MostChecksView(
                  habits: _habits,
                ),
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

class TotalCheckAndDaysView extends StatelessWidget {
  final List<Habit> habits;

  const TotalCheckAndDaysView({Key key, this.habits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 16),
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

class MostChecksView extends StatelessWidget {
  final List<Habit> habits;

  const MostChecksView({Key key, this.habits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Habit> mostDoNumHabits = HabitUtil.getMostDoNumHabits(habits);
    return Container(
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
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '记录次数最多的习惯',
                  style: AppTheme.appTheme.textStyle(
                      textColor: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: mostDoNumHabits
                        .map<Widget>((habit) => Container(
                              padding: EdgeInsets.only(
                                  left: 16, top: 8, right: 16, bottom: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32)),
                                color: Color(0xFF5C5EDD).withOpacity(0.44),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Color(habit.mainColor)
                                                  .withOpacity(0.3),
                                              offset: Offset(0, 7),
                                              blurRadius: 10)
                                        ],
                                        shape: BoxShape.circle,
                                        color: Color(habit.mainColor)
                                            .withOpacity(0.5)),
                                    width: 32,
                                    height: 32,
                                    child: Image.asset(habit.iconPath),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(habit.name,
                                      style: AppTheme.appTheme.textStyle(
                                          textColor: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ))
                        .toList()),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 8, right: 8),
            child: Text(
              '${mostDoNumHabits.length == 0 ? 0 : mostDoNumHabits[0].records.length}',
              style: AppTheme.appTheme
                  .textStyle(
                      textColor: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)
                  .copyWith(fontFamily: 'Montserrat'),
            ),
          )
        ],
      ),
    );
  }
}
