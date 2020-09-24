import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';

class HabitItemView extends StatefulWidget {
  final Habit habit;

  const HabitItemView({Key key, this.habit}) : super(key: key);

  @override
  _HabitItemViewState createState() => _HabitItemViewState();
}

class _HabitItemViewState extends State<HabitItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 32, right: 16),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                offset: const Offset(10, 9.0),
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
                shape: BoxShape.circle, color: Color(widget.habit.mainColor)),
            width: 60,
            height: 60,
            child: Image.asset(widget.habit.iconPath),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.habit.name,
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.habit.remindTimes[0],
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.black54,
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
              initialValue: 5,
              max: 7,
              innerWidget: (value) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${value.floor()}/7',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                );
              },
              appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(
                      trackWidth: 2, progressBarWidth: 5, handlerSize: 0,shadowWidth: 0),
              customColors: CustomSliderColors(
                trackColor: Color(widget.habit.mainColor),
                progressBarColors: [AppTheme.appTheme.gradientColorLight(),AppTheme.appTheme.gradientColorDark()]
              )),
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
