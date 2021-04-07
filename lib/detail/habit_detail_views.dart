import 'package:flutter/material.dart';
import 'package:timefly/detail/detail_calender_view.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
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
                      habit.period == HabitPeriod.week ? 45 : 35)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(10, 5.0),
                        blurRadius: 16.0)
                  ]),
              margin: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tipView(recordLength),
                  habit.period == HabitPeriod.week ? _weekInfo() : Container()
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
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(10, 5.0),
                    blurRadius: 16.0),
              ]),
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
                style: AppTheme.appTheme
                    .textStyle(
                      textColor: Colors.black,
                      fontSize: 14,
                    )
                    .copyWith(fontFamily: 'Montserrat'),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _weekInfo() {
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
                        style: AppTheme.appTheme.textStyle(
                            textColor: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.w300),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          tip,
          style: AppTheme.appTheme.textStyle(
            textColor: Colors.black,
            fontSize: 14,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Text('${habit.doNum}',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat')),
        SizedBox(
          width: 3,
        ),
        Text('已完成',
            style: AppTheme.appTheme.textStyle(
              textColor: Colors.black,
              fontSize: 14,
            )),
        SizedBox(
          width: 3,
        ),
        Text('$recordLength',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat')),
      ],
    );
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

class HabitMonthInfoViewState extends State<HabitMonthInfoView> {
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
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 17),
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
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(1, 1),
                                    blurRadius: 12.0)
                              ],
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
          style: AppTheme.appTheme.textStyle(
              textColor: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 14));
    }
    int needDoNum;
    if (widget.habit.period == HabitPeriod.day) {
      needDoNum =
          DateTime(month.year, month.month + 1, 0).day * widget.habit.doNum;
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
                          style: AppTheme.appTheme.textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 14),
                          children: [
                            TextSpan(
                                text: '$needDoNum',
                                style: AppTheme.appTheme
                                    .textStyle(
                                        textColor: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)
                                    .copyWith(fontFamily: 'Montserrat')),
                            TextSpan(
                              text: '  次',
                            )
                          ]),
                    ),
              RichText(
                text: TextSpan(
                    text: '已经完成  ',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 14),
                    children: [
                      TextSpan(
                          text: '$checkNum',
                          style: AppTheme.appTheme
                              .textStyle(
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22)
                              .copyWith(fontFamily: 'Montserrat')),
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
              '${DateUtil.getDayString(habit.createTime)} -- ${DateUtil.formDateTime(DateTime.now())}',
              style: AppTheme.appTheme
                  .textStyle(
                      textColor: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)
                  .copyWith(fontFamily: 'Montserrat'),
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
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              blurRadius: 16,
                              offset: Offset(4, 4))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${habit.records.length}',
                          style: AppTheme.appTheme
                              .textStyle(
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28)
                              .copyWith(fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '总记录(次)',
                          style: AppTheme.appTheme.textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
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
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              blurRadius: 16,
                              offset: Offset(4, 4))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${HabitUtil.combinationRecords(habit.records).keys.length}',
                          style: AppTheme.appTheme
                              .textStyle(
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28)
                              .copyWith(fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '总记录(天)',
                          style: AppTheme.appTheme.textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
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

  const HabitStreakInfoView({Key key, this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<HabitRecord>> records =
        HabitUtil.combinationRecords(habit.records);
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Text('${HabitUtil.getHabitStreaks(records)}'),
    );
  }
}
