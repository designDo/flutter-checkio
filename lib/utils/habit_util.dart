import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:time/time.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';

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

  ///获取当前最大连续天数
  static int getNowStreaks(Map<String, List<HabitRecord>> checks) {
    List<String> days = checks.keys.toList();
    int count = 0;
    if (days.length == 0) {
      return 0;
    }
    DateTime now = DateTime.now();
    for (int i = 0; i < 10000; i++) {
      DateTime lastDay = now - i.days;
      if (days.contains('${lastDay.year}-${lastDay.month}-${lastDay.day}')) {
        count++;
      } else {
        break;
      }
    }
    return count;
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

  ///获取一个月内记录多少次
  static int getMonthDoNums(List<HabitRecord> checks) {
    if (checks.length == 0) {
      return 0;
    }
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateUtil.firstDayOfMonth(now);
    return checks
        .where((check) =>
            check.time >= firstDayOfMonth.millisecondsSinceEpoch &&
            check.time <= now.millisecondsSinceEpoch)
        .length;
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

  ///一天内所有完成次数
  static int getTotalDoNumsOfDay(List<Habit> habits, DateTime now) {
    int num = 0;
    DateTime start = DateUtil.startOfDay(now);
    DateTime end = DateUtil.endOfDay(now);
    habits.forEach((habit) {
      num += habit.records
          .where((record) =>
              record.time >= start.millisecondsSinceEpoch &&
              record.time <= end.millisecondsSinceEpoch)
          .length;
    });
    return num;
  }

  ///一周内所有完成次数
  static int getTotalDoNumsOfWeek(List<Habit> habits, DateTime now) {
    int num = 0;
    DateTime firstDayOfWeek = DateUtil.firstDayOfWeekend(now);
    habits.forEach((habit) {
      num += habit.records
          .where((record) =>
              record.time >= firstDayOfWeek.millisecondsSinceEpoch &&
              record.time <= now.millisecondsSinceEpoch)
          .length;
    });
    return num;
  }

  ///所有完成次数
  static int getTotalDoNumsOfHistory(List<Habit> habits) {
    int num = 0;
    habits.forEach((habit) {
      num += habit.records.length;
    });
    return num;
  }

  ///获取记录总天数，哪怕一天就一次也算
  static int getTotalDaysOfHistory(List<Habit> habits) {
    List<String> days = [];
    DateTime recordTime;
    habits.forEach((habit) {
      habit.records.forEach((record) {
        recordTime = DateTime.fromMillisecondsSinceEpoch(record.time);
        String dayString =
            '${recordTime.year}-${recordTime.month}-${recordTime.day}';
        if (!days.contains(dayString)) {
          days.add(dayString);
        }
      });
    });
    return days.length;
  }

  ///获取记录次数最多的所有习惯
  static List<Habit> getMostDoNumHabits(List<Habit> habits) {
    List<Habit> newHabits = [];
    int currentMaxDoNum = 0;
    habits.forEach((habit) {
      if (habit.records.length > currentMaxDoNum) {
        newHabits.clear();
        newHabits.add(habit);
        currentMaxDoNum = habit.records.length;
      } else if (habit.records.length == currentMaxDoNum) {
        newHabits.add(habit);
      }
    });
    return newHabits;
  }
}
