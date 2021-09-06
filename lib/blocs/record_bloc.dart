import 'package:bloc/bloc.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:equatable/equatable.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/models/habit.dart';

class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

class RecordLoadSuccess extends RecordState {
  final List<HabitRecord> records;
  final bool isAdd;

  RecordLoadSuccess(this.records, {this.isAdd = false});

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
  final DateTime start;
  final DateTime end;

  RecordLoad(this.habitId, this.start, this.end);

  @override
  List<Object> get props => [habitId, start, end];
}

///添加一个数据
class RecordAdd extends RecordEvent {
  final HabitRecord record;

  RecordAdd(this.record);

  @override
  List<Object> get props => [record];
}

class RecordDelete extends RecordEvent {
  final String habitId;
  final HabitRecord record;

  RecordDelete(this.habitId, this.record);

  @override
  List<Object> get props => [habitId, record];
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
    } else if (event is RecordAdd) {
      yield* _mapRecordAddToState(event);
    } else if (event is RecordUpdate) {
      yield* _mapRecordUpdateToState(event);
    } else if (event is RecordDelete) {
      yield* _mapRecordDeleteToState(event);
    }
  }

  Stream<RecordState> _mapRecordLoadToState(RecordLoad event) async* {
    try {
      List<HabitRecord> records;
      if (habitsBloc.state is HabitLoadSuccess) {
        Habit habit = (habitsBloc.state as HabitLoadSuccess)
            .habits
            .firstWhere((habit) => habit.id == event.habitId);
        records = habit.records;

        if (records != null && records.length > 0) {
          if (event.start != null && event.end != null) {
            records = records
                .where((element) =>
                    element.time > event.start.millisecondsSinceEpoch &&
                    element.time < event.end.millisecondsSinceEpoch)
                .toList();
            records.sort((a, b) => b.time - a.time);
          } else {
            records.sort((a, b) => b.time - a.time);
          }
        }
        yield RecordLoadSuccess(records);
        return;
      }
      records = [];
      yield RecordLoadSuccess(records);
    } catch (_) {
      yield RecordLoadFailure();
    }
  }

  Stream<RecordState> _mapRecordAddToState(RecordAdd event) async* {
    if (state is RecordLoadSuccess) {
      HabitRecord_ _habitRecord = HabitRecord_(event.record);
      try {
        BmobSaved saved = await _habitRecord.save();
        print('save record success ${saved.objectId}');
        HabitRecord addedRecord =
            event.record.copyWith(objectId: saved.objectId);
        final List<HabitRecord> records =
            List.from((state as RecordLoadSuccess).records)
              ..insert(0, addedRecord);

        if (habitsBloc.state is HabitLoadSuccess) {
          Habit currentHabit = (habitsBloc.state as HabitLoadSuccess)
              .habits
              .firstWhere((habit) => habit.id == addedRecord.habitId);
          habitsBloc.add(HabitUpdate(currentHabit.copyWith(
              records: List.from(currentHabit.records)..add(addedRecord))));
        }
        yield RecordLoadSuccess(records, isAdd: true);
      } catch (e) {
        print('save record error : ${BmobError.convert(e)}');
      }
    }
  }

  Stream<RecordState> _mapRecordUpdateToState(RecordUpdate event) async* {
    if (state is RecordLoadSuccess) {
      HabitRecord_ _habitRecord = HabitRecord_(event.record);
      try {
        BmobUpdated updated = await _habitRecord.update();
        print('update success : ${updated.updatedAt}');
        final List<HabitRecord> records = (state as RecordLoadSuccess)
            .records
            .map((record) =>
                record.time == event.record.time ? event.record : record)
            .toList();
        yield RecordLoadSuccess(records);

        if (habitsBloc.state is HabitLoadSuccess) {
          Habit currentHabit = (habitsBloc.state as HabitLoadSuccess)
              .habits
              .firstWhere((habit) => habit.id == event.record.habitId);
          List<HabitRecord> currentHabitRecords =
              List<HabitRecord>.from(currentHabit.records);
          for (int i = 0; i < currentHabitRecords.length; i++) {
            if (currentHabitRecords[i].time == event.record.time) {
              currentHabitRecords[i] = event.record;
            }
          }
          habitsBloc.add(
              HabitUpdate(currentHabit.copyWith(records: currentHabitRecords)));
        }
      } catch (e) {
        print('update error : ${BmobError.convert(e)}');
      }
    }
  }

  Stream<RecordState> _mapRecordDeleteToState(RecordDelete event) async* {
    if (state is RecordLoadSuccess) {
      HabitRecord_ _habitRecord = HabitRecord_(event.record);

      try {
        BmobHandled handled = await _habitRecord.delete();
        print('delete record success : ${handled.msg}');
        final List<HabitRecord> records =
            List.from((state as RecordLoadSuccess).records)
              ..removeWhere((record) => record.time == event.record.time);
        yield RecordLoadSuccess(records);

        if (habitsBloc.state is HabitLoadSuccess) {
          Habit currentHabit = (habitsBloc.state as HabitLoadSuccess)
              .habits
              .firstWhere((habit) => habit.id == event.habitId);
          habitsBloc.add(HabitUpdate(currentHabit.copyWith(
              records: List.from(currentHabit.records)
                ..removeWhere((record) => record.time == event.record.time))));
        }
      } catch (e) {
        print('delete record error : ${BmobError.convert(e)}');
      }
    }
  }
}
