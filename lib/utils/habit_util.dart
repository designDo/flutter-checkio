import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:time/time.dart';
import 'package:timefly/models/habit_peroid.dart';

class HabitUtil {
  ///按 completeTime分类，子分类下按时间排序
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
        for (var habit in habits) {
          datas.add(OnDayHabitListData(
              type: OnDayHabitListData.typeHabit, value: habit));
        }
      });
    }
    return datas;
  }

  static int getMostStreaks(Habit habit) {
    int num = 0;
    Map<String, List<int>> totalCheck = habit.totalCheck;
    if (totalCheck == null) {
      return num;
    }
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    ///昨天 前天 大前天 是否连续包含
    for (int i = 1; i < 10000; i++) {
      DateTime lastDay = today - i.days;
      List<int> lastDayCheck =
          totalCheck['${lastDay.year}-${lastDay.month}-${lastDay.day}'];
      if (lastDayCheck != null) {
        if (habit.period == HabitPeroid.day &&
            lastDayCheck.length != habit.doNum) {
          return num;
        } else {
          num += 1;
        }
      } else {
        return num;
      }
    }

    return num;
  }

  static List<Habit> sortByCreateTime(List<Habit> habits) {
    if (habits == null) {
      return <Habit>[];
    }

    habits.sort((a, b) => b.createTime.compareTo(a.createTime));
    return habits;
  }
}
