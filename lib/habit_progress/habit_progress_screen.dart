import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/habit_progress/progress_rate_views.dart';
import 'package:timefly/habit_progress/week_month_chart.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/utils/system_util.dart';

class HabitProgressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitProgressScreenState();
  }
}

class _HabitProgressScreenState extends State<HabitProgressScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

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
    SystemUtil.changeStateBarMode(
        AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark);
    return Container(
      color: AppTheme.appTheme.containerBackgroundColor(),
      child: BlocBuilder<HabitsBloc, HabitsState>(builder: (context, state) {
        if (state is HabitsLoadInProgress) {
          return CupertinoActivityIndicator();
        }
        if (state is HabitsLodeFailure) {
          return Container();
        }
        List<Habit> _habits = (state as HabitLoadSuccess).habits;
        int dayPeriodHabitCount = _habits
            .where((element) => element.period == HabitPeriod.day)
            .length;
        int weekPeriodHabitCount = _habits
            .where((element) => element.period == HabitPeriod.week)
            .length;
        int monthPeriodHabitCount = _habits
            .where((element) => element.period == HabitPeriod.month)
            .length;

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
            dayPeriodHabitCount > 0
                ? ProgressRateView(
                    allHabits: _habits,
                    period: HabitPeriod.day,
                  )
                : SizedBox(),
            weekPeriodHabitCount > 0
                ? ProgressRateView(
                    allHabits: _habits,
                    period: HabitPeriod.week,
                  )
                : SizedBox(),
            monthPeriodHabitCount > 0
                ? ProgressRateView(
                    allHabits: _habits,
                    period: HabitPeriod.month,
                  )
                : SizedBox(),
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
                    color: AppTheme.appTheme.cardBackgroundColor(),
                    boxShadow: AppTheme.appTheme.containerBoxShadow()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${HabitUtil.getTotalDoNumsOfHistory(habits)}',
                      style: AppTheme.appTheme.numHeadline1(
                          fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '总记录(次)',
                      style: AppTheme.appTheme
                          .headline1(fontWeight: FontWeight.bold, fontSize: 16),
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
                    color: AppTheme.appTheme.cardBackgroundColor(),
                    boxShadow: AppTheme.appTheme.containerBoxShadow()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${HabitUtil.getTotalDaysOfHistory(habits)}',
                      style: AppTheme.appTheme.numHeadline1(
                          fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '总记录(天)',
                      style: AppTheme.appTheme
                          .headline1(fontWeight: FontWeight.bold, fontSize: 16),
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
    if (mostDoNumHabits.length == 0) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppTheme.appTheme.cardBackgroundColor(),
          boxShadow: AppTheme.appTheme.containerBoxShadow()),
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
                  '记录次数最多',
                  style: AppTheme.appTheme
                      .headline1(fontSize: 16, fontWeight: FontWeight.bold),
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
                  .numHeadline1(fontWeight: FontWeight.bold, fontSize: 28),
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
    Pair2<int, List<Habit>> mostStreakHabits =
        HabitUtil.getMostHistoryStreakHabits(habits);
    if (mostStreakHabits.s == 0) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppTheme.appTheme.cardBackgroundColor(),
          boxShadow: AppTheme.appTheme.containerBoxShadow()),
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
                  '当前连续天数最多',
                  style: AppTheme.appTheme
                      .headline1(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: mostStreakHabits.t
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
              '${mostStreakHabits.s}',
              style: AppTheme.appTheme
                  .numHeadline1(fontWeight: FontWeight.bold, fontSize: 28),
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
      padding: EdgeInsets.only(left: 12, top: 2, right: 12, bottom: 2),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(habit.mainColor).withOpacity(0.3),
              offset: Offset(3, 3),
              blurRadius: 10)
        ],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8)),
        color: Color(habit.mainColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            width: 32,
            height: 32,
            child: Image.asset(habit.iconPath),
          ),
          SizedBox(
            width: 4,
          ),
          Text(habit.name,
              style: AppTheme.appTheme.headline1(
                  textColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal))
        ],
      ),
    );
  }
}
