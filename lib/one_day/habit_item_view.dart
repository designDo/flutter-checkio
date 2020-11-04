import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:timefly/add_habit/edit_field_container.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/widget/habit_check_dialog.dart';

class HabitItemView extends StatelessWidget {
  final Habit habit;

  const HabitItemView({Key key, this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _initValue = 0;
    int _maxValue = 1;
    switch (habit.period) {
      case HabitPeroid.day:
        _initValue = habit.todayChek == null ? 0 : habit.todayChek.length;
        break;
      case HabitPeroid.week:
        _initValue =
            DateUtil.getWeekCheckNum(habit.todayChek, habit.totalCheck);
        break;
      case HabitPeroid.month:
        _initValue =
            DateUtil.getMonthCheckNum(habit.todayChek, habit.totalCheck);
        break;
    }
    _maxValue = habit.doNum;
    if (_initValue > _maxValue) {
      _maxValue = _initValue;
    }
    return Container(
      margin: EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 16),
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
                          color: Color(habit.mainColor).withOpacity(0.3),
                          offset: Offset(0, 7),
                          blurRadius: 10)
                    ],
                    shape: BoxShape.circle,
                    color: Color(habit.mainColor).withOpacity(0.5)),
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () async {
                    String log = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return HabitCheckDialog(
                            name: habit.name,
                          );
                        });
                    if (log == null) {
                      return;
                    }
                    Future.delayed(Duration(milliseconds: 500), () {
                      List<int> times = List();
                      if (habit.todayChek != null) {
                        times.addAll(habit.todayChek);
                      }
                      times.add(DateTime.now().millisecondsSinceEpoch);
                      BlocProvider.of<HabitsBloc>(context)
                          .add(HabitUpdate(habit.copyWith(todayChek: times)));
                    });
                  },
                  child: Image.asset(habit.iconPath),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Color(habit.mainColor)),
                child: Text(
                  '${HabitPeroid.getPeroid(habit.period)}',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: AppTheme.appTheme.textStyle(
                        textColor: AppTheme.appTheme.textColorMain(),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  getTodayCheckNum() == 0
                      ? SizedBox(
                          height: 16,
                        )
                      : getStarsView(),
                  Text(
                    getHabitInfo(),
                    style: AppTheme.appTheme.textStyle(
                        textColor: AppTheme.appTheme.textColorSecond(),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            height: 70,
            alignment: Alignment.center,
            width: 70,
            child: SleekCircularSlider(
              initialValue: _initValue.roundToDouble(),
              max: _maxValue.roundToDouble(),
              innerWidget: (value) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${value.floor()}/${habit.doNum}',
                    style: AppTheme.appTheme.textStyle(
                        textColor: AppTheme.appTheme.textColorMain(),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                );
              },
              appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(
                      trackWidth: 2,
                      progressBarWidth: 5,
                      handlerSize: 0,
                      shadowWidth: 0),
                  customColors: CustomSliderColors(
                      hideShadow: true,
                      shadowColor: Colors.transparent,
                      trackColor: Color(habit.mainColor),
                      progressBarColors: [
                        Color(habit.mainColor).withBlue(100),
                        Color(habit.mainColor).withBlue(200)
                      ])),
            ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  String getHabitInfo() {
    String info =
        '${habit.remindTimes == null ? '' : '${habit.remindTimes[0]}  '}'
        '${habit.period != HabitPeroid.week ? '  连续${HabitUtil.getMostStreaks(habit)}天' : ''}';
    return info;
  }

  Widget getStarsView() {
    return Container(
      alignment: Alignment.center,
      height: 32,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 8),
            width: 16,
            height: 16,
            child: Icon(
              Icons.star,
              color: Color(habit.mainColor),
            ),
          );
        },
        itemCount: getTodayCheckNum(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  int getTodayCheckNum() {
    return habit.todayChek != null ? habit.todayChek.length : 0;
  }
}
