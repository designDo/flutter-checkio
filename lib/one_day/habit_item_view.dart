import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';

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
                List<int> times = List();
                if (habit.todayChek != null) {
                  times.addAll(habit.todayChek);
                }
                times.add(DateTime.now().millisecondsSinceEpoch);
                BlocProvider.of<HabitsBloc>(context)
                    .add(HabitUpdate(habit.copyWith(todayChek: times)));
              },
              child: Image.asset(habit.iconPath),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: AppTheme.appTheme.textStyle(
                        textColor: AppTheme.appTheme.textColorMain(),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16,
                  ),
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
            alignment: Alignment.center,
            width: 66,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16),
                  height: 30,
                  alignment: Alignment.center,
                  width: 60,
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
                getTodayCheckNum() == 0
                    ? SizedBox()
                    : Positioned(
                        top: 73,
                        child: Text(
                          '今天 +${getTodayCheckNum()}',
                          style: AppTheme.appTheme.textStyle(
                              textColor: AppTheme.appTheme.textColorSecond(),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )
              ],
            ),
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }

  String getHabitInfo() {
    String info =
        '${habit.remindTimes == null ? '' : '${habit.remindTimes[0]}  '}'
        '${HabitPeroid.getPeroid(habit.period)}'
        '${habit.period != HabitPeroid.week ? '  连续${HabitUtil.getMostStreaks(habit)}天' : ''}';
    return info;
  }

  int getTodayCheckNum() {
    int num = 0;
    if (habit.period != HabitPeroid.day) {
      return habit.todayChek != null ? habit.todayChek.length : 0;
    }
    return num;
  }
}
