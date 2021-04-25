import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/detail/habit_detail_page.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/widget/calendar_view.dart';

class AllHabitItemView extends StatefulWidget {
  static double nominalHeightClosed = 85;
  static double nominalHeightOpen = 287;
  final Habit habit;

  final Function(Habit) onTap;
  final bool isOpen;

  const AllHabitItemView({Key key, this.habit, this.onTap, this.isOpen})
      : super(key: key);

  @override
  _AllHabitItemViewState createState() => _AllHabitItemViewState();
}

class _AllHabitItemViewState extends State<AllHabitItemView> {
  bool _wasOpen;

  double ratio = 1.8;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen != _wasOpen) {
      _wasOpen = widget.isOpen;
    }
    double calendarHeight = ((MediaQuery.of(context).size.width - 48) / 7) /
            ratio *
            (DateUtil.getThisMonthDaysNum() / 7) +
        (DateUtil.getThisMonthDaysNum() / 7 - 1) * 5;
    double cardHeight = widget.isOpen
        ? AllHabitItemView.nominalHeightClosed + calendarHeight + 12
        : AllHabitItemView.nominalHeightClosed;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        margin: EdgeInsets.only(left: 18, right: 18),
        decoration: BoxDecoration(
            boxShadow: AppTheme.appTheme.containerBoxShadow(),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: _wasOpen ? Radius.circular(15) : Radius.circular(50),
                topRight: Radius.circular(15),
                bottomLeft:
                    _wasOpen ? Radius.circular(15) : Radius.circular(50),
                bottomRight: Radius.circular(15)),
            color: AppTheme.appTheme.cardBackgroundColor()),
        height: cardHeight,
        curve: !_wasOpen ? ElasticOutCurve(1) : Curves.elasticOut,
        duration: Duration(milliseconds: !_wasOpen ? 1200 : 1500),
        child: Padding(
          padding: EdgeInsets.only(left: 6, right: 6),
          child: Container(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTopContent(),
                  AnimatedOpacity(
                    duration:
                        Duration(milliseconds: widget.isOpen ? 1000 : 500),
                    opacity: widget.isOpen ? 1 : 0,
                    curve: Curves.easeOut,
                    child: CalendarView(
                      currentDay: DateTime.now(),
                      caculatorHeight: () {
                        return calendarHeight;
                      },
                      habit: widget.habit,
                      records:
                          HabitUtil.combinationRecords(widget.habit.records),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTopContent() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 85,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(left: 6),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color:
                                Color(widget.habit.mainColor).withOpacity(0.3),
                            offset: Offset(0, 3),
                            blurRadius: 6)
                      ],
                      shape: BoxShape.circle,
                      color: Color(widget.habit.mainColor).withOpacity(0.5)),
                  width: 60,
                  height: 60,
                  child: Image.asset(widget.habit.iconPath),
                ),
                onTap: () async {
                  await Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (context) {
                    return HabitDetailPage(
                      habitId: widget.habit.id,
                    );
                  }));
                },
              ),
              Container(
                alignment: Alignment.center,
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Color(widget.habit.mainColor)),
                child: Text(
                  '${HabitPeriod.getPeriod(widget.habit.period)}',
                  style: AppTheme.appTheme.numHeadline1(
                      fontSize: 11,
                      textColor: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          HabitUtil.containAllDay(widget.habit)
              ? normalContent()
              : specialContent()
        ],
      ),
    );
  }

  Widget normalContent() {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(widget.habit.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.appTheme
                    .headline1(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text('记录',
                      style: AppTheme.appTheme.headline2(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 3,
                  ),
                  Text('${HabitUtil.getMonthDoNums(widget.habit.records)}',
                      style: AppTheme.appTheme.numHeadline1(
                          fontSize: 22, fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 3,
                  ),
                  Text('次',
                      style: AppTheme.appTheme.headline2(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text('连续',
                      style: AppTheme.appTheme.headline2(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                      '${HabitUtil.getNowStreaks(HabitUtil.combinationRecords(widget.habit.records))}',
                      style: AppTheme.appTheme.numHeadline1(
                          fontSize: 22, fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 3,
                  ),
                  Text('天',
                      style: AppTheme.appTheme
                          .headline2(fontSize: 14, fontWeight: FontWeight.w600))
                ],
              ),
            ],
          ),
          SizedBox(
            width: 18,
          )
        ],
      ),
    );
  }

  ///completeDays不全
  Widget specialContent() {
    return Expanded(
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 16,
            ),
            Text(widget.habit.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.appTheme
                    .headline1(fontSize: 18, fontWeight: FontWeight.w600)),
            Expanded(
              child: SizedBox(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 66,
                  height: 20,
                  child: ListView.builder(
                      itemCount: 7,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              color:
                                  widget.habit.completeDays.contains(index + 1)
                                      ? Color(widget.habit.mainColor)
                                      : AppTheme.appTheme.cardBackgroundColor(),
                              shape: BoxShape.rectangle,
                              border:
                                  widget.habit.completeDays.contains(index + 1)
                                      ? null
                                      : Border.all(
                                          color: Color(widget.habit.mainColor)
                                              .withOpacity(0.5),
                                          width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          margin: EdgeInsets.only(
                              left: index == 0 ? 0 : 2,
                              right: index == 6 ? 0 : 2),
                          width: 6,
                          height: 20,
                        );
                      }),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text('记录',
                        style: AppTheme.appTheme.headline2(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 3,
                    ),
                    Text('${HabitUtil.getMonthDoNums(widget.habit.records)}',
                        style: AppTheme.appTheme.numHeadline1(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 3,
                    ),
                    Text('次',
                        style: AppTheme.appTheme.headline2(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 18,
            )
          ],
        ),
      ),
    );
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap(widget.habit);
    }
  }
}
