import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/widget/calendar_view.dart';

class AllHabitItemView extends StatefulWidget {
  static double nominalHeightClosed = 100;
  static double nominalHeightOpen = 297;
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
    double calendarHeight = ((MediaQuery.of(context).size.width - 32) / 7) /
            ratio *
            (DateUtil.getThisMonthDaysNum() / 7) +
        (DateUtil.getThisMonthDaysNum() / 7 - 1) * 5;
    double cardHeight = widget.isOpen
        ? AllHabitItemView.nominalHeightClosed + calendarHeight + 16
        : AllHabitItemView.nominalHeightClosed;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        height: cardHeight,
        curve: !_wasOpen ? ElasticInCurve(.8) : Curves.elasticOut,
        duration: Duration(milliseconds: !_wasOpen ? 1200 : 1500),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black12.withOpacity(0.2),
                    offset: const Offset(10, 19.0),
                    blurRadius: 20),
              ],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: AppTheme.appTheme.cardBackgroundColor()),
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
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(widget.habit.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.appTheme.textStyle(
                    textColor: AppTheme.appTheme.textColorMain(),
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star_border,
                    size: 25,
                    color: Color(widget.habit.mainColor),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text('${HabitUtil.getDoDays(widget.habit)}',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: AppTheme.appTheme.textColorMain(),
                              fontSize: 22,
                              fontWeight: FontWeight.w600)
                          .copyWith(fontFamily: 'Montserrat')),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 25,
                    color: Color(widget.habit.mainColor),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text('${HabitUtil.getDoNums(widget.habit)}',
                      style: AppTheme.appTheme
                          .textStyle(
                              textColor: AppTheme.appTheme.textColorMain(),
                              fontSize: 22,
                              fontWeight: FontWeight.w600)
                          .copyWith(fontFamily: 'Montserrat')),
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

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap(widget.habit);
    }
  }
}
