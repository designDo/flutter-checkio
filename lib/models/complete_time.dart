class CompleteTime {
  ///0 任意
  ///1 早上
  ///2 上午
  ///3 中午
  ///4 下午
  ///5 晚上
  final int time;
  bool isSelect = false;

  CompleteTime(this.time, {this.isSelect = false});

  static List<CompleteTime> getCompleteTimes() {
    List<CompleteTime> completeTimes = [];
    for (int i = 0; i <= 5; i++) {
      completeTimes.add(CompleteTime(i, isSelect: i == 0));
    }
    return completeTimes;
  }

  static String getTime(int time) {
    String timeString = '任意';
    switch (time) {
      case 1:
        timeString = '早上';
        break;
      case 2:
        timeString = '上午';
        break;
      case 3:
        timeString = '中午';
        break;
      case 4:
        timeString = '下午';
        break;
      case 5:
        timeString = '晚上';
        break;
    }
    return timeString;
  }
}