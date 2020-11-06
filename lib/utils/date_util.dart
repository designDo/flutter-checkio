import 'package:flutter/cupertino.dart';
import 'package:time/time.dart';

class DateUtil {
  static bool isToday(int millisecondsSinceEpoch) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    DateTime now = DateTime.now();
    return DateTime(dateTime.year, dateTime.month, dateTime.day) ==
        DateTime(now.year, now.month, now.day);
  }

  static String getDayString(int millisecondsSinceEpoch) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  static int millisecondsUntilTomorrow() {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    return tomorrow.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
  }

  static int getWeekCheckNum(
      List<int> todayCheck, Map<String, List<int>> totalCheck) {
    int num = 0;
    if (totalCheck != null) {
      DateTime now = DateTime.now();
      //周三 2020-10-10
      int today = now.weekday;
      for (int i = 1; i < today - 1; i++) {
        DateTime oldDay = now - i.days;
        List<int> checks =
            totalCheck['${oldDay.year}-${oldDay.month}-${oldDay.day}'];
        if (checks != null) {
          num += checks.length;
        }
      }
    }

    if (todayCheck != null) {
      num += todayCheck.length;
    }
    return num;
  }

  static int getMonthCheckNum(
      List<int> todayCheck, Map<String, List<int>> totalCheck) {
    int num = 0;
    if (totalCheck != null) {
      DateTime now = DateTime.now();
      //2020-10-10 get 10-1 --> 10-10
      int today = now.day;
      for (int i = 1; i < today; i++) {
        DateTime oldDay = DateTime(now.year, now.month, i);
        List<int> checks =
            totalCheck['${oldDay.year}-${oldDay.month}-${oldDay.day}'];
        if (checks != null) {
          num += checks.length;
        }
      }
    }
    if (todayCheck != null) {
      num += todayCheck.length;
    }
    return num;
  }

  /// thisMonth 2020 10 1
  static List<DateTime> getMonthDays(DateTime thisMonth) {
    List<DateTime> days = [];

    ///前7个为 一 ---> 日
    for (int i = 0; i < 7; i++) {
      days.add(null);
    }

    ///当月第一天为周几 eg 7
    int firstDayWeekDay = thisMonth.weekday;

    ///若当月第一天不是周一，则需向前补天数到周一
    if (firstDayWeekDay > DateTime.monday) {
      for (int i = firstDayWeekDay; i > DateTime.monday; i--) {
        days.add(null);
      }
    }
    int count = DateTime(thisMonth.year, thisMonth.month + 1, 0).day;
    for (int day = 1; day <= count; day++) {
      days.add(DateTime(thisMonth.year, thisMonth.month, day));
    }

    ///当月最后一天为周几 eg 7
    int lastDayWeekDay = days.last.weekday;

    ///若当月最后一天不是周日，则需向后补天数到周日
    if (lastDayWeekDay < DateTime.sunday) {
      for (int i = lastDayWeekDay + 1; i <= DateTime.sunday; i++) {
        days.add(null);
      }
    }
    return days;
  }

  static int getThisMonthDaysNum() {
    return getMonthDays(DateTime.now().copyWith(day: 1)).length;
  }

  static String getWeekendString(int weekday) {
    String str = '';
    switch (weekday) {
      case 1:
        str = '一';
        break;
      case 2:
        str = '二';
        break;
      case 3:
        str = '三';
        break;
      case 4:
        str = '四';
        break;
      case 5:
        str = '五';
        break;
      case 6:
        str = '六';
        break;
      case 7:
        str = '日';
        break;
    }
    return str;
  }
}
