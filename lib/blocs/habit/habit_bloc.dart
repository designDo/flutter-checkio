import 'package:bloc/bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/models/habit.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  ///初始化状态为正在加载
  HabitsBloc() : super(HabitsLoadInProgress());

  @override
  Stream<HabitsState> mapEventToState(HabitsEvent event) async* {
    if (event is HabitsLoad) {
      yield* _mapHabitsLoadToState();
    } else if (event is HabitsAdd) {
      //TODO add
    }
  }

  Stream<HabitsState> _mapHabitsLoadToState() async* {
    try {
      List<Habit> habits = [];
      for (int i = 0; i < 10; i++) {
        habits.add(Habit('id$i', 'name$i', 'iconPath$i', i, 'mark$i',
            'remindTimes$i', i, i, i, false, i, 'records$i'));
      }
      yield HabitLoadSuccess(habits);
    } catch (_) {
      yield HabitsLodeFailure();
    }
  }
}
