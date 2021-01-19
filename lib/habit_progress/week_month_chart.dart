import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/widget/clip/bottom_cliper.dart';
import 'package:timefly/widget/tab_indicator.dart';
import 'package:time/time.dart';

class WeekMonthChart extends StatefulWidget {
  final List<Habit> habits;

  const WeekMonthChart({Key key, this.habits}) : super(key: key);

  @override
  _WeekMonthChartState createState() => _WeekMonthChartState();
}

class _WeekMonthChartState extends State<WeekMonthChart>
    with TickerProviderStateMixin {
  TabController _tabController;
  DateTime _now = DateTime.now();

  int touchedIndex;

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
            SizedBox(
              height: 16,
            ),

            ///lineChart
            Container(
              padding: EdgeInsets.only(left: 32, right: 32),
              width: MediaQuery.of(context).size.width,
              height: 230,
              child: BarChart(
                mainBarData(),
                swapAnimationDuration: Duration(milliseconds: 300),
              ),
            ),
          ],
        )
      ],
    );
  }

  BarChartData mainBarData() {
    List<double> checks = List.generate(7, (i) => doNumsOfday(i));
    List<double> temp = List.from(checks)..sort((a, b) => b.compareTo(a));
    double maxY = temp.first;
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  CompleteDay.getDay(group.x.toInt() + 1) +
                      '\n' +
                      (rod.y - 1).toString(),
                  TextStyle(color: Colors.black));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            return CompleteDay.getSimpleDay(value.toInt() + 1);
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(checks, maxY),
    );
  }

  List<BarChartGroupData> showingGroups(List<double> checks, double maxY) =>
      List.generate(7, (i) {
        return makeGroupData(i, checks[i],
            isTouched: i == touchedIndex, maxY: maxY + 1);
      });

  double doNumsOfday(int index) {
    return HabitUtil.getTotalDoNumsOfDay(
            widget.habits, _now - (_now.weekday - (index + 1)).days)
        .toDouble();
  }

  BarChartGroupData makeGroupData(int x, double y,
      {bool isTouched = false,
      Color barColor = Colors.white,
      double width = 22,
      List<int> showTooltips = const [],
      double maxY = 10}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.deepPurpleAccent] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxY,
            colors: [Colors.white10],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

/*
  LineChartData weekLineChart() {
    Map<int, int> weekCheck = weekTotalNum();
    List<int> valus = List.from(weekCheck.values)..sort((a, b) => b - a);
    double maxY = valus.first.toDouble();
    return LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            margin: 10,
            getTitles: (value) {
              return CompleteDay.getSimpleDay(value.toInt());
            },
          ),
          leftTitles: SideTitles(
            showTitles: false,
            getTextStyles: (value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            getTitles: (value) {
              switch (value.toInt()) {
                case 1:
                  return '1m';
                case 2:
                  return '2m';
                case 3:
                  return '8m';
                case 4:
                  return '12m';
              }
              return '';
            },
            margin: 15,
            reservedSize: 40,
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 1,
        maxX: 7,
        maxY: maxY * 2,
        minY: 0,
        lineBarsData: [weekLine(weekCheck)]);
  }

  Map<int, int> weekTotalNum() {
    DateTime now = DateTime.now();
    Map<int, int> weekTotalNum = {};
    for (int i = 1; i <= now.weekday; i++) {
      weekTotalNum[i] =
          HabitUtil.getTotalDoNumsOfDay(_habits, now - (i - 1).days);
    }
    return weekTotalNum;
  }

  LineChartBarData weekLine(Map<int, int> weekTotalNum) {
    DateTime now = DateTime.now();
    return LineChartBarData(
        spots: List<int>.from(weekTotalNum.keys)
            .map((day) => FlSpot(
            day.toDouble(),
            HabitUtil.getTotalDoNumsOfDay(_habits, now - (day - 1).days)
                .toDouble()))
            .toList()
          ..add(FlSpot(3, 5)),
        isCurved: true,
        colors: [
          Colors.redAccent,
        ],
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ));
  }*/
}
