import 'dart:convert';

import 'package:timefly/models/habit.dart';

void main() {
  print("object");
  String listStr = '[{"name":"name1"},{"name":"name2"}]';

  var list = jsonDecode(listStr);
  List<Name> names = [];
  for (dynamic data in list) {
    Name name = Name.formJson(data);
    print(name.name);
    names.add(name);
  }
  print(list.length);
  String nameStrings = jsonEncode(names);
  print(nameStrings);
  String string = '["good","morning"]';

  var strings = jsonDecode(string);
  List<String> datas = [];
  for (dynamic data in strings) {
    datas.add(data);
  }

  print(jsonEncode(datas));

  List<String> times = ["18:11", "12:60"];
  List<HabitRecords> records = [];
  records.add(HabitRecords(time: 1111, content: "cidw"));
  Habit habit = Habit(
      id: "11",
      name: "name",
      iconPath: "adad",
      mainColor: 111,
      mark: "mark",
      remindTimes: times,
      period: 1,
      createTime: 111,
      modifyTime: 1111,
      completed: false,
      records: records);

  Map<String,dynamic> map = habit.toJson();
  print(map["remindTimes"].runtimeType.toString());
  print(map["period"].runtimeType.toString());
  print(map["records"].runtimeType.toString());
  print(habit.toJson());
  print(habit.toString());
}

class Name {
  final String name;

  Name(this.name);

  static Name formJson(Map<String, dynamic> map) {
    return Name(map['name']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
