import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/widget/calendar_view.dart';

class AllHabitItemView extends StatefulWidget {
  static double nominalHeightClosed = 100;
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

  Map<String, List<HabitRecord>> records;

  @override
  void initState() {
    records = HabitUtil.combinationRecords(widget.habit.records);
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
        margin: EdgeInsets.only(left: 24, right: 24),
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(10, 5.0),
                  blurRadius: 16.0),
            ],
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
                      records: records,
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
      height: 100,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                margin: EdgeInsets.only(left: 16),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(widget.habit.mainColor).withOpacity(0.3),
                          offset: Offset(0, 7),
                          blurRadius: 10)
                    ],
                    shape: BoxShape.circle,
                    color: Color(widget.habit.mainColor).withOpacity(0.5)),
                width: 60,
                height: 60,
                child: Image.asset(widget.habit.iconPath),
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
                  '${HabitPeroid.getPeroid(widget.habit.period)}',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          widget.habit.period == 1 ? weekContent() : normalContent()
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
                style: AppTheme.appTheme.textStyle(
                    textColor: AppTheme.appTheme.textColorMain(),
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('记录',
                      style: AppTheme.appTheme.textStyle(
                          textColor: AppTheme.appTheme.textColorSecond(),
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 3,
                  ),
                  Text('${HabitUtil.getMonthDoNums(widget.habit.records)}',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: AppTheme.appTheme.textColorMain(),
                              fontSize: 26,
                              fontWeight: FontWeight.w600)
                          .copyWith(fontFamily: 'Montserrat')),
                  SizedBox(
                    width: 3,
                  ),
                  Text('次',
                      style: AppTheme.appTheme.textStyle(
                          textColor: AppTheme.appTheme.textColorSecond(),
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text('连续',
                      style: AppTheme.appTheme.textStyle(
                          textColor: AppTheme.appTheme.textColorSecond(),
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  SizedBox(
                    width: 3,
                  ),
                  Text('${HabitUtil.getNowStreaks(records)}',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: AppTheme.appTheme.textColorMain(),
                              fontSize: 26,
                              fontWeight: FontWeight.w600)
                          .copyWith(fontFamily: 'Montserrat')),
                  SizedBox(
                    width: 3,
                  ),
                  Text('天',
                      style: AppTheme.appTheme.textStyle(
                          textColor: AppTheme.appTheme.textColorSecond(),
                          fontSize: 16,
                          fontWeight: FontWeight.w600))
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

  Widget weekContent() {
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
                style: AppTheme.appTheme.textStyle(
                    textColor: AppTheme.appTheme.textColorMain(),
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
            Expanded(
              child: SizedBox(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 118,
                  height: 40,
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
                                      : Colors.white,
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
                              left: index == 0 ? 0 : 4,
                              right: index == 6 ? 0 : 4),
                          width: 10,
                          height: 40,
                        );
                      }),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('记录',
                        style: AppTheme.appTheme.textStyle(
                            textColor: AppTheme.appTheme.textColorSecond(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 3,
                    ),
                    Text('${HabitUtil.getMonthDoNums(widget.habit.records)}',
                        style: AppTheme.appTheme
                            .textStyle(
                                textColor: AppTheme.appTheme.textColorMain(),
                                fontSize: 26,
                                fontWeight: FontWeight.w600)
                            .copyWith(fontFamily: 'Montserrat')),
                    SizedBox(
                      width: 3,
                    ),
                    Text('次',
                        style: AppTheme.appTheme.textStyle(
                            textColor: AppTheme.appTheme.textColorSecond(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
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
