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
    int needCompleteNnm = _needCompleteNum();
    int hasDoNum = _hasDoNum();
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
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(10, 5.0),
                        blurRadius: 16.0)
                  ]),
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
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(10, 5.0),
                        blurRadius: 16.0),
                  ]),
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleProgressBar(
                      backgroundColor:
                          AppTheme.appTheme.containerBackgroundColor(),
                      foregroundColor: Color(0xFF5C5EDD),
                      value: hasDoNum / needCompleteNnm),
                  Text(
                    '${((hasDoNum / needCompleteNnm) * 100).toInt()}%',
                    style: AppTheme.appTheme
                        .textStyle(
                          textColor: Colors.black,
                          fontSize: 14,
                        )
                        .copyWith(fontFamily: 'Montserrat'),
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
    String tip = '所有‘天’周期习惯，今天，';
    if (period == HabitPeriod.week) {
      tip = '所有‘周’周期习惯，本周，';
    } else if (period == HabitPeriod.month) {
      tip = '所有‘月’周期习惯，本月';
    }
    return Column(
      children: [
        Text(
          tip,
          style: AppTheme.appTheme.textStyle(
            textColor: Colors.grey,
            fontSize: 15,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '需完成',
              style: AppTheme.appTheme.textStyle(
                textColor: Colors.black,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: 3,
            ),
            Text('$needCompleteNum',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat')),
            SizedBox(
              width: 3,
            ),
            Text('已完成',
                style: AppTheme.appTheme.textStyle(
                  textColor: Colors.black,
                  fontSize: 14,
                )),
            SizedBox(
              width: 3,
            ),
            Text('$hasDoNum',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat')),
          ],
        )
      ],
    );
  }

  int _needCompleteNum() {
    int count = 0;
    allHabits.where((element) => element.period == period).forEach((element) {
      count += element.doNum;
    });
    return count;
  }

  int _hasDoNum() {
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
    allHabits.where((element) => element.period == period).forEach((element) {
      count += HabitUtil.getDoCountOfHabit(element.records, start, end);
    });
    return count;
  }
}
