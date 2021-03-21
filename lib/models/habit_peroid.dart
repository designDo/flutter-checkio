class HabitPeriod {
  static const int day = 0;
  static const int week = 1;
  static const int month = 2;

  ///0 按天
  ///1 按周
  ///2 按月
  final int period;
  bool isSelect = false;

  HabitPeriod(this.period, {this.isSelect = false});

  static List<HabitPeriod> getHabitPeriods(int period) {
    List<HabitPeriod> periods = [];
    for (int i = 0; i <= 2; i++) {
      periods.add(HabitPeriod(i, isSelect: i == period));
    }
    return periods;
  }

  static String getPeriod(int peroid) {
    String periodString = '天';
    switch (peroid) {
      case day:
        periodString = '天';
        break;
      case week:
        periodString = '周';
        break;
      case month:
        periodString = '月';
        break;
    }
    return periodString;
  }
}
