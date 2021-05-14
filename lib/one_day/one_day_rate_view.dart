import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/widget/circle_progress_bar.dart';

import '../app_theme.dart';

///周期为天的习惯完成率
class OneDayRateView extends StatelessWidget {
  final int period;
  final List<Habit> allHabits;
  final Animation<Offset> animation;

  const OneDayRateView({Key key, this.period, this.allHabits, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Habit> habits = allHabits;
    if (period == HabitPeriod.day) {
      int weekend = DateTime.now().weekday;
      habits = habits
          .where((element) => element.completeDays.contains(weekend))
          .toList();
    }
    int needCompleteNnm = _needCompleteNum(habits);
    int hasDoNum = _hasDoNum(habits);
    return SlideTransition(
      position: animation,
      child: Padding(
        padding: EdgeInsets.only(left: 40, bottom: 8, top: 8),
        child: Row(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                      bottomLeft: Radius.circular(15)),
                  gradient: AppTheme.appTheme.containerGradient(),
                  boxShadow: AppTheme.appTheme.coloredBoxShadow()),
              child: _tipView(hasDoNum, needCompleteNnm),
            )),
            SizedBox(
              width: 10,
            ),
            Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.appTheme.cardBackgroundColor(),
                  boxShadow: AppTheme.appTheme.containerBoxShadow()),
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleProgressBar(
                      backgroundColor:
                          AppTheme.appTheme.containerBackgroundColor(),
                      foregroundColor: AppTheme.appTheme.grandientColorEnd(),
                      value: hasDoNum / needCompleteNnm),
                  Text(
                    '${((hasDoNum / needCompleteNnm) * 100).toInt()}%',
                    style: AppTheme.appTheme.numHeadline1(
                        fontSize: 14, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _tipView(int hasDoNum, int needCompleteNum) {
    String tip = '以‘天’为周期习惯，今天，';
    if (period == HabitPeriod.week) {
      tip = '以‘周’为周期习惯，本周，';
    } else if (period == HabitPeriod.month) {
      tip = '以‘月’为周期习惯，本月';
    }
    return Column(
      children: [
        Text(
          tip,
          style: AppTheme.appTheme.headline1(
            textColor: Colors.white70,
            fontSize: 15,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '共需完成',
              style: AppTheme.appTheme.headline1(
                  textColor: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              width: 3,
            ),
            Text('$needCompleteNum',
                style: AppTheme.appTheme.numHeadline1(
                  fontSize: 22,
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              width: 3,
            ),
            Text('已完成',
                style: AppTheme.appTheme.headline1(
                    textColor: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
            SizedBox(
              width: 3,
            ),
            Text('$hasDoNum',
                style: AppTheme.appTheme.numHeadline1(
                  fontSize: 22,
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ],
        )
      ],
    );
  }

  int _needCompleteNum(List<Habit> habits) {
    int count = 0;
    habits.where((element) => element.period == period).forEach((element) {
      count += element.doNum;
    });
    return count;
  }

  int _hasDoNum(List<Habit> habits) {
    int count = 0;
    final DateTime _now = DateTime.now();
    DateTime start;
    DateTime end;
    if (period == HabitPeriod.day) {
      start = DateUtil.getDayPeroid(_now, 0);
      end = DateUtil.getDayPeroid(_now, 0);
    } else if (period == HabitPeriod.week) {
      Pair<DateTime> weekSAE = DateUtil.getWeekStartAndEnd(_now, 0);
      start = weekSAE.x0;
      end = weekSAE.x1;
    } else {
      Pair<DateTime> monthSAE = DateUtil.getMonthStartAndEnd(_now, 0);
      start = monthSAE.x0;
      end = monthSAE.x1;
    }
    habits.where((element) => element.period == period).forEach((element) {
      count += HabitUtil.getDoCountOfHabit(element.records, start, end);
    });
    return count;
  }
}
