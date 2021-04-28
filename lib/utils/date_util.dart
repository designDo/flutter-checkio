import 'package:time/time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/pair.dart';

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

  static String formDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  static int millisecondsUntilTomorrow() {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    return tomorrow.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
  }

  ///获取'周'周期内签到次数，包含今天和过去几天的
  static int getWeekCheckNum(
      List<HabitRecord> todayCheck, Map<String, List<HabitRecord>> totalCheck) {
    int num = 0;
    if (totalCheck != null) {
      DateTime now = DateTime.now();
      //周三 2020-10-10
      int today = now.weekday;
      for (int i = 1; i < today - 1; i++) {
        DateTime oldDay = now - i.days;
        List<HabitRecord> checks =
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

  static DateTime firstDayOfWeekend(DateTime now) {
    int today = now.weekday;
    return startOfDay(now - (today - 1).days);
  }

  static DateTime firstDayOfMonth(DateTime now) {
    int day = now.day;
    return startOfDay(now - (day - 1).days);
  }

  static int getMonthCheckNum(
      List<HabitRecord> todayCheck, Map<String, List<HabitRecord>> totalCheck) {
    int num = 0;
    if (totalCheck != null) {
      DateTime now = DateTime.now();
      //2020-10-10 get 10-1 --> 10-10
      int today = now.day;
      for (int i = 1; i < today; i++) {
        DateTime oldDay = DateTime(now.year, now.month, i);
        List<HabitRecord> checks =
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

  static String getDayPeroidDtring(DateTime now, int dayIndex) {
    DateTime time = now - dayIndex.days;
    return '${twoDigits(time.month)}.${twoDigits(time.day)}';
  }

  static DateTime getDayPeroid(DateTime now, int dayIndex) {
    return now - dayIndex.days;
  }

  static String getWeekPeriodString(DateTime now, int weekIndex) {
    Pair<DateTime> peroid = getWeekStartAndEnd(now, weekIndex);
    return '${twoDigits(peroid.x0.month)}.${twoDigits(peroid.x0.day)} - ${twoDigits(peroid.x1.month)}.${twoDigits(peroid.x1.day)}';
  }

  static String getMonthPeriodString(DateTime now, int monthIndex) {
    Pair<DateTime> peroid = getMonthStartAndEnd(now, monthIndex);
    return '${twoDigits(peroid.x0.month)}.${twoDigits(peroid.x0.day)} - ${twoDigits(peroid.x1.month)}.${twoDigits(peroid.x1.day)}';
  }

  ///根据当前时间获取，[monthIndex]个月的开始结束日期
  static Pair<DateTime> getMonthStartAndEnd(DateTime now, int monthIndex) {
    DateTime start = DateTime(now.year, now.month - monthIndex, 1);
    DateTime end = DateTime(now.year, now.month - monthIndex + 1, 0);
    return Pair<DateTime>(start, end);
  }

  ///根据当前时间获取，[weekIndex]周前的开始结束日期
  static Pair<DateTime> getWeekStartAndEnd(DateTime now, int weekIndex) {
    DateTime _now = DateTime(now.year, now.month, now.day);
    DateTime start = _now - (_now.weekday - 1 + 7 * weekIndex).days;
    DateTime end = start + 6.days;
    return Pair<DateTime>(start, end);
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

  static String parseHourAndMin(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
  }

  static String parseHourAndMinAndSecond(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}:${twoDigits(dateTime.second)}';
  }

  static String parseYearAndMonthAndDay(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return '${dateTime.year} ${twoDigits(dateTime.month)} ${twoDigits(dateTime.day)}';
  }

  static String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  static DateTime startOfDay(DateTime now) {
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime endOfDay(DateTime now) {
    return startOfDay(now) + 1.days - 1.milliseconds;
  }

  static bool isFuture(DateTime time) {
    return startOfDay(time).millisecondsSinceEpoch >
        endOfDay(DateTime.now()).millisecondsSinceEpoch;
  }

  ///判断当前时间是否在给定时间之前
  static bool isLast(DateTime now, DateTime time) {
    return endOfDay(now).millisecondsSinceEpoch <
        startOfDay(time).millisecondsSinceEpoch;
  }

  /// '15:12' 返回当天的这个时间
  static DateTime parseHourAndMinWithString(String day) {
    DateTime now = DateTime.now();
    List<String> str = day.split(':');
    return now.copyWith(hour: int.parse(str[0]), minute: int.parse(str[1]));
  }

  /// '2020-12-20' 返回当天的这个时间
  static DateTime parseYearAndMonthAndDayWithString(String day) {
    List<String> str = day.split('-');
    return DateTime(int.parse(str[0]), int.parse(str[1]), int.parse(str[2]));
  }

  ///根据给定时间获取当前月的第一天
  static DateTime getFirstDayOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  ///获取从 2020 年 1月份 之后的所有 月份 第一天
  static List<DateTime> getMonthsSince2020() {
    List<DateTime> months = [];
    int i = 1;
    while (DateTime(2020, i, 1).microsecondsSinceEpoch <
        DateTime.now().microsecondsSinceEpoch) {
      months.add(DateTime(2020, i, 1));
      i++;
    }
    return months;
  }

  /// 0-5 晚上
  /// 5 - 9 早上
  /// 9-12 上午
  /// 12-14 中午
  /// 14-18 下午
  /// 18- 24 晚上
  static String getNowTimeString() {
    int hour = DateTime.now().hour;
    String time = '';
    if (hour >= 5 && hour < 9) {
      time = '早上';
    } else if (hour >= 9 && hour < 12) {
      time = '上午';
    } else if (hour >= 12 && hour < 14) {
      time = '中午';
    } else if (hour >= 14 && hour < 18) {
      time = '下午';
    } else {
      time = '晚上';
    }
    return time;
  }

  static String getNowString() {
    DateTime now = DateTime.now();
    return '${now.year}年${now.month}月${now.day}日';
  }

  static int filterCreateDays(List<int> completeDays, DateTime createTime,
      DateTime startTime, DateTime endTime) {
    createTime = startOfDay(createTime);
    endTime = startOfDay(endTime);
    startTime = startOfDay(startTime);
    Duration duration = Duration(
        milliseconds: createTime.millisecondsSinceEpoch -
            startTime.millisecondsSinceEpoch);
    int dayNum;
    if (duration.inDays >= 0) {
      dayNum = Duration(
                  milliseconds: endTime.millisecondsSinceEpoch -
                      createTime.millisecondsSinceEpoch)
              .inDays +
          1;
      dayNum = List.generate(
              dayNum,
              (index) => DateTime(
                  createTime.year, createTime.month, createTime.day + index))
          .where((day) => completeDays.contains(day.weekday))
          .length;
    } else {
      dayNum = Duration(
                  milliseconds: endTime.millisecondsSinceEpoch -
                      startTime.millisecondsSinceEpoch)
              .inDays +
          1;
      dayNum = List.generate(
              dayNum,
              (index) => DateTime(
                  startTime.year, startTime.month, startTime.day + index))
          .where((day) => completeDays.contains(day.weekday))
          .length;
    }
    return dayNum;
  }

  static DateTime addMin(DateTime time, int min) {
    return time + min.minutes;
  }
}
