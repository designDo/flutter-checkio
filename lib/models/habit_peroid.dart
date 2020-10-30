class HabitPeroid {
  static const int day = 0;
  static const int week = 1;
  static const int month = 2;

  ///0 按天
  ///1 按周
  ///2 按月
  final int peroid;
  bool isSelect = false;

  HabitPeroid(this.peroid, {this.isSelect = false});

  static List<HabitPeroid> getHabitPeroids() {
    List<HabitPeroid> peroids = [];
    for (int i = 0; i <= 2; i++) {
      peroids.add(HabitPeroid(i, isSelect: i == 0));
    }
    return peroids;
  }

  static String getPeroid(int peroid) {
    String peroidString = '天';
    switch (peroid) {
      case day:
        peroidString = '天';
        break;
      case week:
        peroidString = '周';
        break;
      case month:
        peroidString = '月';
        break;
    }
    return peroidString;
  }
}
