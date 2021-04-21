import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';

class CalendarView extends StatefulWidget {
  final DateTime currentDay;

  final Habit habit;

  final double Function() caculatorHeight;

  final Map<String, List<HabitRecord>> records;

  const CalendarView(
      {Key key,
      this.currentDay,
      this.caculatorHeight,
      this.habit,
      this.records})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<DateTime> days;

  @override
  void initState() {
    days = DateUtil.getMonthDays(
        DateTime(widget.currentDay.year, widget.currentDay.month, 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.caculatorHeight(),
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: .3, right: .3),
          itemCount: days.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, childAspectRatio: 1.8, mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            DateTime day = days[index];
            if (day == null) {
              if (index < 7) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${DateUtil.getWeekendString(index + 1)}',
                    style: AppTheme.appTheme
                        .headline1(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                );
              }
              return Container();
            }
            return Container(
              decoration: getBox(days[index], index),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: AppTheme.appTheme.numHeadline1(
                    textColor: containsDay(days[index])
                        ? Colors.white
                        : AppTheme.appTheme.normalColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            );
          }),
    );
  }

  BoxDecoration getBox(DateTime day, int index) {
    DateTime lastDay = days[index - 1];
    DateTime nextDay = days.length - 1 > index ? days[index + 1] : null;

    if (containsDay(day)) {
      bool containLastDay = containsDay(lastDay);
      bool containNextDay = containsDay(nextDay);

      ///昨天和明天都有记录
      if (containLastDay && containNextDay) {
        return colorBox();

        ///昨天有记录，明天没有记录
      } else if (containLastDay && !containNextDay) {
        return rightBox();

        ///昨天没有记录，明天有记录
      } else if (!containLastDay && containNextDay) {
        return leftBox();

        ///昨天和明天都没有记录
      } else {
        return allBox();
      }
    } else {
      return norBox();
    }
  }

  BoxDecoration norBox() {
    return BoxDecoration();
  }

  BoxDecoration colorBox() {
    return BoxDecoration(color: Color(widget.habit.mainColor));
  }

  BoxDecoration leftBox() {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
        color: Color(widget.habit.mainColor));
  }

  BoxDecoration rightBox() {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
        color: Color(widget.habit.mainColor));
  }

  BoxDecoration allBox() {
    return BoxDecoration(
        shape: BoxShape.circle, color: Color(widget.habit.mainColor));
  }

  bool containsDay(DateTime date) {
    if (date == null) {
      return false;
    }
    bool contain = false;
    if (widget.records == null || widget.records.length == 0) {
      contain = false;
    } else if (widget.records
        .containsKey('${date.year}-${date.month}-${date.day}')) {
      contain = true;
    }
    return contain;
  }

  bool isSunday(DateTime date) {
    return date.weekday == DateTime.sunday;
  }

  bool isMonday(DateTime date) {
    return date.weekday == DateTime.monday;
  }
}
