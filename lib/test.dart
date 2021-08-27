import 'dart:convert';
import 'package:timefly/models/habit.dart';
import 'package:time/time.dart';
import 'package:timefly/utils/date_util.dart';

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
  List<String> listq = List<String>.from(times);
  for (int i = 0; i < listq.length; i++) {
    if (listq[i] == '18:11') {
      listq[i] = 'aaa';
      print('change');
    }
  }

  print('aaa$listq');

  List<HabitRecord> records = [];
  records.add(HabitRecord(time: 1111, content: "cidw"));
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
  );

  Map<String, dynamic> map = habit.toJson();
  print(map["remindTimes"].runtimeType.toString());
  print(map["period"].runtimeType.toString());
  print(map["records"].runtimeType.toString());
  print(habit.toJson());
  print(habit.toString());

  for (int i = 1; i <= 12; i++) {
    int year = DateTime.now().year;

    int count = DateTime(year, i + 1, 0).day;

    print('$i 月天数为 $count');
  }
  print(DateTime(2021, -1, 1)); //2020-11-01
  print(DateTime(2021, 0, 0)); //2020-11-30
  print(DateTime(2021, 0, 1)); //2020-12-01
  print(DateTime(2021, 1, 0)); //2020-12-31
  print(DateTime(2021, 1, 1)); //2021-01-01
  print(DateTime(2021, 2, 0)); //2021-01-31
  print(DateTime(2021, 2, 1)); //2021-02-01
  print(DateTime(2021, 3, 0)); //2021-02-28

  print(DateUtil.getWeekStartAndEnd(DateTime.now(), 1));
  List<String> days = [
    '2020-1-1',
    '2020-1-2',
    '2020-1-4',
    '2020-1-5',
    '2020-1-6',
    '2020-1-7',
    '2020-1-10',
    '2020-1-11',
    '2020-1-13',
    '2020-1-15',
    '2020-1-16',
    '2020-1-18',
  ];
  print(days);
  List<int> sort = [];
  int count = 1;
  for (int i = days.length - 1; i >= 0; i--) {
    DateTime dayi = getDay(days[i]);
    DateTime nextDay = i == 0 ? null : getDay(days[i - 1]);
    if (isNextDay(dayi, nextDay) && nextDay != null) {
      count++;
    } else {
      sort.add(int.parse('$count'));
      count = 1;
    }
  }
  print(sort);
  print(getMonthsSince2020());
}

List<DateTime> getMonthsSince2020() {
  List<DateTime> months = [];
  int i = 1;
  while (DateTime(2020, i, 1).microsecondsSinceEpoch <
      DateTime.now().microsecondsSinceEpoch) {
    months.add(DateTime(2020, i, 1));
    i++;
  }
  return months;
}

DateTime getDay(String day) {
  List<String> str = day.split('-');
  return DateTime(int.parse(str[0]), int.parse(str[1]), int.parse(str[2]));
}

bool isNextDay(DateTime day1, DateTime nextDay) {
  return nextDay == day1 - 1.days;
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

/*Widget _buildFab() {
  double top = 300.0 - 40;
  double scale = 1.0;
  if (_controller.hasClients) {
    double offset = _controller.offset;
    top -= offset;
    if (offset < 230 && offset > 0) {
      //offset small => don't scale down
      scale = 1.0 - (offset / 230);
    } else if (230 < offset) {
      //offset between scaleStart and scaleEnd => scale down
      scale = 0;
    } else {
      //offset passed scaleEnd => hide fab
      scale = 1.0;
    }
  }
  return Positioned(
    top: top,
    left: 16.0,
    child: new Transform(
      transform: new Matrix4.identity()..scale(scale),
      alignment: Alignment.center,
      child: new FloatingActionButton(
        onPressed: () => {},
        child: new Icon(Icons.add),
      ),
    ),
  );
}*/

/// 如何确定今日已经打卡？
/// 添加字段 today-check List['时间戳']
///         total-check List['2020-12-12:时间戳,时间戳','2020-12-13:时间戳,时间戳]
/// 每次打开APP进行数据库数据整理
///     1.新建习惯，today-check为[], total-check为null
///     2.再次打开，若today-check为[]，则不需要合并到total-check
///                若today-check有值，取最后一个，判断值是否在今天，
///                                            若在今天，不合并，
///                                            若是新的一天，合并，并将today-check置为[]
///     3.先进行合并判断，再过滤当天需要显示的习惯
/// check 当前次数为today-check[]的size
///
///
/// create-time为 2020-12-12 22:10:12，取当天打卡时间，List['时间戳']
/// 判断是否在 2020-12-12 00:00:00 到 2020-12-12 23:59:59之间
///
/// 去除 todayCheck和totalCheck，添加records表，记录所有打卡历史
///   id
///   time 时间戳
///   habitId String
///   note String
///   获取一个习惯的所有打卡历史：根据babitId查找出所有，再根据time排序，按情况分组即可
///   获取一个习惯的当天打卡历史：根据babitId查找出所有，再根据time过滤排序
///   查找，增加，删除，修改，这样就简单了
/// 没有是否完成的评判标准，一天1次的也可一天打卡2次
/// 如何打卡：若是从今天进去，则显示周期内所有打卡历史
///          若是从其他天进去，则只显示当天打卡历史
///
/// 掌握整体趋势
/// 那个完成最好
///        - 一周/一月 内数量最多
///        - 完成度
/// 统计：统计打卡次数
/// 1. 一周/一月内，每个习惯打卡次数柱状图 //哪个打卡最多，完成最好
/// 2. 所有习惯在一周内完成总次数上升曲线图 //每天完成趋势
/// 3. 习惯A在一周内每天的打卡次数柱状图  // 单个习惯的完成度
///
///
/// 1. 所有习惯页面，分成Page和TabBar，Item显示一个月内总打卡次数，最大连续天数，日历显示打卡天次
/// 2. 详情页面，月份切换，显示详细信息，编辑修改
/// 3. 首页当天进度Item，还有多少个未完成，完成总进度。
/// 4. 统计信息 1 一周内每天完成次数趋势图，上一周，下一周
///            2 一月内每天完成次数趋势图，上一月，下一月
/// 5. 设置页面，修改主题，改变颜色，多少个习惯，多少次打卡，
///
/// 详情页
/// 1. 头像Hero动画，名字，创建时间
/// 2. 编辑修改
///         - 从天变为周，以前的记录会造成统计的影响？
/// 3. 月记录，日历切换月份，次数大小颜色深度不同，显示次数角标，年记录，less--more
/// 4. 总签到次数，最大连续天数（只有天/月，最大的三个日期开始结束），当前连续天数（只有天/月）
/// 5. 今日完成情况，周期内剩余多少。
/// 6. 点击那天，可以看下当天的签到记录，可修改
/// 7. 查看过去周期内的完成率
/// 8. 完成率统计
///
/// 月：
/// 1. 天and月，记录的实现颜色。点击，弹出当天所有记录。
/// 2. 周，不在记录内的不可点击
/// 3. 范围为2020年一月份到 本月
///
/// 最近几次的记录显示，跳转到全部记录
///
/// 首页
/// 1. 今天进度，还有多少个习惯未完成，一个习惯今天完成几次，周期内还剩几次。（超额完成）
///
///
/// 完成率怎么算？单独计算
/// 按天计算的所有习惯 - 完成数量 / 总计需完成数量
/// 按周计算的所有习惯 - 一周内完成数量 / 总计一周内完成数量
/// 按月计算的所有习惯 - 一月内完成数量 / 总计一周内完成数量
///
/// 全部完成率统计？
/// 按天计算的 - 四环（今天完成率，7天内平均完成率，15天内平均完成率，30天内平均完成率）
/// 按周计算的 - 三环（本周完成率，一周前完成率，2周前完成率）
/// 按月计算的 - 三环（本月完成率，1月前完成率，2月前完成率）
///
///TODO
///天周期，添加过滤天，详情页中，若都有则显示连续，否则不计算
///周周期，若都有则显示连续，否则不计算
///将图标和颜色拿出来吧
///提醒时间添加到日历
///主题-暗黑，其他颜色主题，字体
///使用说明
///Toast弹框改为更攒劲儿的
///我的页面
/// 习惯个数，打卡次数，
/// 联系我，评价，高级权限开通，赞助，我在这一天 , 手动备份，习惯库，
/// 设置页面
///
///主题
///
/// 修改和添加闹钟
/// 修改周期时 判断是否需要更新
/// 修改名字时
/// 点击当前提醒时间 可修改或者删除当前时间
/// 当需要更新闹钟时，给出一个提示弹框，告诉可能要删除哪个已存在的闹钟
///
/// 内容增加 图标 颜色主题 字体
///
/// 升级
/// 数据同步 实时增删改查
/// 用户登录 头像 昵称 手机号
/// 付费购买 接入H5支付渠道
///
/// 软著 用户政策 隐私协议
///
/// 云数据存储
/// 提供同步数据接口
/// 登录成功之后 若本地的habit userId不存在，说明是第一次登录，并将本地数据更新 userId字段，同步上传本地数据，之后拉去远端数据，更新本地数据
/// 换账号登录，若本地habit userId与登录userId不一样，删除本地数据，全部从云端拉取，并保存在本地。
///
/// 每次打开APP都会上传同步一次
///
