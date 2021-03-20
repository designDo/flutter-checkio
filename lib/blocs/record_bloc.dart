import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';

import 'habit/habit_event.dart';

class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

class RecordLoadSuccess extends RecordState {
  final List<HabitRecord> records;

  RecordLoadSuccess(this.records);

  @override
  List<Object> get props => [records];
}

class RecordLoadInProgress extends RecordState {}

class RecordLoadFailure extends RecordState {}

class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

///加载数据库数据事件
class RecordLoad extends RecordEvent {
  final String habitId;

  RecordLoad(this.habitId);

  @override
  List<Object> get props => [habitId];
}

///添加一个数据
class RecordAdd extends RecordEvent {
  final HabitRecord record;

  RecordAdd(this.record);

  @override
  List<Object> get props => [record];
}

///更新
class RecordUpdate extends RecordEvent {
  final HabitRecord record;

  RecordUpdate(this.record);

  @override
  List<Object> get props => [record];
}

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final HabitsBloc habitsBloc;

  ///初始化状态为正在加载
  RecordBloc(this.habitsBloc) : super(RecordLoadInProgress());

  @override
  Stream<RecordState> mapEventToState(RecordEvent event) async* {
    if (event is RecordLoad) {
      yield* _mapRecordLoadToState(event);
    } else if (event is HabitsAdd) {
      yield* _mapRecordAddToState(event);
    } else if (event is HabitUpdate) {
      yield* _mapRecordUpdateToState(event);
    }
  }

  Stream<RecordState> _mapRecordLoadToState(RecordLoad event) async* {
    try {
      if (habitsBloc.state is HabitLoadSuccess) {
        Habit habit = (habitsBloc.state as HabitLoadSuccess)
            .habits
            .firstWhere((habit) => habit.id == event.habitId);
        yield RecordLoadSuccess(List.from(habit.records));
      }
    } catch (_) {
      yield RecordLoadFailure();
    }
  }

  Stream<RecordState> _mapRecordAddToState(RecordAdd event) async* {
    if (state is RecordLoadSuccess) {
      final List<HabitRecord> records =
          List.from((state as RecordLoadSuccess).records)..add(event.record);
      yield RecordLoadSuccess(records);
      DatabaseProvider.db.insertHabitRecord(event.record);
    }
  }

  Stream<RecordState> _mapRecordUpdateToState(RecordUpdate event) async* {
    if (state is RecordLoadSuccess) {
      final List<HabitRecord> records = (state as RecordLoadSuccess)
          .records
          .map((record) =>
              record.time == event.record.time ? event.record : record)
          .toList();
      yield RecordLoadSuccess(records);
      DatabaseProvider.db.updateHabitRecord(event.record);
    }
  }
}
