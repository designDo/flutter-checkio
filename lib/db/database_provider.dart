import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timefly/models/habit.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  static const String RECORDS = 'records';

  ///my database
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'habitDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating habit table");
        await database.execute(
          "CREATE TABLE habits ("
          "id TEXT,"
          "name TEXT,"
          "iconPath TEXT,"
          "mainColor INTEGER,"
          "mark TEXT,"
          "remindTimes TEXT,"
          "period INTEGER,"
          "completeTime INTEGER,"
          "completeDays TEXT,"
          "createTime INTEGER,"
          "modifyTime INTEGER,"
          "completed INTEGER,"
          "doNum INTEGER,"
          "todayCheck TEXT,"
          "totalCheck TEXT"
          ")",
        );
        await database.execute("CREATE TABLE records ("
            "time INTEGER,"
            "habitId TEXT,"
            "content TEXT"
            ")");
      },
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    var habits = await db.query('habits');
    List<Habit> newHabitList = [];
    habits.forEach((element) {
      newHabitList.add(Habit.fromJson(element));
    });
    return newHabitList;
  }

  /// 根据 habitId和时间范围筛选出符合条件的记录
  Future<List<HabitRecord>> getHabitRecords(String habitId,
      {DateTime start, DateTime end}) async {
    final db = await database;
    var records = List.from(
        await db.query(RECORDS, where: 'habitId = ?', whereArgs: [habitId]));
    List<HabitRecord> habitRecords = [];
    if (records != null && records.length > 0) {
      if (start != null && end != null) {
        records
            .where((element) =>
                element['time'] > start.millisecondsSinceEpoch &&
                element['time'] < end.millisecondsSinceEpoch)
            .toList();
        records.sort((a, b) => b['time'] - a['time']);
      } else {
        records.sort((a, b) => b['time'] - a['time']);
      }
      records.forEach((element) {
        habitRecords.add(HabitRecord.fromJson(element));
      });
    }
    return habitRecords;
  }

  ///获取天数分类习惯个数，用于’我的一天‘页面分类
  Future<int> getPeriodHabitsSize(int period) async {
    final db = await database;
    var habits =
        await db.query('habits', where: 'period = ?', whereArgs: [period]);
    return habits.length;
  }

  Future<Habit> insert(Habit habit) async {
    final db = await database;
    var queryHabits =
        await db.query('habits', where: 'id = ?', whereArgs: [habit.id]);
    bool exist = false;
    queryHabits.forEach((element) {
      if (element['id'] == habit.id) {
        exist = true;
      }
    });
    if (exist) {
      print('habit has exits');
      return null;
    }
    await db.insert('habits', habit.toJson());
    return habit;
  }

  Future<bool> insertHabitRecord(HabitRecord record) async {
    final db = await database;
    int index = await db.insert(RECORDS, record.toJson());
    return index > 0;
  }

  Future<bool> deleteHabitrecord(HabitRecord record) async {
    final db = await database;
    int index =
        await db.delete(RECORDS, where: 'time = ?', whereArgs: [record.time]);
    return index > 0;
  }

  Future<bool> updateHabitRecord(HabitRecord habitRecord) async {
    final db = await database;
    int change = await db.update(RECORDS, habitRecord.toJson(),
        where: 'time = ?', whereArgs: [habitRecord.time]);
    return change > 0;
  }

  ///更新
  Future<bool> update(Habit habit) async {
    final db = await database;
    int change = await db.update('habits', habit.toJson(),
        where: 'id = ?', whereArgs: [habit.id]);
    return change > 0;
  }
}
