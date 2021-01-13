import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:time/time.dart';
import 'package:timefly/models/habit_peroid.dart';

class HabitUtil {
  ///按completeTime分类，子分类下按时间排序
  static List<OnDayHabitListData> sortByCompleteTime(List<Habit> habits) {
    List<OnDayHabitListData> datas = [];
    if (habits.length > 0) {
      Map<int, List<Habit>> map = {};
      habits.forEach((habit) {
        int completeTime = habit.completeTime;
        if (map[completeTime] == null) {
          map[completeTime] = List<Habit>();
        }
        map[completeTime].add(habit);
      });

      List<int> keys = map.keys.toList();
      keys.sort((a, b) => a.compareTo(b));

      Map<int, List<Habit>> newMap = {};
      keys.forEach((key) {
        newMap[key] = map[key];
      });

      newMap.forEach((completeTime, habits) {
        datas.add(OnDayHabitListData(
            type: OnDayHabitListData.typeTitle,
            value: CompleteTime.getTime(completeTime)));
        habits.sort((a, b) => b.createTime.compareTo(a.createTime));
        datas.add(OnDayHabitListData(
            type: OnDayHabitListData.typeHabits, value: habits));
      });
    }
    return datas;
  }

  /// 获取历史最大连续数量
  static int getMostStreaks(Map<String, List<HabitRecord>> checks) {
    List<String> days = checks.keys.toList();
    List<int> sort = [];
    int count = 1;
    for (int i = days.length - 1; i >= 0; i--) {
      DateTime dayi = getDay(days[i]);
      ///TODO 按周，排除没有选择的周期，也算连续
      DateTime nextDay = i == 0 ? null : getDay(days[i - 1]);
      if (isNextDay(dayi, nextDay) && nextDay != null) {
        count++;
      } else {
        sort.add(int.parse('$count'));
        count = 1;
      }
    }
    sort.sort((a, b) => b - a);
    if (sort.length == 0) {
      return 0;
    }
    return sort.first;
  }

  static DateTime getDay(String day) {
    List<String> str = day.split('-');
    return DateTime(int.parse(str[0]), int.parse(str[1]), int.parse(str[2]));
  }

  static bool isNextDay(DateTime day1, DateTime nextDay) {
    return nextDay == day1 - 1.days;
  }

  static int getDoNums(Habit habit) {
    int num = 0;
    return num;
  }

  static int getDoDays(Habit habit) {
    int num = 0;
    return num;
  }

  static List<Habit> sortByCreateTime(List<Habit> habits) {
    if (habits == null) {
      return <Habit>[];
    }

    habits.sort((a, b) => b.createTime.compareTo(a.createTime));
    return habits;
  }

  static Map<String, List<HabitRecord>> combinationRecords(
      List<HabitRecord> records) {
    Map<String, List<HabitRecord>> recordsMap = {};
    records.forEach((record) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(record.time);
      String timeStr = '${time.year}-${time.month}-${time.day}';
      if (recordsMap.containsKey(timeStr)) {
        recordsMap[timeStr].add(record);
      } else {
        recordsMap[timeStr] = [record];
      }
    });
    return recordsMap;
  }
}
