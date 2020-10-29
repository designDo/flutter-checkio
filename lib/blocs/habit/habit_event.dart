import 'package:equatable/equatable.dart';
import 'package:timefly/models/habit.dart';

///驱动UI的事件，数据库操作，将事件转化为包含数据的state返回
class HabitsEvent extends Equatable {
  const HabitsEvent();

  @override
  List<Object> get props => [];
}

///加载数据库数据事件
class HabitsLoad extends HabitsEvent {}

///添加一个数据
class HabitsAdd extends HabitsEvent {
  final Habit habit;

  HabitsAdd(this.habit);

  @override
  List<Object> get props => [habit];
}

///更新
class HabitUpdate extends HabitsEvent {
  final Habit habit;

  HabitUpdate(this.habit);

  @override
  List<Object> get props => [habit];
}
