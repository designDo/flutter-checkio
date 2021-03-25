import 'package:flutter/material.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/widget/circle_progress_bar.dart';

import '../app_theme.dart';

class HabitBaseInfoView extends StatelessWidget {
  final AnimationController animationController;
  final Habit habit;

  const HabitBaseInfoView({Key key, this.habit, this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int recordLength =
        HabitUtil.getHabitRecordsWithPeroid(habit.records, habit.period).length;
    int progress = recordLength;
    if (progress > habit.doNum) {
      progress = recordLength;
    }
    return Row(
      children: [
        Expanded(
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animationController,
                    curve: Interval(0, 0.5, curve: Curves.ease))),
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(
                      habit.period == HabitPeriod.week ? 45 : 35)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(10, 5.0),
                        blurRadius: 16.0)
                  ]),
              margin: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tipView(recordLength),
                  habit.period == HabitPeriod.week ? _weekInfo() : Container()
                ],
              ),
            ),
          ),
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
                  backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
                  foregroundColor: Color(habit.mainColor),
                  value: progress / habit.doNum),
              Text(
                '${((progress / habit.doNum) * 100).toInt()}%',
                style: AppTheme.appTheme
                    .textStyle(
                      textColor: Colors.black,
                      fontSize: 14,
                    )
                    .copyWith(fontFamily: 'Montserrat'),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _weekInfo() {
    return Container(
      margin: EdgeInsets.only(left: 8),
      child: Row(
        children: List.generate(
            7,
            (index) => Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      Text(
                        '${CompleteDay.getSimpleDay(index + 1)}',
                        style: AppTheme.appTheme.textStyle(
                            textColor: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.w300),
                      ),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: habit.completeDays.contains(index + 1)
                                ? Color(habit.mainColor)
                                : Colors.transparent,
                            shape: BoxShape.circle),
                      )
                    ],
                  ),
                )),
      ),
    );
  }

  Widget _tipView(int recordLength) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Today Needs',
          style: AppTheme.appTheme.textStyle(
            textColor: Colors.black,
            fontSize: 14,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Text('${habit.doNum}',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat')),
        SizedBox(
          width: 3,
        ),
        Text('Has Done',
            style: AppTheme.appTheme.textStyle(
              textColor: Colors.black,
              fontSize: 14,
            )),
        SizedBox(
          width: 3,
        ),
        Text('$recordLength',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat')),
      ],
    );
  }
}

class HabitMonthInfoView extends StatelessWidget {
  final AnimationController animationController;
  final Habit habit;

  const HabitMonthInfoView({Key key, this.animationController, this.habit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
              parent: animationController,
              curve: Interval(0.5, 1, curve: Curves.ease))),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval(0.5, 1, curve: Curves.ease))),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          color: Colors.blueAccent,
          height: 200,
        ),
      ),
    );
  }
}
