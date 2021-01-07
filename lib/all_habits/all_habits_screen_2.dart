import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timefly/all_habits/habit_list_view.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/utils/system_util.dart';
import 'package:timefly/widget/tab_indicator.dart';

class AllHabitScreen extends StatefulWidget {
  @override
  _AllHabitScreenState createState() => _AllHabitScreenState();
}

class _AllHabitScreenState extends State<AllHabitScreen> {
  List<CompleteTime> tabs = CompleteTime.getCompleteTimes();

  @override
  Widget build(BuildContext context) {
    SystemUtil.changeStateBarMode(Brightness.light);
    return Stack(
      children: [
        ClipPath(
          clipper: BottomClipper(),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF738AE6),
                    Color(0xFF5C5EDD),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
            ),
            height: 250,
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).viewPadding.top + 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 8, bottom: 16),
                child: Text(
                  '所有习惯',
                  style: AppTheme.appTheme.textStyle(
                      textColor: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: tabs.length,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        child: TabBar(
                          tabs: tabs
                              .map((time) => Container(
                                    alignment: Alignment.center,
                                    width: 60,
                                    height: 38,
                                    child: Text(
                                        '${CompleteTime.getTime(time.time)}'),
                                  ))
                              .toList(),
                          labelColor: Colors.white,
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          unselectedLabelColor: Colors.white70,
                          unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                          indicator: BorderTabIndicator(
                              indicatorHeight: 36, textScaleFactor: 0.8),
                          isScrollable: true,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: tabs
                              .map((time) => AllHabitListView(
                                    completeTime: time.time,
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50.0);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEdnPoint = Offset(size.width, size.height - 50.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEdnPoint.dx, firstEdnPoint.dy);
    path.lineTo(size.width, size.height - 50.0);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
