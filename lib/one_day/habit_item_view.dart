import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/models/habit.dart';

class HabitItemView extends StatefulWidget {
  final Habit habit;

  const HabitItemView({Key key, this.habit}) : super(key: key);

  @override
  _HabitItemViewState createState() => _HabitItemViewState();
}

class _HabitItemViewState extends State<HabitItemView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _initValue = 0;
    int _maxValue = 1;
    switch (widget.habit.period) {
      case 0:
        _initValue =
            widget.habit.todayChek == null ? 0 : widget.habit.todayChek.length;
        _maxValue = widget.habit.doNum;
        if (_initValue > _maxValue) {
          _maxValue = _initValue;
        }
        break;
      case 1:
        break;
      case 2:
        break;
    }
    return Container(
      margin: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
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
                      color: Color(widget.habit.mainColor).withOpacity(0.3),
                      offset: Offset(0, 7),
                      blurRadius: 10)
                ],
                shape: BoxShape.circle,
                color: Color(widget.habit.mainColor).withOpacity(0.5)),
            width: 60,
            height: 60,
            child: GestureDetector(
              onTap: () async {
                List<int> times = List();
                if (widget.habit.todayChek != null) {
                  times.addAll(widget.habit.todayChek);
                }
                times.add(DateTime.now().millisecondsSinceEpoch);
                BlocProvider.of<HabitsBloc>(context)
                    .add(HabitUpdate(widget.habit.copyWith(todayChek: times)));
              },
              child: Image.asset(widget.habit.iconPath),
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
                    widget.habit.name,
                    style: AppTheme.appTheme.textStyle(
                        textColor: AppTheme.appTheme.textColorMain(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${widget.habit.remindTimes == null ? '' : widget.habit.remindTimes[0]}',
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
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            width: 70,
            child: SleekCircularSlider(
              initialValue: _initValue.roundToDouble(),
              max: _maxValue.roundToDouble(),
              innerWidget: (value) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${value.floor()}/${widget.habit.doNum}',
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
                      trackColor: Color(widget.habit.mainColor),
                      progressBarColors: [
                        Color(widget.habit.mainColor).withBlue(100),
                        Color(widget.habit.mainColor).withBlue(200)
                      ])),
            ),
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }
}
