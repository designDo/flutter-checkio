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
                MostStreaksView(
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
              aspectRatio: 1.48,
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
                              fontSize: 28)
                          .copyWith(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '总记录(次)',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.48,
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
                              fontSize: 28)
                          .copyWith(fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '总记录(天)',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
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
                  '记录次数最多的习惯们',
                  style: AppTheme.appTheme.textStyle(
                      textColor: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: mostDoNumHabits
                        .map<Widget>((habit) => HabitItemView(
                              habit: habit,
                            ))
                        .toList()),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 4, right: 4),
            child: Text(
              '${mostDoNumHabits.length == 0 ? 0 : mostDoNumHabits[0].records.length}',
              style: AppTheme.appTheme
                  .textStyle(
                      textColor: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28)
                  .copyWith(fontFamily: 'Montserrat'),
            ),
          )
        ],
      ),
    );
  }
}

class MostStreaksView extends StatelessWidget {
  final List<Habit> habits;

  const MostStreaksView({Key key, this.habits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Habit> mostStreakHabits = HabitUtil.getMostHistoryStreakHabits(habits);
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
                  '历史连续天数最多的习惯们',
                  style: AppTheme.appTheme.textStyle(
                      textColor: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: mostStreakHabits
                        .map<Widget>((habit) => HabitItemView(
                              habit: habit,
                            ))
                        .toList()),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 4, right: 4),
            child: Text(
              '${mostStreakHabits.length == 0 ? 0 : mostStreakHabits[0].historyMostStreak}',
              style: AppTheme.appTheme
                  .textStyle(
                      textColor: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28)
                  .copyWith(fontFamily: 'Montserrat'),
            ),
          )
        ],
      ),
    );
  }
}

class HabitItemView extends StatelessWidget {
  final Habit habit;

  const HabitItemView({Key key, this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 6, top: 2, right: 12, bottom: 2),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(habit.mainColor).withOpacity(0.3),
              offset: Offset(3, 3),
              blurRadius: 10)
        ],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color(habit.mainColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            width: 38,
            height: 38,
            child: Image.asset(habit.iconPath),
          ),
          SizedBox(
            width: 4,
          ),
          Text(habit.name,
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
