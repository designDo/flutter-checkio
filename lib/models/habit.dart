import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  ///唯一id
  final String id;

  ///喝水
  final String name;

  ///图标资源路径
  final String iconPath;

  ///卡片主颜色
  final int mainColor;

  ///备注
  final String mark;

  ///提醒时间 每天 10: 20，eg
  ///转化为List<String> json
  final String remindTimes;

  ///周期 1 天 2 天
  final int period;

  ///创建时间
  final int createTime;

  ///修改时间
  final int modifyTime;

  ///是否完成
  final bool completed;

  ///次数
  final int doNum;

  ///日志
  ///转化为List<Record> json
  final String records;

  Habit(
      this.id,
      this.name,
      this.iconPath,
      this.mainColor,
      this.mark,
      this.remindTimes,
      this.period,
      this.createTime,
      this.modifyTime,
      this.completed,
      this.doNum,
      this.records);

  @override
  List<Object> get props => null;
}

class Record {
  ///时间
  final int time;

  ///内容
  final String content;

  Record(this.time, this.content);
}
