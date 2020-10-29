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
}
