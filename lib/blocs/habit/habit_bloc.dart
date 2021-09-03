import 'package:bloc/bloc.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/user.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  ///初始化状态为正在加载
  HabitsBloc() : super(HabitsLoadInProgress());

  @override
  Stream<HabitsState> mapEventToState(HabitsEvent event) async* {
    if (event is HabitsLoad) {
      yield* _mapHabitsLoadToState();
    } else if (event is HabitsAdd) {
      yield* _mapHabitsAddToState(event);
    } else if (event is HabitUpdate) {
      yield* _mapHabitUpdateToState(event);
    }
  }

  Stream<HabitsState> _mapHabitsLoadToState() async* {
    try {
      if (!SessionUtils.sharedInstance().isLogin()) {
        yield HabitLoadSuccess([]);
        return;
      }
      BmobQuery<Habit_> habitQuery = BmobQuery();
      habitQuery.addWhereEqualTo(
          'userId', SessionUtils.sharedInstance().getUserId());
      var habitsData = await habitQuery.queryObjects();

      BmobQuery<HabitRecord_> recordQuery = BmobQuery();
      recordQuery.addWhereEqualTo(
          'userId', SessionUtils.sharedInstance().getUserId());
      var recordsData = await recordQuery.queryObjects();

      List<HabitRecord> records =
          recordsData.map((data) => HabitRecord.fromJson(data)).toList();

      //merge
      List<Habit> habits = habitsData.map((data) {
        Habit habit = Habit.fromJson(data);
        List<HabitRecord> recordList = [];
        for (var value in records) {
          if (habit.id == value.habitId) {
            recordList.add(value);
          }
        }
        return habit.copyWith(records: recordList);
      }).toList();
      print(habits);
      yield HabitLoadSuccess(habits);
    } catch (e) {
      print(e);
      yield HabitsLodeFailure();
    }
  }

  Stream<HabitsState> _mapHabitsAddToState(HabitsAdd habitsAdd) async* {
    if (state is HabitLoadSuccess) {
      Habit_ _habit = Habit_(habitsAdd.habit);
      try {
        BmobSaved saved = await _habit.save();
        print('habit save success : ${saved.objectId}');
        Habit addedHabit = habitsAdd.habit.copyWith(objectId: saved.objectId);
        final List<Habit> habits = List.from((state as HabitLoadSuccess).habits)
          ..add(addedHabit);
        yield HabitLoadSuccess(habits);
      } catch (e) {
        print('habit save error : ${BmobError.convert(e)}');
      }
    }
  }

  Stream<HabitsState> _mapHabitUpdateToState(HabitUpdate habitUpdate) async* {
    if (state is HabitLoadSuccess) {
      Habit_ _habit = Habit_(habitUpdate.habit);
      try {
        BmobUpdated updated = await _habit.update();
        print("habit update success ${updated.updatedAt}");
        final List<Habit> habits = (state as HabitLoadSuccess)
            .habits
            .map((habit) =>
                habit.id == habitUpdate.habit.id ? habitUpdate.habit : habit)
            .toList();
        yield HabitLoadSuccess(habits);
      } catch (e) {
        print('habit update error : ${BmobError.convert(e)}');
      }
    }
  }
}
