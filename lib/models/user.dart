import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/db/database_provider.dart';

class User {
  final String id;
  final String username;
  final String phone;

  User(this.id, this.username, this.phone);

  static User fromJson(Map<String, dynamic> json) {
    return User(json['id']?.toString(), json["username"]?.toString(),
        json["phone"]?.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data["username"] = username;
    data["phone"] = phone;
    return data;
  }

  User copyWith({String id, String username, String phone}) {
    return User(id ?? this.id, username ?? this.username, phone ?? this.phone);
  }
}

class SessionUtils {
  SessionUtils._();

  factory SessionUtils() => sharedInstance();

  static SessionUtils sharedInstance() {
    return _instance;
  }

  static SessionUtils _instance = SessionUtils._();

  User currentUser;
  HabitsBloc habitsBloc;

  init() async {
    currentUser = await DatabaseProvider.db.getCurrentUser();
    print('init user -- ${currentUser?.toJson()}');
  }

  void setBloc(HabitsBloc habitsBloc) {
    this.habitsBloc = habitsBloc;
  }

  void login(User user) async {
    if (currentUser != null) {
      await DatabaseProvider.db.deleteUser();
    }
    currentUser = user;
    await DatabaseProvider.db.saveUser(user);
    habitsBloc.add(HabitsLoad());
  }

  void logout() async {
    currentUser = null;
    await DatabaseProvider.db.deleteUser();
    habitsBloc.add(HabitsLoad());
  }

  void updateName(String name) async {
    currentUser = currentUser.copyWith(username: name);
    await DatabaseProvider.db.updateUser(currentUser);
  }

  bool isLogin() {
    return currentUser != null;
  }

  String getUserId() {
    return currentUser?.id;
  }
}
