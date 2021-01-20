import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/pair.dart';
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

  ///当前周标示
  ///0 当前周，1，上一周
  int currentWeekIndex = 0;

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
            height: 500,
          ),
        ),
        Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 24,
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
                swapAnimationDuration: Duration(milliseconds: 250),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '当前周',
                  style: AppTheme.appTheme.textStyle(
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 32,
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.indigo),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '上周',
                  style: AppTheme.appTheme.textStyle(
                    textColor: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),

            Container(
              margin: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
              height: 100,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 18,
                        offset: Offset(8, 4))
                  ],
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getWeekStr(),
                        style: AppTheme.appTheme
                            .textStyle(
                                textColor: Color(0xFF5C5EDD),
                                fontWeight: FontWeight.bold,
                                fontSize: 22)
                            .copyWith(fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(DateUtil.getWeekPeriodString(_now, currentWeekIndex),
                          style: AppTheme.appTheme
                              .textStyle(
                                  textColor: Color(0xFF5C5EDD).withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)
                              .copyWith(fontFamily: 'Montserrat'))
                    ],
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        currentWeekIndex += 1;
                      });
                    },
                    child: Icon(
                      Icons.navigate_before,
                      size: 40,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  InkWell(
                    onTap: () {
                      if (currentWeekIndex == 0) {
                        return;
                      }
                      setState(() {
                        currentWeekIndex -= 1;
                      });
                    },
                    child: Icon(Icons.navigate_next,
                        size: 40,
                        color: currentWeekIndex == 0
                            ? Colors.grey
                            : Colors.indigo),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  String getWeekStr() {
    if (currentWeekIndex == 0) {
      return '本周';
    } else if (currentWeekIndex == 1) {
      return '上周';
    } else {
      return '$currentWeekIndex周前';
    }
  }

  BarChartData mainBarData() {
    List<Pair<double>> checks = List.generate(7, (i) => doNumsOfDay(i));
    double maxY = 0;
    checks.forEach((pair) {
      if (pair.x0 > maxY) {
        maxY = pair.x0;
      }
      if (pair.x1 > maxY) {
        maxY = pair.x1;
      }
    });
    return BarChartData(
      maxY: maxY > 5 ? maxY + 1 : 5,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipRoundedRadius: 16,
            tooltipBottomMargin: 8,
            tooltipPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tooltipBgColor: Colors.white,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  (rod.y - 1).toInt().toString(),
                  TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'));
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

  List<BarChartGroupData> showingGroups(
          List<Pair<double>> checks, double maxY) =>
      List.generate(7, (i) {
        return makeGroupData(i, checks[i], isTouched: i == touchedIndex);
      });

  Pair<double> doNumsOfDay(int index) {
    return Pair<double>(
        HabitUtil.getTotalDoNumsOfDay(widget.habits,
                _now - (_now.weekday - (index + 1) + 7 * currentWeekIndex).days)
            .toDouble(),
        HabitUtil.getTotalDoNumsOfDay(
                widget.habits,
                _now -
                    (_now.weekday - (index + 1) + 7 * (currentWeekIndex + 1))
                        .days)
            .toDouble());
  }

  BarChartGroupData makeGroupData(
    int x,
    Pair<double> y, {
    bool isTouched = false,
    double width = 12,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      barsSpace: 6,
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? (y.x0 > 0 ? y.x0 + 1 : 1) : (y.x0 > 0 ? y.x0 : 1),
          colors: [Colors.white],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
          ),
        ),
        BarChartRodData(
          y: isTouched ? (y.x1 > 0 ? y.x1 + 1 : 1) : (y.x1 > 0 ? y.x1 : 1),
          colors: [Colors.indigo],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
          ),
        )
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
