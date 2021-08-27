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
}

class SessionUtils {
  static User currentUser;

  static init() async {
    currentUser = await DatabaseProvider.db.getCurrentUser();
  }

  static void login(User user) {
    currentUser = user;
  }

  static void logout() {
    currentUser = null;
  }

  static bool isLogin() {
    return currentUser != null;
  }

  static String getUserId() {
    return currentUser?.id;
  }
}
