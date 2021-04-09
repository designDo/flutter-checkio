import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/widget/circle_progress_bar.dart';

import '../app_theme.dart';

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
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
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
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '今天',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text('1/2',
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 14)),
                  Container(
                    width: 50,
                    height: 50,
                    child: CircleProgressBar(
                        backgroundColor: Colors.indigo.withOpacity(0.6),
                        foregroundColor: Colors.white,
                        value: 1 / 2),
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '今天',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    child: CircleProgressBar(
                        backgroundColor: Colors.indigo.withOpacity(0.6),
                        foregroundColor: Colors.white,
                        value: 1 / 2),
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '今天',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    child: CircleProgressBar(
                        backgroundColor: Colors.indigo.withOpacity(0.6),
                        foregroundColor: Colors.white,
                        value: 1 / 2),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
