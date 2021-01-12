import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';

class CalendarView extends StatefulWidget {
  final DateTime currentDay;

  final Habit habit;

  final double Function() caculatorHeight;

  const CalendarView(
      {Key key, this.currentDay, this.caculatorHeight, this.habit})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<DateTime> days;

  Map<String, List<HabitRecord>> records;

  @override
  void initState() {
    days = DateUtil.getMonthDays(
        DateTime(widget.currentDay.year, widget.currentDay.month, 1));
    records = HabitUtil.combinationRecords(widget.habit.records);
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
                        .textStyle(fontWeight: FontWeight.w500, fontSize: 15),
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
                style: AppTheme.appTheme
                    .textStyle(
                        textColor: containsDay(days[index])
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)
                    .copyWith(fontFamily: 'Montserrat'),
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
    if (records == null || records.length == 0) {
      contain = false;
    } else if (records.containsKey('${date.year}-${date.month}-${date.day}')) {
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
