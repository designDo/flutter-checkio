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
}
