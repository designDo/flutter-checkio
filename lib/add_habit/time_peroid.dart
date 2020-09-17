import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_theme.dart';

class TimePeroidPage extends StatefulWidget {
  @override
  _TimePeroidPageState createState() => _TimePeroidPageState();
}

class _TimePeroidPageState extends State<TimePeroidPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isEveryDay = true;
  bool isCustom = false;

  AnimationController fontAnimationController;

  List<CompleteDay> completeDays = [];
  List<CompleteTime> completeTimes = [];

  String selectDayString = '每天';
  int completeNun = 7;

  bool isAllUnSelect = false;

  @override
  void initState() {
    completeDays = CompleteDay.getCompleteDays();
    completeTimes = CompleteTime.getCompleteTimes();
    fontAnimationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    fontAnimationController.forward(from: 0.5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 68,
          ),
          Text('将在什么时候开始呢？',
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          SizedBox(
            height: 16,
          ),
          Container(
              margin: EdgeInsets.only(left: 32),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/time.svg',
                    color: Colors.white70,
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '时间',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.only(top: 16),
            height: 50,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 32),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      completeTimes.forEach((element) {
                        element.isSelect = false;
                      });
                      completeTimes[index].isSelect = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 16),
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: completeTimes[index].isSelect
                                ? Colors.white
                                : Colors.transparent,
                            width: 2),
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(0.08)),
                    child: Text(
                      CompleteTime.getTime(completeTimes[index].time),
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                );
              },
              itemCount: completeTimes.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Container(
              margin: EdgeInsets.only(left: 32),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/zhouqi.svg',
                    color: Colors.white70,
                    width: 28,
                    height: 28,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '周期 7 天',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              )),
          SizedBox(
            height: 16,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 50),
            child: Text(
              selectDayString,
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            height: 50,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 32),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      completeDays[index].isSelect =
                          !completeDays[index].isSelect;
                      selectDayString = getSelectDayString();
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 16),
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: completeDays[index].isSelect
                                ? Colors.white
                                : Colors.transparent,
                            width: 2),
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(0.08)),
                    child: Text(
                      CompleteDay.getDay(completeDays[index].day),
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                );
              },
              itemCount: completeDays.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              margin: EdgeInsets.only(left: 32),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/duigou.svg',
                    color: Colors.white70,
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '完成次数',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 55,
                    height: 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: AppTheme.appTheme
                            .gradientColorDark()
                            .withOpacity(0.08)),
                    child: AnimatedBuilder(
                      builder: (context, child) {
                        return Text(
                          '$completeNun',
                          style: AppTheme.appTheme.textStyle(
                              textColor: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20 * fontAnimationController.value),
                        );
                      },
                      animation: CurvedAnimation(
                          parent: fontAnimationController,
                          curve: Curves.elasticInOut),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            completeNun += 1;
                            fontAnimationController.forward(from: 0.5);
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/jia.svg',
                          color: Colors.white,
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (completeNun == 1) {
                            return;
                          }
                          setState(() {
                            completeNun -= 1;
                            fontAnimationController.forward(from: 0.5);
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/jian.svg',
                          color: Colors.white,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  )
                ],
              )),
          SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              if (isAllUnSelect) {
                return;
              }
              print('complete!!!');
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 42),
              alignment: Alignment.center,
              width: 250,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(32)),
                  color: isAllUnSelect
                      ? Theme.of(context).primaryColorDark.withOpacity(0.25)
                      : Colors.white),
              child: Text(
                '完成',
                style: AppTheme.appTheme.textStyle(
                    textColor: !isAllUnSelect
                        ? AppTheme.appTheme.gradientColorDark()
                        : Colors.black.withOpacity(0.2),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  String getSelectDayString() {
    bool isAllSelect = true;
    bool isAllUnSelect = true;
    for (var completeDay in completeDays) {
      if (!completeDay.isSelect) {
        isAllSelect = false;
      }
      if (completeDay.isSelect) {
        isAllUnSelect = false;
      }
    }
    if (isAllSelect) {
      return '每天';
    }
    setState(() {
      this.isAllUnSelect = isAllUnSelect;
    });
    if (isAllUnSelect) {
      return '请选择周期';
    }

    String dayString = '';
    for (var completeDay in completeDays) {
      if (completeDay.isSelect) {
        dayString += CompleteDay.getDay(completeDay.day) + '  ';
      }
    }
    return dayString;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    fontAnimationController.dispose();
    super.dispose();
  }
}

class CompleteTime {
  ///0 任意
  ///1 早上
  ///2 上午
  ///3 中午
  ///4 下午
  ///5 晚上
  final int time;
  bool isSelect = false;

  CompleteTime(this.time, {this.isSelect = false});

  static List<CompleteTime> getCompleteTimes() {
    List<CompleteTime> completeTimes = [];
    for (int i = 0; i <= 5; i++) {
      completeTimes.add(CompleteTime(i, isSelect: i == 0));
    }
    return completeTimes;
  }

  static String getTime(int time) {
    String timeString = '任意';
    switch (time) {
      case 1:
        timeString = '早上';
        break;
      case 2:
        timeString = '上午';
        break;
      case 3:
        timeString = '中午';
        break;
      case 4:
        timeString = '下午';
        break;
      case 5:
        timeString = '晚上';
        break;
    }
    return timeString;
  }
}

class CompleteDay {
  final int day;
  bool isSelect = false;

  CompleteDay(this.day, {this.isSelect = false});

  static List<CompleteDay> getCompleteDays() {
    List<CompleteDay> days = [];
    for (int i = 1; i <= 7; i++) {
      days.add(CompleteDay(i, isSelect: true));
    }

    return days;
  }

  static String getDay(int day) {
    String dayString = '';
    switch (day) {
      case 1:
        dayString = '周一';
        break;
      case 2:
        dayString = '周二';
        break;
      case 3:
        dayString = '周三';
        break;
      case 4:
        dayString = '周四';
        break;
      case 5:
        dayString = '周五';
        break;
      case 6:
        dayString = '周六';
        break;
      case 7:
        dayString = '周日';
        break;
    }
    return dayString;
  }
}
