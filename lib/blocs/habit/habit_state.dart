import 'package:equatable/equatable.dart';
import 'package:timefly/models/habit.dart';

///习惯列表状态
abstract class HabitsState extends Equatable {
  const HabitsState();

  @override
  List<Object> get props => [];
}

///正在加载习惯列表 显示 loading样式
class HabitsLoadInProgress extends HabitsState {}

///习惯加载完成 显示习惯列表
class HabitLoadSuccess extends HabitsState {
  final List<Habit> habits;

  const HabitLoadSuccess(this.habits);

  @override
  List<Object> get props => [habits];
}

///习惯加载失败，显示异常UI
class HabitsLodeFailure extends HabitsState {

}
