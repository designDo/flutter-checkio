import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:time/time.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/pair.dart';

class HabitUtil {
  ///按completeTime分类，子分类下按时间排序
  static List<OnDayHabitListData> sortByCompleteTime(List<Habit> habits) {
    List<OnDayHabitListData> datas = [];
    int weekend = DateTime.now().weekday;

    ///过滤当天
    habits = habits
        .where((habit) =>
            habit.period == HabitPeriod.month ||
            (habit.completeDays.contains(weekend)))
        .toList();
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
    Map<String, int> streaks = getHabitStreaks(checks);
    if (streaks.isEmpty) {
      return 0;
    }
    List<int> values = streaks.values.toList();
    values.sort((a, b) => a - b);
    return values.first;
  }

  /// 获取一个习惯历史最大连续数量
  /// String 日期start,end int 数量
  static Map<String, int> getHabitStreaks(
      Map<String, List<HabitRecord>> checks) {
    List<String> days = checks.keys.toList();
    days.sort((a, b) =>
        DateUtil.parseYearAndMonthAndDayWithString(a).millisecondsSinceEpoch -
        DateUtil.parseYearAndMonthAndDayWithString(b).millisecondsSinceEpoch);
    Map<String, int> streaks = {};
    if (days.length == 0) {
      return streaks;
    }
    if (days.length == 1) {
      streaks['${days[0]},${days[0]}'] = 1;
      return streaks;
    }
    int count = 1;
    DateTime startDay = getDay(days.first);
    for (int i = 0; i < days.length - 1; i++) {
      DateTime dayi = getDay(days[i]);

      ///只算天和月，周无法统计连续
      DateTime nextDay = getDay(days[i + 1]);
      if (isNextDay(dayi, nextDay)) {
        count++;
      } else {
        streaks['${DateUtil.formDateTime(startDay)},${DateUtil.formDateTime(dayi)}'] =
            int.parse('$count');
        count = 1;
        startDay = nextDay;
      }
      if (i + 1 == days.length - 1) {
        streaks['${DateUtil.formDateTime(startDay)},${DateUtil.formDateTime(nextDay)}'] =
            int.parse('$count');
      }
    }

    List<String> keys = streaks.keys.toList();
    keys.sort((a, b) => streaks[b] == streaks[a] ? 1 : streaks[b] - streaks[a]);
    Map<String, int> newStreaks = {};
    keys.forEach((key) {
      if (streaks[key] >= 1) {
        newStreaks[key] = streaks[key];
      }
    });
    return newStreaks;
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

  static bool isNextDay(DateTime day, DateTime nextDay) {
    return day == nextDay - 1.days;
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

  static Map<String, List<HabitRecord>> combinationRecordsWithTime(
      List<HabitRecord> records, DateTime start, DateTime end) {
    List<HabitRecord> recordList = List<HabitRecord>.from(records);
    recordList = recordList
        .where((record) =>
            record.time > start.millisecondsSinceEpoch &&
            record.time < end.millisecondsSinceEpoch)
        .toList();
    return combinationRecords(recordList);
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
    int currentMaxDoNum = 1;
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

  ///获取当前拥有最大连续次数的习惯们
  static Pair2<int, List<Habit>> getMostHistoryStreakHabits(
      List<Habit> habits) {
    List<Habit> newHabits = [];
    int currentMaxStreak = 1;

    habits.forEach((habit) {
      if (HabitUtil.containAllDay(habit)) {
        int streak = getNowStreaks(combinationRecords(habit.records));
        if (streak > currentMaxStreak) {
          newHabits.clear();
          newHabits.add(habit);
          currentMaxStreak = streak;
        } else if (streak == currentMaxStreak) {
          newHabits.add(habit);
        }
      }
    });
    return Pair2(currentMaxStreak == 1 ? 0 : currentMaxStreak, newHabits);
  }

  ///根据时间过滤记录
  static List<HabitRecord> filterHabitRecordsWithTime(List<HabitRecord> records,
      {DateTime start, DateTime end}) {
    if (records == null || records.length == 0) {
      return <HabitRecord>[];
    }
    List<HabitRecord> habitRecords = List<HabitRecord>.from(records);

    if (start != null && end != null) {
      habitRecords = habitRecords
          .where((element) =>
              element.time > start.millisecondsSinceEpoch &&
              element.time < end.millisecondsSinceEpoch)
          .toList();
      records.sort((a, b) => b.time - a.time);
    } else {
      records.sort((a, b) => b.time - a.time);
    }
    return habitRecords;
  }

  static List<HabitRecord> getHabitRecordsWithPeroid(
      List<HabitRecord> records, int period) {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end;
    switch (period) {
      case HabitPeriod.day:
        start = DateUtil.startOfDay(now);
        end = DateUtil.endOfDay(now);
        break;
      case HabitPeriod.week:
        start = DateUtil.firstDayOfWeekend(DateTime.now());
        end = DateUtil.endOfDay(DateTime.now());
        break;
      case HabitPeriod.month:
        start = DateUtil.firstDayOfMonth(now);
        end = DateUtil.endOfDay(now);
        break;
    }
    return filterHabitRecordsWithTime(records, start: start, end: end);
  }

  static int getDoCountOfHabit(
      List<HabitRecord> records, DateTime start, DateTime end) {
    start = DateUtil.startOfDay(start);
    end = DateUtil.endOfDay(end);

    int count = records
        .where((record) =>
            record.time > start.millisecondsSinceEpoch &&
            record.time < end.millisecondsSinceEpoch)
        .length;
    return count;
  }

  static bool containAllDay(Habit habit) {
    return habit.period == HabitPeriod.month || habit.completeDays.length == 7;
  }
}
