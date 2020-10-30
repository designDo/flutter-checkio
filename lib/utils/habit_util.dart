import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_list_model.dart';

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
}
