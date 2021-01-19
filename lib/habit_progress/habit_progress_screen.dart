import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/widget/clip/bottom_cliper.dart';
import 'package:timefly/widget/tab_indicator.dart';

class HabitProgressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitProgressScreenState();
  }
}

class _HabitProgressScreenState extends State<HabitProgressScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print(_tabController.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: FutureBuilder(
          future: DatabaseProvider.db.getHabitsWithRecords(),
          builder: (context, data) {
            if (!data.hasData) {
              return CupertinoActivityIndicator();
            }
            var habits = data.data;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                allHabitProgress(),
                Container(
                  color: Colors.redAccent,
                  height: 800,
                )
              ],
            );
          }),
    );
  }

  ///上方显示的周月切换 曲线
  Widget allHabitProgress() {
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
            )),
            height: 450,
          ),
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16),
              child: TabBar(
                controller: _tabController,
                tabs: ['周', '月']
                    .map((time) => Container(
                          margin: EdgeInsets.only(left: 8, right: 8),
                          alignment: Alignment.center,
                          width: 60,
                          height: 38,
                          child: Text('$time'),
                        ))
                    .toList(),
                labelColor: Colors.white,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                unselectedLabelColor: Colors.white70,
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                indicator: BorderTabIndicator(
                    indicatorHeight: 36, textScaleFactor: 0.8),
                isScrollable: true,
              ),
            ),
            ///lineChart
            
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
