import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/uuid.dart';

import '../app_theme.dart';

class TimePeroidPage extends StatefulWidget {
  final Function onComplete;
  final Habit habit;

  const TimePeroidPage({Key key, this.habit, this.onComplete}) : super(key: key);

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
            child: Text(
              '时间',
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            height: 80,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 32, right: 32),
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
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
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
                            .withOpacity(0.2)),
                    child: Text(
                      CompleteTime.getTime(completeTimes[index].time),
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ),
                );
              },
              itemCount: completeTimes.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 32, top: 16),
            child: Text(
              'Reminder',
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: timeReminderView(),
          ),
          Expanded(
            child: SizedBox(),
          ),
          GestureDetector(
            onTap: () async {
              if (timeOfDay != null) {
                widget.habit.remindTimes = [
                  '${timeOfDay.hour}:${timeOfDay.minute}'
                ];
              }
              widget.habit.id = Uuid().generateV4();
              widget.habit.completed = false;
              widget.habit.createTime = DateTime.now().millisecondsSinceEpoch;
              await DatabaseProvider.db.insert(widget.habit);
              widget.onComplete();
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

  TimeOfDay timeOfDay;

  Widget timeReminderView() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 55, top: 16),
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: () async {
          TimeOfDay result = await showTimePicker(
              context: context,
              initialTime: timeOfDay == null ? TimeOfDay.now() : timeOfDay,
              cancelText: '取消',
              confirmText: '确定',
              helpText: '选择时间');
          setState(() {
            timeOfDay = result;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).primaryColorDark.withOpacity(0.08)),
          width: 60,
          height: 60,
          child: timeOfDay == null
              ? SvgPicture.asset(
                  'assets/images/jia.svg',
                  color: Colors.white,
                  width: 30,
                  height: 30,
                )
              : Text(
                  '${timeOfDay.hour}:${timeOfDay.minute}',
                  style: AppTheme.appTheme.textStyle(
                      textColor: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
        ),
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
/**
 *  Container(
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
 */
