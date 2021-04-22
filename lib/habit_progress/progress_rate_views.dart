import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/widget/circle_progress_bar.dart';

import '../app_theme.dart';

///四环（今天完成率，昨天平均完成率，前天平均完成率）
class ProgressRateView extends StatelessWidget {
  final List<Habit> allHabits;
  final int period;

  const ProgressRateView({Key key, this.allHabits, this.period})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Pair<int>> rates = _getPeriodRates();
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppTheme.appTheme.cardBackgroundColor(),
          boxShadow: AppTheme.appTheme.containerBoxShadow()),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title(),
            style: AppTheme.appTheme
                .headline1(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 115,
                height: 115,
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
                      width: 85,
                      height: 85,
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
                      width: 55,
                      height: 55,
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
              SizedBox(
                width: 45,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _rateView(0, rates[0]),
                  SizedBox(
                    height: 5,
                  ),
                  _rateView(period == HabitPeriod.day ? 7 : 1, rates[1]),
                  SizedBox(
                    height: 5,
                  ),
                  _rateView(period == HabitPeriod.day ? 15 : 2, rates[2])
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  String _title() {
    if (period == HabitPeriod.day) {
      return '以‘天’为周期习惯';
    } else if (period == HabitPeriod.week) {
      return '以‘周’为周期习惯';
    } else {
      return '以‘月’为周期习惯';
    }
  }

  Widget _rateView(int index, Pair<int> rate) {
    Color _color = _rateColor(index);
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: _color),
          width: 6,
          height: 6,
        ),
        SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_periodString(index)}',
              style: AppTheme.appTheme
                  .numHeadline1(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                    '${rate.x1 == 0 ? '0%' : '${(rate.x0 / rate.x1 * 100).toInt()}%'}',
                    style: AppTheme.appTheme.numHeadline2(
                        fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 5,
                ),
                Text('${rate.x0}/${rate.x1}',
                    style: AppTheme.appTheme.numHeadline2(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _periodString(int index) {
    if (period == HabitPeriod.day) {
      if (index == 0) {
        return '1 D';
      } else if (index == 7) {
        return '7 D';
      } else {
        return '15 D';
      }
    } else if (period == HabitPeriod.week) {
      if (index == 0) {
        return '本周';
      } else if (index == 1) {
        return '1W前';
      } else {
        return '2W前';
      }
    } else {
      if (index == 0) {
        return '本月';
      } else if (index == 1) {
        return '1M前';
      } else {
        return '2M前';
      }
    }
  }

  Color _rateColor(int index) {
    if (index == 0) {
      return Colors.redAccent;
    }
    if (index == 1 || index == 7) {
      return Colors.blueAccent;
    }
    return Colors.purpleAccent;
  }

  List<Pair<int>> _getPeriodRates() {
    if (period == HabitPeriod.day) {
      return _getDayPeriodRates();
    } else if (period == HabitPeriod.week) {
      return _getWeekPeriodRates();
    } else {
      return _getMonthPeriodRates();
    }
  }

  List<Pair<int>> _getDayPeriodRates() {
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
      oneDayNeedDoNum += habit.doNum *
          DateUtil.filterCreateDays(
              habit.completeDays,
              DateTime.fromMillisecondsSinceEpoch(habit.createTime),
              end,
              start);
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
              habit.completeDays,
              DateTime.fromMillisecondsSinceEpoch(habit.createTime),
              end,
              start);
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
              habit.completeDays,
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

  List<Pair<int>> _getWeekPeriodRates() {
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
      oneWeekHasDoneNum +=
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
      oneWeekAgoHasDoneNum +=
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
      twoWeekAgoHasDoneNum +=
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    List<Pair<int>> rates = [];
    rates.add(Pair(oneWeekHasDoneNum, oneWeekNeedDoNum));
    rates.add(Pair(oneWeekAgoHasDoneNum, oneWeekAgoNeedDoNum));
    rates.add(Pair(twoWeekAgoHasDoneNum, twoWeekAgoNeedDoNum));
    return rates;
  }

  List<Pair<int>> _getMonthPeriodRates() {
    final DateTime now = DateTime.now();

    ///1 month
    Pair<DateTime> oneMonth = DateUtil.getMonthStartAndEnd(now, 0);
    DateTime start = oneMonth.x0;
    DateTime end = oneMonth.x1;
    List<Habit> oneMonthHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.month &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();
    int oneMonthNeedDoNum = 0;
    int oneMonthHasDoneNum = 0;
    oneMonthHabits.forEach((habit) {
      oneMonthNeedDoNum += habit.doNum;
      oneMonthHasDoneNum +=
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    ///1 month ago
    Pair<DateTime> oneMonthAgo = DateUtil.getMonthStartAndEnd(now, 1);
    start = oneMonthAgo.x0;
    end = oneMonthAgo.x1;

    List<Habit> oneMonthAgoHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.month &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();

    int oneMonthAgoNeedDoNum = 0;
    int oneMonthAgoHasDoneNum = 0;
    oneMonthAgoHabits.forEach((habit) {
      oneMonthAgoNeedDoNum += habit.doNum;
      oneMonthAgoHasDoneNum +=
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    ///2  month ago
    Pair<DateTime> towMonthAgo = DateUtil.getMonthStartAndEnd(now, 2);
    start = towMonthAgo.x0;
    end = towMonthAgo.x1;

    List<Habit> twoMonthAgoHabits = allHabits
        .where((element) =>
            element.period == HabitPeriod.month &&
            element.createTime < DateUtil.endOfDay(end).millisecondsSinceEpoch)
        .toList();

    int twoMonthAgoNeedDoNum = 0;
    int twoMonthAgoHasDoneNum = 0;
    twoMonthAgoHabits.forEach((habit) {
      twoMonthAgoNeedDoNum += habit.doNum;
      twoMonthAgoHasDoneNum +=
          HabitUtil.getDoCountOfHabit(habit.records, start, end);
    });

    List<Pair<int>> rates = [];
    rates.add(Pair(oneMonthHasDoneNum, oneMonthNeedDoNum));
    rates.add(Pair(oneMonthAgoHasDoneNum, oneMonthAgoNeedDoNum));
    rates.add(Pair(twoMonthAgoHasDoneNum, twoMonthAgoNeedDoNum));
    return rates;
  }
}
