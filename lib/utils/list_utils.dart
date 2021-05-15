class ListUtils {
  static bool equals(List<int> first, List<int> second) {
    if (first.length != second.length) {
      return false;
    }
    bool equals = true;
    for (int i = 0; i < first.length; i++) {
      if (first[i] != second[i]) {
        equals = false;
        break;
      }
    }
    return equals;
  }

  static bool containsRemindTime(List<DateTime> remindTimes, DateTime time) {
    bool contain = false;
    if (remindTimes.length == 0) {
      return false;
    }
    for (var value in remindTimes) {
      if (value.hour == time.hour && value.minute == time.minute) {
        contain = true;
        break;
      }
    }
    return contain;
  }
}
