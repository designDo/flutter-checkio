import 'package:bloc/bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/db/database_provider.dart';
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
      List<Habit> habits = await DatabaseProvider.db.getAllHabits();
      print(habits);
      yield HabitLoadSuccess(habits);
    } catch (e) {
      print(e);
      yield HabitsLodeFailure();
    }
  }

  Stream<HabitsState> _mapHabitsAddToState(HabitsAdd habitsAdd) async* {
    if (state is HabitLoadSuccess) {
      final List<Habit> habits = List.from((state as HabitLoadSuccess).habits)
        ..add(habitsAdd.habit);
      yield HabitLoadSuccess(habits);
      DatabaseProvider.db.insert(habitsAdd.habit);
    }
  }

  Stream<HabitsState> _mapHabitUpdateToState(HabitUpdate habitUpdate) async* {
    if (state is HabitLoadSuccess) {
      final List<Habit> habits = (state as HabitLoadSuccess)
          .habits
          .map((habit) =>
              habit.id == habitUpdate.habit.id ? habitUpdate.habit : habit)
          .toList();
      yield HabitLoadSuccess(habits);
      DatabaseProvider.db.update(habitUpdate.habit);
    }
  }
}
