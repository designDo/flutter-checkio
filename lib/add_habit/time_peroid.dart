import 'package:flutter/material.dart';

import '../app_theme.dart';

class TimePeroidPage extends StatefulWidget {
  @override
  _TimePeroidPageState createState() => _TimePeroidPageState();
}

class _TimePeroidPageState extends State<TimePeroidPage> {
  bool isEveryDay = true;
  bool isCustom = false;

  List<CompleteDay> completeDays = [];
  List<CompleteTime> completeTimes = [];

  @override
  void initState() {
    completeDays = CompleteDay.getCompleteDays();
    completeTimes = CompleteTime.getCompleteTimes();
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
            margin: EdgeInsets.only(top: 16),
            height: 50,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 16),
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
            height: 16,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '每天',
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '每天完成一次',
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 32),
                child: Switch(
                  value: isEveryDay,
                  onChanged: (value) {
                    setState(() {
                      isEveryDay = value;
                      isCustom = !value;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '自定义时间',
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '选择在周一和周三完成\n并且要完成3次',
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 32),
                child: Switch(
                  value: isCustom,
                  onChanged: (value) {
                    setState(() {
                      isCustom = value;
                      isEveryDay = !value;
                    });
                  },
                ),
              ),
            ],
          ),
          !isCustom
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.only(top: 32),
                  height: 50,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 16),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            completeDays[index].isSelect =
                                !completeDays[index].isSelect;
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
                )
        ],
      ),
    );
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
      days.add(CompleteDay(i, isSelect: i == 0));
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
