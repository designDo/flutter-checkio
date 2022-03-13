import 'package:bloc/bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/user.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  ///初始化状态为正在加载
  HabitsBloc() : super(HabitsLoadInProgress()) {
    on<HabitsLoad>(_mapHabitsLoadToState);
    on<HabitsAdd>(_mapHabitsAddToState);
    on<HabitUpdate>(_mapHabitUpdateToState);
  }

  void _mapHabitsLoadToState(
      HabitsLoad event, Emitter<HabitsState> emit) async {
    try {
      if (!SessionUtils.sharedInstance().isLogin()) {
        emit(HabitLoadSuccess([]));
        return;
      }
      List<Habit> habits = await DatabaseProvider.db.getAllHabits();
      print(habits);
      emit(HabitLoadSuccess(habits));
    } catch (e) {
      print(e);
      emit(HabitsLodeFailure());
    }
  }

  void _mapHabitsAddToState(HabitsAdd event, Emitter<HabitsState> emit) {
    if (state is HabitLoadSuccess) {
      final List<Habit> habits = List.from((state as HabitLoadSuccess).habits)
        ..add(event.habit);
      emit(HabitLoadSuccess(habits));
      DatabaseProvider.db.insert(event.habit);
    }
  }

  void _mapHabitUpdateToState(HabitUpdate event, Emitter<HabitsState> emit) {
    if (state is HabitLoadSuccess) {
      final List<Habit> habits = (state as HabitLoadSuccess)
          .habits
          .map((habit) => habit.id == event.habit.id ? event.habit : habit)
          .toList();
      emit(HabitLoadSuccess(habits));
      DatabaseProvider.db.update(event.habit);
    }
  }
}
