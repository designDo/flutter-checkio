import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/user.dart';

class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoadSuccess extends UserState {
  final User user;

  UserLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class UserLoadingInProgress extends UserState {}

class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserLoginEvent extends UserEvent {
  final User user;

  UserLoginEvent(this.user);

  @override
  List<Object> get props => [user];
}

class UserLogoutEvent extends UserEvent {}

class UserLoadEvent extends UserEvent {}

class UserBloc extends Bloc<UserEvent, UserState> {
  final HabitsBloc habitsBloc;

  UserBloc(this.habitsBloc) : super(UserLoadSuccess(null));

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoginEvent) {
      yield* _mapUserLoginToState(event);
    } else if (event is UserLogoutEvent) {
      yield* _mapUserLogoutToState(event);
    } else if (event is UserLoadEvent) {
      yield* _mapUserLoadState(event);
    }
  }

  Stream<UserState> _mapUserLoginToState(UserLoginEvent event) async* {
    await DatabaseProvider.db.saveUser(event.user);
    // SessionUtils.login(event.user);
    yield UserLoadSuccess(event.user);
    habitsBloc.add(HabitsLoad());
  }

  Stream<UserState> _mapUserLogoutToState(UserLogoutEvent event) async* {
    await DatabaseProvider.db.deleteUser();
    // SessionUtils.logout();
    yield UserLoadSuccess(null);
    habitsBloc.add(HabitsLoad());
  }

  Stream<UserState> _mapUserLoadState(UserLoadEvent event) async* {
    User user = await DatabaseProvider.db.getCurrentUser();
    // SessionUtils.login(user);
    yield UserLoadSuccess(user);
    habitsBloc.add(HabitsLoad());
  }
}
