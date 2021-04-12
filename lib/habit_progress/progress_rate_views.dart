import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/widget/circle_progress_bar.dart';

import '../app_theme.dart';

///四环（今天完成率，昨天平均完成率，前天平均完成率）
class ProgressDayRateView extends StatelessWidget {
  final List<Habit> allHabits;

  const ProgressDayRateView({Key key, this.allHabits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Pair<int>> rates = _getPeriodRates();
    return Container(
      alignment: Alignment.centerLeft,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '以‘天’为周期习惯',
            style: AppTheme.appTheme.textStyle(
                textColor: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rateView(1, rates[0]),
                  _rateView(7, rates[1]),
                  _rateView(15, rates[2])
                ],
              ),
              Expanded(child: SizedBox()),
              Container(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleProgressBar(
                        backgroundColor: AppTheme.appTheme
                            .containerBackgroundColor()
                            .withOpacity(0.6),
                        foregroundColor: Colors.redAccent,
                        strokeWidth: 8,
                        value:
                            rates[0].x0 / (rates[0].x1 == 0 ? 1 : rates[0].x1)),
                    Container(
                      width: 80,
                      height: 80,
                      child: CircleProgressBar(
                          backgroundColor: AppTheme.appTheme
                              .containerBackgroundColor()
                              .withOpacity(0.6),
                          strokeWidth: 8,
                          foregroundColor: Colors.blueAccent,
                          value: rates[1].x0 /
                              (rates[1].x1 == 0 ? 1 : rates[1].x1)),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: CircleProgressBar(
                          backgroundColor: AppTheme.appTheme
                              .containerBackgroundColor()
                              .withOpacity(0.6),
                          strokeWidth: 8,
                          foregroundColor: Colors.purpleAccent,
                          value: rates[2].x0 /
                              (rates[2].x1 == 0 ? 1 : rates[2].x1)),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _rateView(int period, Pair<int> rate) {
    Color _color = Colors.redAccent;
    if (period == 7) {
      _color = Colors.blueAccent;
    }
    if (period == 15) {
      _color = Colors.purpleAccent;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
          width: 5,
          height: 5,
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          '$period D',
          style: AppTheme.appTheme
              .textStyle(
                  textColor: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal)
              .copyWith(fontFamily: 'Montserrat'),
        ),
        SizedBox(
          width: 16,
        ),
        Text('${rate.x0}/${rate.x1}',
            style: AppTheme.appTheme
                .textStyle(
                    textColor: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)
                .copyWith(fontFamily: 'Montserrat'))
      ],
    );
  }

  List<Pair<int>> _getPeriodRates() {
    List<Habit> habits = allHabits
        .where((element) => element.period == HabitPeriod.day)
        .toList();
    final DateTime now = DateTime.now();
    DateTime start;
    DateTime end;

    ///1 day
    start = now;
    end = now;
    int oneDayNeedDoNum = 0;
    int oneDayHasDoneNum = 0;
    habits.forEach((habit) {
      oneDayNeedDoNum += habit.doNum;
      oneDayHasDoneNum +=
          HabitUtil.getDoCountOfHabit(habit.records, end, start);
    });

    ///7 day
    end = DateUtil.getDayPeroid(now, 6);
    int sevenDaysNeedDoNum = 0;
    int sevenDaysHasDoneNum = 0;

    habits.forEach((habit) {
      sevenDaysNeedDoNum += habit.doNum *
          DateUtil.filterCreateDays(
              DateTime.fromMillisecondsSinceEpoch(habit.createTime),
              end,
              start);
      print(habit.records.length);
      sevenDaysHasDoneNum +=
          HabitUtil.getDoCountOfHabit(habit.records, end, start);
    });

    ///15 day
    end = DateUtil.getDayPeroid(now, 14);
    int fivesDaysNeedDoNum = 0;
    int fivesDaysHasDoneNum = 0;

    habits.forEach((habit) {
      fivesDaysNeedDoNum += habit.doNum *
          DateUtil.filterCreateDays(
              DateTime.fromMillisecondsSinceEpoch(habit.createTime),
              end,
              start);
      fivesDaysHasDoneNum +=
          HabitUtil.getDoCountOfHabit(habit.records, end, start);
    });

    List<Pair<int>> rates = [];
    rates.add(Pair(oneDayHasDoneNum, oneDayNeedDoNum));
    rates.add(Pair(sevenDaysHasDoneNum, sevenDaysNeedDoNum));
    rates.add(Pair(fivesDaysHasDoneNum, fivesDaysNeedDoNum));
    return rates;
  }
}

class ProgressWeekRateView extends StatelessWidget {
  final List<Habit> allHabits;

  const ProgressWeekRateView({Key key, this.allHabits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Pair<int>> rates = _getPeriodRates();
    return Container(
      alignment: Alignment.centerLeft,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '以‘周’为周期习惯',
            style: AppTheme.appTheme.textStyle(
                textColor: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rateView(0, rates[0]),
                  _rateView(1, rates[1]),
                  _rateView(2, rates[2])
                ],
              ),
              Expanded(child: SizedBox()),
              Container(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleProgressBar(
                        backgroundColor: AppTheme.appTheme
                            .containerBackgroundColor()
                            .withOpacity(0.6),
                        foregroundColor: Colors.redAccent,
                        strokeWidth: 8,
                        value:
                            rates[0].x0 / (rates[0].x1 == 0 ? 1 : rates[0].x1)),
                    Container(
                      width: 80,
                      height: 80,
                      child: CircleProgressBar(
                          backgroundColor: AppTheme.appTheme
                              .containerBackgroundColor()
                              .withOpacity(0.6),
                          strokeWidth: 8,
                          foregroundColor: Colors.blueAccent,
                          value: rates[1].x0 /
                              (rates[1].x1 == 0 ? 1 : rates[1].x1)),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: CircleProgressBar(
                          backgroundColor: AppTheme.appTheme
                              .containerBackgroundColor()
                              .withOpacity(0.6),
                          strokeWidth: 8,
                          foregroundColor: Colors.purpleAccent,
                          value: rates[2].x0 /
                              (rates[2].x1 == 0 ? 1 : rates[2].x1)),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _rateView(int period, Pair<int> rate) {
    Color _color = Colors.redAccent;
    if (period == 1) {
      _color = Colors.blueAccent;
    }
    if (period == 2) {
      _color = Colors.purpleAccent;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
          width: 5,
          height: 5,
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          '${period == 0 ? '本周' : '$period W 前'}',
          style: AppTheme.appTheme
              .textStyle(
                  textColor: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal)
              .copyWith(fontFamily: 'Montserrat'),
        ),
        SizedBox(
          width: 16,
        ),
        Text('${rate.x0}/${rate.x1}',
            style: AppTheme.appTheme
                .textStyle(
                    textColor: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)
                .copyWith(fontFamily: 'Montserrat'))
      ],
    );
  }

  List<Pair<int>> _getPeriodRates() {
    final DateTime now = DateTime.now();

    ///1 week
    Pair<DateTime> oneWeek = DateUtil.getWeekStartAndEnd(now, 0);
    DateTime start = oneWeek.x0;
    DateTime end = oneWeek.x1;
    List<Habit> oneWeekHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.week &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();
    int oneWeekNeedDoNum = 0;
    int oneWeekHasDoneNum = 0;
    oneWeekHabits.forEach((habit) {
      oneWeekNeedDoNum += habit.doNum;
      oneWeekHasDoneNum =
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    ///1 week ago
    Pair<DateTime> oneWeekAgo = DateUtil.getWeekStartAndEnd(now, 1);
    start = oneWeekAgo.x0;
    end = oneWeekAgo.x1;

    List<Habit> oneWeekAgoHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.week &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();

    int oneWeekAgoNeedDoNum = 0;
    int oneWeekAgoHasDoneNum = 0;
    oneWeekAgoHabits.forEach((habit) {
      oneWeekAgoNeedDoNum += habit.doNum;
      oneWeekAgoHasDoneNum =
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    ///2  week ago
    Pair<DateTime> towWeekAgo = DateUtil.getWeekStartAndEnd(now, 2);
    start = towWeekAgo.x0;
    end = towWeekAgo.x1;

    List<Habit> twoWeekAgoHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.week &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();

    int twoWeekAgoNeedDoNum = 0;
    int twoWeekAgoHasDoneNum = 0;
    twoWeekAgoHabits.forEach((habit) {
      twoWeekAgoNeedDoNum += habit.doNum;
      twoWeekAgoHasDoneNum =
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    List<Pair<int>> rates = [];
    rates.add(Pair(oneWeekHasDoneNum, oneWeekNeedDoNum));
    rates.add(Pair(oneWeekAgoHasDoneNum, oneWeekAgoNeedDoNum));
    rates.add(Pair(twoWeekAgoHasDoneNum, twoWeekAgoNeedDoNum));
    return rates;
  }
}

class ProgressMonthRateView extends StatelessWidget {
  final List<Habit> allHabits;

  const ProgressMonthRateView({Key key, this.allHabits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Pair<int>> rates = _getPeriodRates();
    return Container(
      alignment: Alignment.centerLeft,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '以‘月’为周期习惯',
            style: AppTheme.appTheme.textStyle(
                textColor: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rateView(0, rates[0]),
                  _rateView(1, rates[1]),
                  _rateView(2, rates[2])
                ],
              ),
              Expanded(child: SizedBox()),
              Container(
                width: 110,
                height: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleProgressBar(
                        backgroundColor: AppTheme.appTheme
                            .containerBackgroundColor()
                            .withOpacity(0.6),
                        foregroundColor: Colors.redAccent,
                        strokeWidth: 8,
                        value:
                            rates[0].x0 / (rates[0].x1 == 0 ? 1 : rates[0].x1)),
                    Container(
                      width: 80,
                      height: 80,
                      child: CircleProgressBar(
                          backgroundColor: AppTheme.appTheme
                              .containerBackgroundColor()
                              .withOpacity(0.6),
                          strokeWidth: 8,
                          foregroundColor: Colors.blueAccent,
                          value: rates[1].x0 /
                              (rates[1].x1 == 0 ? 1 : rates[1].x1)),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: CircleProgressBar(
                          backgroundColor: AppTheme.appTheme
                              .containerBackgroundColor()
                              .withOpacity(0.6),
                          strokeWidth: 8,
                          foregroundColor: Colors.purpleAccent,
                          value: rates[2].x0 /
                              (rates[2].x1 == 0 ? 1 : rates[2].x1)),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _rateView(int period, Pair<int> rate) {
    Color _color = Colors.redAccent;
    if (period == 1) {
      _color = Colors.blueAccent;
    }
    if (period == 2) {
      _color = Colors.purpleAccent;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
          width: 5,
          height: 5,
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          '${period == 0 ? '本月' : '$period M 前'}',
          style: AppTheme.appTheme
              .textStyle(
                  textColor: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal)
              .copyWith(fontFamily: 'Montserrat'),
        ),
        SizedBox(
          width: 16,
        ),
        Text('${rate.x0}/${rate.x1}',
            style: AppTheme.appTheme
                .textStyle(
                    textColor: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)
                .copyWith(fontFamily: 'Montserrat'))
      ],
    );
  }

  List<Pair<int>> _getPeriodRates() {
    final DateTime now = DateTime.now();

    ///1 month
    Pair<DateTime> oneWeek = DateUtil.getMonthStartAndEnd(now, 0);
    DateTime start = oneWeek.x0;
    DateTime end = oneWeek.x1;
    List<Habit> oneWeekHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.month &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();
    int oneWeekNeedDoNum = 0;
    int oneWeekHasDoneNum = 0;
    oneWeekHabits.forEach((habit) {
      oneWeekNeedDoNum += habit.doNum;
      oneWeekHasDoneNum =
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    ///1 month ago
    Pair<DateTime> oneWeekAgo = DateUtil.getMonthStartAndEnd(now, 1);
    start = oneWeekAgo.x0;
    end = oneWeekAgo.x1;

    List<Habit> oneWeekAgoHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.month &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();

    int oneWeekAgoNeedDoNum = 0;
    int oneWeekAgoHasDoneNum = 0;
    oneWeekAgoHabits.forEach((habit) {
      oneWeekAgoNeedDoNum += habit.doNum;
      oneWeekAgoHasDoneNum =
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    ///2  month ago
    Pair<DateTime> towWeekAgo = DateUtil.getMonthStartAndEnd(now, 2);
    start = towWeekAgo.x0;
    end = towWeekAgo.x1;

    List<Habit> twoWeekAgoHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.month &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();

    int twoWeekAgoNeedDoNum = 0;
    int twoWeekAgoHasDoneNum = 0;
    twoWeekAgoHabits.forEach((habit) {
      twoWeekAgoNeedDoNum += habit.doNum;
      twoWeekAgoHasDoneNum =
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    List<Pair<int>> rates = [];
    rates.add(Pair(oneWeekHasDoneNum, oneWeekNeedDoNum));
    rates.add(Pair(oneWeekAgoHasDoneNum, oneWeekAgoNeedDoNum));
    rates.add(Pair(twoWeekAgoHasDoneNum, twoWeekAgoNeedDoNum));
    return rates;
  }
}
