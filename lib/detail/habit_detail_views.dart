import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timefly/detail/detail_calender_view.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/widget/circle_progress_bar.dart';

import '../app_theme.dart';

class HabitBaseInfoView extends StatelessWidget {
  final AnimationController animationController;
  final Habit habit;

  const HabitBaseInfoView({Key key, this.habit, this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int recordLength =
        HabitUtil.getHabitRecordsWithPeroid(habit.records, habit.period).length;
    int progress = recordLength;
    if (progress > habit.doNum) {
      progress = recordLength;
    }
    return Row(
      children: [
        Expanded(
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animationController,
                    curve: Interval(0, 0.5, curve: Curves.ease))),
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(
                      HabitUtil.containAllDay(habit) ? 35 : 45)),
                  color: AppTheme.appTheme.cardBackgroundColor(),
                  boxShadow: AppTheme.appTheme.containerBoxShadow()),
              margin: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tipView(recordLength),
                  HabitUtil.containAllDay(habit)
                      ? Container()
                      : _completeDaysInfo()
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 16),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.appTheme.cardBackgroundColor(),
              boxShadow: AppTheme.appTheme.containerBoxShadow()),
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleProgressBar(
                  backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
                  foregroundColor: Color(habit.mainColor),
                  value: progress / habit.doNum),
              Text(
                '${((progress / habit.doNum) * 100).toInt()}%',
                style: AppTheme.appTheme.numHeadline1(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _completeDaysInfo() {
    return Container(
      margin: EdgeInsets.only(left: 8),
      child: Row(
        children: List.generate(
            7,
            (index) => Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      Text(
                        '${CompleteDay.getSimpleDay(index + 1)}',
                        style: AppTheme.appTheme.headline2(
                            fontSize: 11, fontWeight: FontWeight.w300),
                      ),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: habit.completeDays.contains(index + 1)
                                ? Color(habit.mainColor)
                                : Colors.transparent,
                            shape: BoxShape.circle),
                      )
                    ],
                  ),
                )),
      ),
    );
  }

  Widget _tipView(int recordLength) {
    String tip = '今天需完成';
    if (habit.period == HabitPeriod.week) {
      tip = '本周需完成';
    } else if (habit.period == HabitPeriod.month) {
      tip = '本月需完成';
    }
    if (habit.period == HabitPeriod.day &&
        !habit.completeDays.contains(DateTime.now().weekday)) {
      return Container(
        width: double.infinity,
        child: Text(
          '今天不在记录周期内',
          style: AppTheme.appTheme.headline1(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          tip,
          style: AppTheme.appTheme.headline1(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Text('${habit.doNum}',
            style: AppTheme.appTheme.numHeadline1(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(
          width: 3,
        ),
        Text('已完成',
            style: AppTheme.appTheme.headline1(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            )),
        SizedBox(
          width: 3,
        ),
        Text('$recordLength',
            style: AppTheme.appTheme.numHeadline1(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }
}

class HabitCompleteRateView extends StatefulWidget {
  final AnimationController animationController;
  final Habit habit;

  const HabitCompleteRateView({Key key, this.habit, this.animationController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HabitCompleteRateViewState();
  }
}

class _HabitCompleteRateViewState extends State<HabitCompleteRateView> {
  ///当前周标示
  ///0 今天，1，昨天
  ///
  int currentDayIndex = 1;

  ///当前周标示
  ///0 当前周，1，上一周
  int currentWeekIndex = 1;

  ///当前月标示 0 当前月 1 上个月
  int currentMonthIndex = 1;

  DateTime _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    int period = widget.habit.period;
    return Row(
      children: [
        Expanded(
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval(0.2, 0.6, curve: Curves.ease))),
            child: Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                  color: AppTheme.appTheme.cardBackgroundColor(),
                  boxShadow: AppTheme.appTheme.containerBoxShadow()),
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _left(period);
                    },
                    child: SvgPicture.asset(
                      'assets/images/navigation_left.svg',
                      color: AppTheme.appTheme.grandientColorEnd(),
                      width: 25,
                      height: 25,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _timeString(period),
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(_dateString(period),
                            style: AppTheme.appTheme.numHeadline1(
                                fontWeight: FontWeight.w300, fontSize: 16))
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        _right(period);
                      },
                      child: SvgPicture.asset(
                        'assets/images/navigation_right.svg',
                        color: ((period == HabitPeriod.day &&
                                    currentDayIndex == 0) ||
                                (period == HabitPeriod.week &&
                                    currentWeekIndex == 0) ||
                                (period == HabitPeriod.month &&
                                    currentMonthIndex == 0))
                            ? AppTheme.appTheme.containerBackgroundColor()
                            : AppTheme.appTheme.grandientColorEnd(),
                        width: 25,
                        height: 25,
                      ))
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 16),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.appTheme.cardBackgroundColor(),
              boxShadow: AppTheme.appTheme.containerBoxShadow()),
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleProgressBar(
                  backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
                  foregroundColor: Color(widget.habit.mainColor),
                  value: _doCount(period) / widget.habit.doNum),
              Text(
                '${((_doCount(period) / widget.habit.doNum) * 100).toInt()}%',
                style: AppTheme.appTheme.numHeadline1(
                  textColor: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  int _doCount(int period) {
    int count = 0;
    switch (period) {
      case HabitPeriod.day:
        DateTime start = DateUtil.getDayPeroid(_now, currentDayIndex);
        count = HabitUtil.getDoCountOfHabit(widget.habit.records, start, start);
        break;
      case HabitPeriod.week:
        Pair<DateTime> weekSAE =
            DateUtil.getWeekStartAndEnd(_now, currentWeekIndex);
        count = HabitUtil.getDoCountOfHabit(
            widget.habit.records, weekSAE.x0, weekSAE.x1);
        break;
      case HabitPeriod.month:
        Pair<DateTime> monthSAE =
            DateUtil.getMonthStartAndEnd(_now, currentMonthIndex);
        count = HabitUtil.getDoCountOfHabit(
            widget.habit.records, monthSAE.x0, monthSAE.x1);
        break;
    }
    return count;
  }

  void _left(int peroid) {
    setState(() {
      switch (peroid) {
        case HabitPeriod.day:
          currentDayIndex += 1;
          break;
        case HabitPeriod.week:
          currentWeekIndex += 1;

          break;
        case HabitPeriod.month:
          currentMonthIndex += 1;
          break;
      }
    });
  }

  void _right(int peroid) {
    if (peroid == HabitPeriod.day) {
      if (currentDayIndex == 0) {
        return;
      }
      setState(() {
        currentDayIndex -= 1;
      });
    } else if (peroid == HabitPeriod.week) {
      if (currentWeekIndex == 0) {
        return;
      }
      setState(() {
        currentWeekIndex -= 1;
      });
    } else {
      if (currentMonthIndex == 0) {
        return;
      }
      setState(() {
        currentMonthIndex -= 1;
      });
    }
  }

  String _timeString(int peroid) {
    String string = '';
    switch (peroid) {
      case HabitPeriod.day:
        string = _dayString();
        break;
      case HabitPeriod.week:
        string = _weekString();
        break;
      case HabitPeriod.month:
        string = _monthString();
        break;
    }
    return string;
  }

  String _dateString(int peroid) {
    String string = '';
    switch (peroid) {
      case HabitPeriod.day:
        string = DateUtil.getDayPeroidDtring(_now, currentDayIndex);
        break;
      case HabitPeriod.week:
        string = DateUtil.getWeekPeriodString(_now, currentWeekIndex);
        break;
      case HabitPeriod.month:
        string = DateUtil.getMonthPeriodString(_now, currentMonthIndex);
        break;
    }
    return string;
  }

  String _dayString() {
    if (currentDayIndex == 0) {
      return '今天';
    }
    if (currentDayIndex == 1) {
      return '昨天';
    }
    if (currentDayIndex == 2) {
      return '前天';
    }
    return '$currentDayIndex天前';
  }

  String _weekString() {
    if (currentWeekIndex == 0) {
      return '本周';
    }
    if (currentWeekIndex == 1) {
      return '上周';
    }
    return '$currentWeekIndex周前';
  }

  String _monthString() {
    if (currentMonthIndex == 0) {
      return '本月';
    }
    if (currentMonthIndex == 1) {
      return '上月';
    }
    return '$currentMonthIndex月前';
  }
}

class HabitMonthInfoView extends StatefulWidget {
  final AnimationController animationController;
  final Habit habit;

  const HabitMonthInfoView({Key key, this.animationController, this.habit})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HabitMonthInfoViewState();
  }
}

class HabitMonthInfoViewState extends State<HabitMonthInfoView>
    with AutomaticKeepAliveClientMixin {
  final double margin = 20;
  final double ratio = 1.5;
  final double calendarPadding = 16;
  PageController pageController;
  List<DateTime> months = DateUtil.getMonthsSince2020();
  int currentIndex;

  @override
  void initState() {
    currentIndex = months.length - 1;
    pageController = PageController(initialPage: months.length - 1);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: widget.animationController,
              curve: Interval(0.5, 1, curve: Curves.ease))),
          child: Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              '${months[currentIndex].year}年${months[currentIndex].month}月',
              style: AppTheme.appTheme
                  .headline1(fontWeight: FontWeight.w300, fontSize: 17),
            ),
          ),
        ),
        SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
              .animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval(0.5, 1, curve: Curves.ease))),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                parent: widget.animationController,
                curve: Interval(0.5, 1, curve: Curves.ease))),
            child: Container(
              margin: EdgeInsets.only(top: 12),
              height: _containerHeight(context),
              child: PageView.builder(
                  controller: pageController,
                  itemCount: months.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    List<DateTime> days = DateUtil.getMonthDays(months[index]);
                    Map<String, List<HabitRecord>> records =
                        HabitUtil.combinationRecordsWithTime(
                            widget.habit.records,
                            months[index],
                            DateTime(months[index].year,
                                months[index].month + 1, 1));
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: _maxCalendarHeight(context) +
                                  28 +
                                  calendarPadding,
                              decoration: BoxDecoration(
                                  color: Color(widget.habit.mainColor)
                                      .withOpacity(0.1314),
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              margin:
                                  EdgeInsets.only(left: margin, right: margin),
                              padding: EdgeInsets.only(top: calendarPadding),
                              child: HabitDetailCalendarView(
                                color: Color(widget.habit.mainColor),
                                createTime: widget.habit.createTime,
                                days: days,
                                habitId: widget.habit.id,
                                records: records,
                                period: widget.habit.period,
                                completeDays: widget.habit.completeDays,
                              ),
                            ),
                            SizedBox()
                          ],
                        ),
                        Positioned(
                          left: days.length > 42
                              ? (days[43] == null ? 80 : 110)
                              : 80,
                          right: 20,
                          top:
                              calendarHeight(context, 42) + calendarPadding + 8,
                          bottom: 20,
                          child: Container(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTheme.appTheme.cardBackgroundColor(),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              boxShadow: AppTheme.appTheme.containerBoxShadow(),
                            ),
                            child:
                                _tipContainer(months[index], checkNum(records)),
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ),
        )
      ],
    );
  }

  int checkNum(Map<String, List<HabitRecord>> records) {
    int num = 0;
    records.forEach((key, record) {
      num += record.length;
    });
    return num;
  }

  double calendarHeight(BuildContext context, int dayLength) {
    return ((MediaQuery.of(context).size.width - margin * 2) / 7) /
            ratio *
            (dayLength / 7) +
        (dayLength / 7 - 1) * 5;
  }

  double _maxCalendarHeight(BuildContext context) {
    return calendarHeight(context, 49);
  }

  double _containerHeight(BuildContext context) {
    return _maxCalendarHeight(context) + 100;
  }

  Widget _tipContainer(DateTime month, int checkNum) {
    DateTime createTime =
        DateTime.fromMillisecondsSinceEpoch(widget.habit.createTime);
    int createTimeMonth =
        DateTime(createTime.year, createTime.month, 1).millisecondsSinceEpoch;
    if (createTimeMonth > month.millisecondsSinceEpoch) {
      return Text('暂无统计数据',
          style: AppTheme.appTheme
              .headline1(fontWeight: FontWeight.w300, fontSize: 14));
    }
    int needDoNum;
    if (widget.habit.period == HabitPeriod.day) {
      int dayNum = DateTime(month.year, month.month + 1, 0).day;
      dayNum = List.generate(
              dayNum, (index) => DateTime(month.year, month.month, index + 1))
          .where((day) => widget.habit.completeDays.contains(day.weekday))
          .length;
      needDoNum = dayNum * widget.habit.doNum;
    } else if (widget.habit.period == HabitPeriod.month) {
      needDoNum = widget.habit.doNum;
    }
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.habit.period == HabitPeriod.week
                  ? SizedBox()
                  : RichText(
                      text: TextSpan(
                          text: '本月需完成  ',
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.w300, fontSize: 14),
                          children: [
                            TextSpan(
                                text: '$needDoNum',
                                style: AppTheme.appTheme.numHeadline1(
                                    fontWeight: FontWeight.bold, fontSize: 22)),
                            TextSpan(
                              text: '  次',
                            )
                          ]),
                    ),
              RichText(
                text: TextSpan(
                    text: '已经完成  ',
                    style: AppTheme.appTheme
                        .headline1(fontWeight: FontWeight.w300, fontSize: 14),
                    children: [
                      TextSpan(
                          text: '$checkNum',
                          style: AppTheme.appTheme.numHeadline1(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                      TextSpan(
                        text: '  次',
                      )
                    ]),
              )
            ],
          ),
        ),
        Container(
          width: 60,
          height: 60,
          child: Icon(Icons.arrow_forward),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HabitCheckInfoView extends StatelessWidget {
  final AnimationController animationController;
  final Habit habit;

  const HabitCheckInfoView({Key key, this.habit, this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: animationController,
              curve: Interval(0.6, 1, curve: Curves.fastOutSlowIn))),
          child: Container(
            margin: EdgeInsets.only(left: 16, bottom: 12, top: 8),
            child: Text(
              '${DateUtil.getDayString(habit.createTime)} - ${DateUtil.formDateTime(DateTime.now())}',
              style: AppTheme.appTheme
                  .numHeadline1(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SlideTransition(
                position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: animationController,
                        curve: Interval(0.6, 1, curve: Curves.fastOutSlowIn))),
                child: AspectRatio(
                  aspectRatio: 1.58,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: AppTheme.appTheme.cardBackgroundColor(),
                        boxShadow: AppTheme.appTheme.containerBoxShadow()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${habit.records.length}',
                          style: AppTheme.appTheme.numHeadline1(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '总记录(次)',
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Expanded(
              child: SlideTransition(
                position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: animationController,
                        curve: Interval(0.6, 1, curve: Curves.fastOutSlowIn))),
                child: AspectRatio(
                  aspectRatio: 1.58,
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        color: AppTheme.appTheme.cardBackgroundColor(),
                        boxShadow: AppTheme.appTheme.containerBoxShadow()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${HabitUtil.combinationRecords(habit.records).keys.length}',
                          style: AppTheme.appTheme.numHeadline1(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '总记录(天)',
                          style: AppTheme.appTheme.headline1(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class HabitStreakInfoView extends StatelessWidget {
  final Habit habit;
  final AnimationController animationController;

  const HabitStreakInfoView({Key key, this.habit, this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<HabitRecord>> records =
        HabitUtil.combinationRecords(habit.records);
    Map<String, int> streaks = HabitUtil.getHabitStreaks(records);
    int maxCount = 0;
    if (streaks.length > 0) {
      maxCount = streaks[streaks.keys.first];
    }
    return SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
            .animate(CurvedAnimation(
                parent: animationController,
                curve: Interval(0.7, 1, curve: Curves.ease))),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: animationController,
              curve: Interval(0.7, 1, curve: Curves.ease))),
          child: Container(
            margin: EdgeInsets.only(top: 16, right: 16, left: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AppTheme.appTheme.cardBackgroundColor(),
                boxShadow: AppTheme.appTheme.containerBoxShadow()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '当前连续',
                      style: AppTheme.appTheme.headline1(
                          fontWeight: FontWeight.normal, fontSize: 14),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      '${HabitUtil.getNowStreaks(records)}',
                      style: AppTheme.appTheme.numHeadline1(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    )
                  ],
                ),
                Text(
                  '历史连续',
                  style: AppTheme.appTheme
                      .headline1(fontWeight: FontWeight.normal, fontSize: 14),
                ),
                streaks.length == 0
                    ? SizedBox()
                    : Column(
                        children: streaks.keys
                            .take(5)
                            .map((e) => _checkInfo(e, streaks[e], maxCount))
                            .toList(),
                      ),
              ],
            ),
          ),
        ));
  }

  Widget _checkInfo(String time, int count, int maxCount) {
    List<String> str = time.split(',');
    return Row(
      children: [
        Container(
          width: 140,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppTheme.appTheme.containerBackgroundColor(),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: count,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(habit.mainColor).withOpacity(0.6),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 10,
                    ),
                  ),
                  Expanded(
                    flex: maxCount - count,
                    child: SizedBox(),
                  )
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: SizedBox(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '$count',
              style: AppTheme.appTheme
                  .numHeadline1(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${str[0].replaceAll('-', '.')} - ${str[1].substring(str[1].indexOf('-') + 1).replaceAll('-', '.')}',
              maxLines: 2,
              style: AppTheme.appTheme
                  .numHeadline1(fontSize: 16, fontWeight: FontWeight.w300),
            )
          ],
        )
      ],
    );
  }
}

class HabitRecentRecordsView extends StatelessWidget {
  final Habit habit;

  const HabitRecentRecordsView({Key key, this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 28, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children(habit),
      ),
    );
  }

  List<Widget> _children(Habit habit) {
    List<Widget> children = [];
    children.add(_titleView());
    if (habit.records != null && habit.records.length > 0) {
      children.addAll(habit.records.take(5).map((e) => _recordView(e)));
    } else {
      children.add(Container(
        margin: EdgeInsets.all(16),
        child: Text('暂无记录...',
            style: AppTheme.appTheme
                .headline1(fontWeight: FontWeight.normal, fontSize: 14)),
      ));
    }
    return children;
  }

  Widget _titleView() {
    return Row(
      children: [
        Text('最近记录',
            style: AppTheme.appTheme
                .headline1(fontWeight: FontWeight.bold, fontSize: 16)),
        Expanded(
          child: SizedBox(),
        ),
        GestureDetector(
          onTap: () {
            print('show all');
          },
          child: Row(
            children: [
              Text('查看全部',
                  style: AppTheme.appTheme.textStyle(
                      textColor: AppTheme.appTheme.normalColor(),
                      fontWeight: FontWeight.normal,
                      fontSize: 14)),
              Icon(
                Icons.arrow_forward,
                color: AppTheme.appTheme.normalColor(),
                size: 23,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _recordView(HabitRecord record) {
    return Container(
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: AppTheme.appTheme.cardBackgroundColor(),
            boxShadow: AppTheme.appTheme.containerBoxShadow()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                '${DateUtil.parseHourAndMinAndSecond(record.time)}',
                style: AppTheme.appTheme
                    .numHeadline1(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 24),
              child: Text(
                '${DateUtil.parseYearAndMonthAndDay(record.time)}',
                style: AppTheme.appTheme
                    .numHeadline2(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: AppTheme.appTheme.containerBackgroundColor()),
              alignment: Alignment.topLeft,
              width: double.infinity,
              constraints: BoxConstraints(minHeight: 60),
              child: Text(
                '${record.content.length == 0 ? '' : record.content}',
                style: record.content.length == 0
                    ? AppTheme.appTheme
                        .headline2(fontSize: 16, fontWeight: FontWeight.w500)
                    : AppTheme.appTheme
                        .headline1(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
