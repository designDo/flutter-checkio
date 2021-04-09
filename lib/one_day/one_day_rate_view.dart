import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';

///周期为天的习惯完成率
class OneDayRateView extends StatelessWidget {
  final List<Habit> allHabits;
  final Animation<Offset> animation;

  const OneDayRateView({Key key, this.allHabits, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Padding(
        padding: EdgeInsets.only(left: 50, bottom: 16, top: 16),
        child: Container(
          alignment: Alignment.center,
          height: 100,
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color(0xFF738AE6).withOpacity(0.8),
                    offset: const Offset(13.1, 4.0),
                    blurRadius: 16.0),
              ],
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF738AE6),
                  Color(0xFF5C5EDD),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}
