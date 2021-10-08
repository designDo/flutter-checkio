import 'dart:math';
import 'package:alarm_plugin/alarm_event.dart';
import 'package:alarm_plugin/alarm_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/add_habit/icon_color.dart';
import 'package:timefly/add_habit/modify_change_dialog.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_color.dart';
import 'package:timefly/models/habit_icon.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/utils/list_utils.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/utils/uuid.dart';
import 'package:timefly/widget/custom_edit_field.dart';

class HabitEditPage extends StatefulWidget {
  final Habit habit;

  ///修改，在保存时为 update
  final bool isModify;

  const HabitEditPage({Key key, this.habit, this.isModify}) : super(key: key);

  @override
  _HabitEditPageState createState() => _HabitEditPageState();
}

class _HabitEditPageState extends State<HabitEditPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  ///修改之前的原始数据，在编辑条件下，保存时对比，判断是否需要更新闹钟提醒
  Habit originHabit;
  String _habitIcon;
  Color _habitColor;

  List<CompleteTime> completeTimes = [];
  List<CompleteDay> weekCompleteDays = [];
  List<CompleteDay> dayCompleteDays = [];
  List<CompleteDay> monthCompleteDays = CompleteDay.getCompleteDays();
  List<HabitPeriod> habitPeriods = [];
  int currentPeriod = HabitPeriod.day;

  String _name = '';
  String _mark = '';

  List<DateTime> originRemindTimes = [];
  List<DateTime> remindTimes = [];

  int countByDay = 1;
  int countByWeek = 7;
  int countByMonth = 15;

  AnimationController fontAnimationController;
  AnimationController bottomAnimationController;

  @override
  void initState() {
    print(widget.habit);
    if (widget.isModify) {
      originHabit = widget.habit.copyWith();
      _name = widget.habit.name;
      _mark = widget.habit.mark;
      if (widget.habit.period == HabitPeriod.day) {
        countByDay = widget.habit.doNum;
      }
      if (widget.habit.period == HabitPeriod.week) {
        countByWeek = widget.habit.doNum;
      }
      if (widget.habit.period == HabitPeriod.month) {
        countByMonth = widget.habit.doNum;
      }
      if (widget.habit.remindTimes != null &&
          widget.habit.remindTimes.length > 0) {
        remindTimes = widget.habit.remindTimes
            .map((e) => DateUtil.parseHourAndMinWithString(e))
            .toList();
        remindTimes.sort(
            (a, b) => a.millisecondsSinceEpoch - b.millisecondsSinceEpoch);
        originRemindTimes = List<DateTime>.from(remindTimes).toList();
      }
    }

    List<HabitIcon> icons = HabitIcon.getIcons();
    if (widget.isModify) {
      _habitIcon = widget.habit.iconPath;
    } else {
      _habitIcon = icons[Random().nextInt(icons.length - 1)].icon;
    }

    List<HabitColor> colors = HabitColor.getBackgroundColors();
    if (widget.isModify) {
      _habitColor = Color(widget.habit.mainColor);
    } else {
      _habitColor = colors[Random().nextInt(colors.length - 1)].color;
    }

    completeTimes = CompleteTime.getCompleteTimes(
        widget.isModify ? widget.habit.completeTime : 0);

    weekCompleteDays = CompleteDay.getCompleteDays();
    if (widget.isModify && widget.habit.period == HabitPeriod.week) {
      for (int i = 0; i < weekCompleteDays.length; i++) {
        weekCompleteDays[i].isSelect =
            widget.habit.completeDays.contains(weekCompleteDays[i].day);
      }
    }

    dayCompleteDays = CompleteDay.getCompleteDays();
    if (widget.isModify && widget.habit.period == HabitPeriod.day) {
      for (int i = 0; i < dayCompleteDays.length; i++) {
        dayCompleteDays[i].isSelect =
            widget.habit.completeDays.contains(dayCompleteDays[i].day);
      }
    }

    habitPeriods =
        HabitPeriod.getHabitPeriods(widget.isModify ? widget.habit.period : 0);
    if (widget.isModify) {
      currentPeriod = widget.habit.period;
    }

    fontAnimationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    fontAnimationController.forward(from: 0.5);

    bottomAnimationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration(milliseconds: 500), () {
      bottomAnimationController.forward();
    });

    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        bool keyboardShow = MediaQuery.of(context).viewInsets.bottom > 0;
        if (keyboardShow) {
          bottomAnimationController.reverse();
        } else {
          bottomAnimationController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    fontAnimationController.dispose();
    bottomAnimationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.cardBackgroundColor(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              barView(),
              Expanded(
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 20),
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 16),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: _habitColor.withOpacity(0.1),
                                    offset: Offset(3, 2),
                                    blurRadius: 16)
                              ], shape: BoxShape.circle, color: _habitColor),
                              width: 60,
                              height: 60,
                              child: Image.asset(_habitIcon),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              height: 60,
                              width: 30,
                              child: InkWell(
                                onTap: () async {
                                  Map<String, dynamic> result =
                                      await showDialog(
                                          context: context,
                                          barrierColor: Colors.black87,
                                          builder: (context) {
                                            return IconAndColorPage(
                                                selectedIcon: _habitIcon,
                                                selectedColor: _habitColor);
                                          });
                                  if (result != null) {
                                    setState(() {
                                      _habitIcon = result['icon'];
                                      _habitColor = result['color'];
                                    });
                                  }
                                },
                                child: SvgPicture.asset(
                                  'assets/images/bianji.svg',
                                  color: AppTheme.appTheme.normalColor(),
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomEditField(
                        maxLines: 1,
                        maxLength: 10,
                        initValue: _name,
                        hintText: '名字 ...',
                        hintTextStyle: AppTheme.appTheme
                            .hint(fontWeight: FontWeight.bold, fontSize: 18),
                        textStyle: AppTheme.appTheme.headline1(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        containerDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppTheme.appTheme
                                .containerBackgroundColor()
                                .withOpacity(0.6)),
                        numDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppTheme.appTheme.cardBackgroundColor(),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: AppTheme.appTheme.containerBoxShadow()),
                        numTextStyle: AppTheme.appTheme.themeText(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        onValueChanged: (value) {
                          _name = value;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 18, top: 8),
                        child: Text(
                          '时段',
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      timeView(),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 18),
                        child: Text(
                          '周期',
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      periodChooseView(),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 18),
                        child: Text(
                          '每${HabitPeriod.getPeriod(currentPeriod)}完成次数',
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      completeCountView(),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 18, top: 8),
                        child: Text(
                          '提醒时间',
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      timeReminderView(),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 18, top: 16),
                        child: Text(
                          '写一句话鼓励自己',
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                      CustomEditField(
                        maxLength: 50,
                        initValue: _mark,
                        hintText: '千里之行，始于足下 ...',
                        hintTextStyle: AppTheme.appTheme
                            .hint(fontWeight: FontWeight.normal, fontSize: 16),
                        textStyle: AppTheme.appTheme.headline1(
                            fontWeight: FontWeight.normal, fontSize: 16),
                        minHeight: 100,
                        containerDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppTheme.appTheme
                                .containerBackgroundColor()
                                .withOpacity(0.6)),
                        numDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppTheme.appTheme.cardBackgroundColor(),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: AppTheme.appTheme.containerBoxShadow()),
                        numTextStyle: AppTheme.appTheme.themeText(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        onValueChanged: (value) {
                          _mark = value;
                        },
                      ),
                      SizedBox(
                        height: 82,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              if (_name.length == 0) {
                FlashHelper.toast(context, '请输入名字');
                return;
              }
              if (_completeDays().isEmpty) {
                FlashHelper.toast(context, '请选择周期');
                return;
              }
              if (widget.isModify) {
                Habit newHabit = widget.habit.copyWith(
                  name: _name,
                  iconPath: _habitIcon,
                  mainColor: _habitColor.value,
                  mark: _mark,
                  period: currentPeriod,
                  doNum: getCurrentCount(),
                  completeTime: completeTimes
                      .where((element) => element.isSelect)
                      .first
                      .time,
                  completeDays: _completeDays(),
                  remindTimes: remindTimes
                      .map((e) =>
                          '${_twoDigits(e.hour)}:${_twoDigits(e.minute)}')
                      .toList(),
                  modifyTime: DateTime.now().millisecondsSinceEpoch,
                  completed: false,
                );
                Pair2<List<String>, List<DateTime>> tipReminders =
                    _updateHabit(newHabit);

                if (tipReminders != null) {
                  if (tipReminders.s != null) {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return ModifyChangeDialog(
                            title: tipReminders.s[0],
                            subTitle: tipReminders.s[1],
                          );
                        });
                  }
                  await createAlarmEvents(tipReminders.t, newHabit.name);
                }
                BlocProvider.of<HabitsBloc>(context).add(HabitUpdate(newHabit));
                await FlashHelper.toast(context, '保存成功');
                Navigator.of(context).pop();
                return;
              }

              Habit habit = Habit(
                  id: Uuid().generateV4(),
                  name: _name,
                  iconPath: _habitIcon,
                  mainColor: _habitColor.value,
                  mark: _mark,
                  period: currentPeriod,
                  doNum: getCurrentCount(),
                  completeTime: completeTimes
                      .where((element) => element.isSelect)
                      .first
                      .time,
                  completeDays: _completeDays(),
                  remindTimes: remindTimes
                      .map((e) =>
                          '${_twoDigits(e.hour)}:${_twoDigits(e.minute)}')
                      .toList(),
                  createTime: DateTime.now().millisecondsSinceEpoch,
                  completed: false,
                  records: []);
              await createAlarmEvents(remindTimes, habit.name);
              BlocProvider.of<HabitsBloc>(context).add(HabitsAdd(habit));
              FlashHelper.toast(context, '保存成功');
              Future.delayed(Duration(milliseconds: 2000),
                  () => Navigator.of(context).pop());
            },
            child: ScaleTransition(
              scale: CurvedAnimation(
                  parent: bottomAnimationController,
                  curve: Curves.fastOutSlowIn),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 32),
                height: 55,
                width: 220,
                decoration: BoxDecoration(
                    boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                    gradient: AppTheme.appTheme.containerGradient(),
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: Text(
                  '保存',
                  style: AppTheme.appTheme.headline1(
                      textColor: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Pair2<List<String>, List<DateTime>> _updateHabit(Habit newHabit) {
    if (originHabit.name != newHabit.name) {
      print('名字不同,新建全部提醒');
      return Pair2(
          ['您修改了名字', '您可能需要手动删除名字为${originHabit.name}的闹钟'], remindTimes);
    }

    ///_completeDays() 和 origin 对比
    if (!ListUtils.equals(_completeDays(), originHabit.completeDays)) {
      print('周期不同,新建全部提醒');
      return Pair2(['您修改了周期', '您可能需要手动删除周期为${originHabit.completeDays}的闹钟'],
          remindTimes);
    }

    if (remindTimes.length == 0 && originRemindTimes.length > 0) {
      return Pair2(
          ['您删除了提醒时间', '您可能需要手动删除名字为${originHabit.name}的闹钟'], remindTimes);
    }

    ///只是添加或修改了提醒时间
    ///对比 originRemindTimes and remindTimes
    List<DateTime> newRemindTimes = [];
    for (var remindTime in remindTimes) {
      if (ListUtils.containsRemindTime(originRemindTimes, remindTime)) {
        originRemindTimes.removeWhere((element) =>
            element.hour == remindTime.hour &&
            element.minute == remindTime.minute);
      } else {
        newRemindTimes.add(remindTime);
      }
    }
    if (newRemindTimes.length == 0) {
      print('没有要添加的提醒');
      return Pair2(null, remindTimes);
    }
    if (newRemindTimes.length > 0) {
      print('添加新提醒时间');
      print(newRemindTimes);

      String tips = '新的提醒将会添加到闹钟';
      if (originRemindTimes.length > 0) {
        print('提醒将被删除');
        print(originRemindTimes);
        tips += '\n您可能需要手动删除时间为${originHabit.remindTimes}的闹钟';
      }
      return Pair2(['您更新了提醒时间', tips], remindTimes);
    }
    return null;
  }

  createAlarmEvents(List<DateTime> remindTimes, String name) async {
    if (remindTimes == null || remindTimes.length == 0) {
      return;
    }
    List<AlarmEvent> events = remindTimes.map((remindTime) {
      AlarmEvent event = AlarmEvent();
      event.title = _name;
      event.description = _name;
      event.hour = remindTime.hour;
      event.minutes = remindTime.minute;
      event.days = _completeDays();
      return event;
    }).toList();
    for (var value in events) {
      await AlarmPlugin.add2Alarm(value);
    }
  }

  List<int> _completeDays() {
    if (currentPeriod == HabitPeriod.day) {
      return dayCompleteDays
          .where((element) => element.isSelect)
          .map((e) => e.day)
          .toList();
    } else if (currentPeriod == HabitPeriod.week) {
      return weekCompleteDays
          .where((element) => element.isSelect)
          .map((e) => e.day)
          .toList();
    }
    return monthCompleteDays.map((e) => e.day).toList();
  }

  Widget barView() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.appTheme.cardBackgroundColor(),
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: 60 + MediaQuery.of(context).padding.top,
      child: Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset(
                'assets/images/fanhui.svg',
                color: AppTheme.appTheme.normalColor(),
                width: 30,
                height: 30,
              ),
            ),
          )),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '${widget.isModify ? '编辑习惯' : '新建习惯'}',
                style: AppTheme.appTheme
                    .headline1(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget timeView() {
    return Container(
      margin: EdgeInsets.only(top: 6),
      height: 48,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        itemBuilder: (context, index) {
          CompleteTime completeTime = completeTimes[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                completeTimes.forEach((element) {
                  element.isSelect = false;
                });
                completeTime.isSelect = true;
              });
            },
            child: AnimatedContainer(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 16),
              width: 68,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: AppTheme.appTheme.grandientColorEnd(), width: 1.5),
                  color: completeTime.isSelect
                      ? AppTheme.appTheme.grandientColorEnd()
                      : AppTheme.appTheme.cardBackgroundColor()),
              child: Text(
                CompleteTime.getTime(completeTime.time),
                style: AppTheme.appTheme.headline1(
                    textColor: completeTime.isSelect
                        ? AppTheme.appTheme.cardBackgroundColor()
                        : AppTheme.appTheme.grandientColorEnd(),
                    fontWeight: FontWeight.normal,
                    fontSize: 15),
              ),
              duration: Duration(milliseconds: 300),
            ),
          );
        },
        itemCount: completeTimes.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget periodChooseView() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 6),
          height: 48,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
            itemBuilder: (context, index) {
              HabitPeriod habitPeroid = habitPeriods[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    habitPeriods.forEach((element) {
                      element.isSelect = false;
                    });
                    habitPeroid.isSelect = true;
                    currentPeriod = habitPeroid.period;
                  });
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 16),
                  width: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    border: Border.all(
                        color: AppTheme.appTheme.grandientColorEnd(),
                        width: 1.5),
                    color: habitPeroid.isSelect
                        ? AppTheme.appTheme.grandientColorEnd()
                        : AppTheme.appTheme.cardBackgroundColor(),
                  ),
                  child: Text(
                    HabitPeriod.getPeriod(habitPeroid.period),
                    style: AppTheme.appTheme.headline1(
                        textColor: habitPeroid.isSelect
                            ? AppTheme.appTheme.cardBackgroundColor()
                            : AppTheme.appTheme.grandientColorEnd(),
                        fontWeight: FontWeight.normal,
                        fontSize: 15),
                  ),
                  duration: Duration(milliseconds: 300),
                ),
              );
            },
            itemCount: habitPeriods.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
        currentPeriod == HabitPeriod.month
            ? SizedBox()
            : _chooseCompleteDysView(currentPeriod == HabitPeriod.day
                ? dayCompleteDays
                : weekCompleteDays)
      ],
    );
  }

  Widget _chooseCompleteDysView(List<CompleteDay> completeDays) {
    return Container(
      height: 58,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        itemBuilder: (context, index) {
          CompleteDay completeDay = completeDays[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                completeDay.isSelect = !completeDay.isSelect;
              });
            },
            child: AnimatedContainer(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 16),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppTheme.appTheme.grandientColorEnd(), width: 1.5),
                  color: completeDay.isSelect
                      ? AppTheme.appTheme.grandientColorEnd()
                      : AppTheme.appTheme.cardBackgroundColor()),
              child: Text(
                CompleteDay.getDay(completeDay.day),
                style: AppTheme.appTheme.headline1(
                    textColor: completeDay.isSelect
                        ? AppTheme.appTheme.cardBackgroundColor()
                        : AppTheme.appTheme.grandientColorEnd(),
                    fontWeight: FontWeight.normal,
                    fontSize: 13),
              ),
              duration: Duration(milliseconds: 300),
            ),
          );
        },
        itemCount: completeDays.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  int getCurrentCount() {
    int count = 0;
    switch (currentPeriod) {
      case 0:
        count = countByDay;
        break;
      case 1:
        count = countByWeek;
        break;
      case 2:
        count = countByMonth;
        break;
    }
    return count;
  }

  void setCurrentCount(int count) {
    switch (currentPeriod) {
      case 0:
        countByDay = count;
        break;
      case 1:
        countByWeek = count;
        break;
      case 2:
        countByMonth = count;
        break;
    }
  }

  Widget completeCountView() {
    return Container(
      margin: EdgeInsets.only(left: 32, top: 8),
      height: 44,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (getCurrentCount() == 1) {
                return;
              }
              setState(() {
                setCurrentCount(getCurrentCount() - 1);
                fontAnimationController.forward(from: 0.5);
              });
            },
            child: SvgPicture.asset(
              'assets/images/jian.svg',
              color: AppTheme.appTheme.normalColor(),
              width: 32,
              height: 32,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 8, right: 8),
            width: 44,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                shape: BoxShape.rectangle,
                color: AppTheme.appTheme.grandientColorEnd()),
            child: AnimatedBuilder(
              builder: (context, child) {
                return Text(
                  '${getCurrentCount()}',
                  style: AppTheme.appTheme.numHeadline1(
                      textColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20 * fontAnimationController.value),
                );
              },
              animation: CurvedAnimation(
                  parent: fontAnimationController, curve: Curves.elasticInOut),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                setCurrentCount(getCurrentCount() + 1);
                fontAnimationController.forward(from: 0.5);
              });
            },
            child: SvgPicture.asset(
              'assets/images/jia.svg',
              color: AppTheme.appTheme.normalColor(),
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget timeReminderView() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      height: 40,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          if (index <= remindTimes.length - 1) {
            DateTime remindTime = remindTimes[index];
            return GestureDetector(
              onTap: () async {
                DateTime dateTime = await _showDatePicker(context, remindTime);
                if (dateTime == null) {
                  ///delete
                  setState(() {
                    remindTimes.remove(remindTime);
                  });
                } else {
                  setState(() {
                    _updateDateTime(dateTime, index);
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 16),
                width: 68,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: AppTheme.appTheme.grandientColorEnd()),
                child: Text(
                  '${_twoDigits(remindTime.hour)}:${_twoDigits(remindTime.minute)}',
                  style: AppTheme.appTheme.headline1(
                      textColor: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () async {
                DateTime dateTime =
                    await _showDatePicker(context, DateTime.now());
                if (dateTime == null) {
                  return;
                }
                setState(() {
                  _addDateTime(dateTime);
                });
              },
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    'assets/images/jia.svg',
                    color: AppTheme.appTheme.normalColor(),
                    width: 32,
                    height: 32,
                  )),
            );
          }
        },
        scrollDirection: Axis.horizontal,
        itemCount: remindTimes.length + 1,
      ),
    );
  }

  void _addDateTime(DateTime dateTime) {
    bool containsDate = false;
    for (var value in remindTimes) {
      if (value.hour == dateTime.hour && value.minute == dateTime.minute) {
        containsDate = true;
        break;
      }
    }
    if (!containsDate) {
      remindTimes.add(dateTime);
      remindTimes
          .sort((a, b) => a.millisecondsSinceEpoch - b.millisecondsSinceEpoch);
    }
  }

  void _updateDateTime(DateTime dateTime, int index) {
    bool containsDate = false;
    for (var value in remindTimes) {
      if (value.hour == dateTime.hour && value.minute == dateTime.minute) {
        containsDate = true;
        break;
      }
    }
    if (containsDate) {
      return;
    }
    remindTimes[index] = dateTime;
    remindTimes
        .sort((a, b) => a.millisecondsSinceEpoch - b.millisecondsSinceEpoch);
  }

  Future<DateTime> _showDatePicker(
      BuildContext context, DateTime initDateTime) async {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          DateTime currentTime = DateTime.now();
          return Container(
              decoration: BoxDecoration(
                  gradient: AppTheme.appTheme.containerGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              height: 318,
              child: Column(
                children: [
                  Container(
                    height: 230,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: AppTheme.appTheme
                                  .numHeadline1(
                                      textColor: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18))),
                      child: CupertinoDatePicker(
                        initialDateTime: initDateTime,
                        mode: CupertinoDatePickerMode.time,
                        onDateTimeChanged: (time) {
                          currentTime = time;
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 32),
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(currentTime);
                      },
                      child: SvgPicture.asset(
                        'assets/images/duigou.svg',
                        width: 35,
                        height: 35,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}
