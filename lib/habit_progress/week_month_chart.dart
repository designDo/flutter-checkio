import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/hex_color.dart';
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

  ///当前月标示 0 当前月 1 上个月
  int currentMonthIndex = 0;

  ///当前Chart类型 0 周 1 月
  int currentChart = 0;

  double darken = 0.15;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentChart = _tabController.index;
      });
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
                gradient: AppTheme.appTheme.containerGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
            height: 445 + MediaQuery.of(context).padding.top,
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
              child: currentChart == 0
                  ? BarChart(
                      weekBarData(),
                      swapAnimationDuration: Duration(milliseconds: 250),
                    )
                  : LineChart(
                      monthLineData(),
                      swapAnimationDuration: Duration(milliseconds: 250),
                    ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  currentChart == 0 ? '当前周' : ' 当前月',
                  style: AppTheme.appTheme.textStyle(
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  width: 32,
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor.darken(
                          AppTheme.appTheme.grandientColorEnd(), darken)),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  currentChart == 0 ? '上一周' : '上一月',
                  style: AppTheme.appTheme.headline1(
                    textColor: HexColor.darken(
                        AppTheme.appTheme.grandientColorEnd(), darken),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )
              ],
            ),

            Container(
              margin: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
              padding: EdgeInsets.only(left: 32, right: 24),
              height: 90,
              decoration: BoxDecoration(
                  boxShadow: AppTheme.appTheme.containerBoxShadow(),
                  color: AppTheme.appTheme.cardBackgroundColor(),
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
                        getWeekOrMonthStr(),
                        style: AppTheme.appTheme.headline1(
                            textColor: AppTheme.appTheme.grandientColorEnd(),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                          currentChart == 0
                              ? DateUtil.getWeekPeriodString(
                                  _now, currentWeekIndex)
                              : DateUtil.getMonthPeriodString(
                                  _now, currentMonthIndex),
                          style: AppTheme.appTheme.numHeadline1(
                              textColor: AppTheme.appTheme
                                  .grandientColorEnd()
                                  .withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: 18))
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  InkWell(
                    onTap: () {
                      if (currentChart == 0) {
                        setState(() {
                          currentWeekIndex += 1;
                        });
                      } else {
                        setState(() {
                          currentMonthIndex += 1;
                        });
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/images/navigation_left.svg',
                      color: AppTheme.appTheme.grandientColorEnd(),
                      width: 28,
                      height: 28,
                    ),
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  InkWell(
                      onTap: () {
                        if (currentChart == 0) {
                          if (currentWeekIndex == 0) {
                            return;
                          }
                          setState(() {
                            currentWeekIndex -= 1;
                          });
                        } else {
                          if (currentMonthIndex == 0) {
                            return;
                          }
                          setState(() {
                            currentMonthIndex -= 1;
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/images/navigation_right.svg',
                        color: ((currentChart == 0 && currentWeekIndex == 0) ||
                                (currentChart == 1 && currentMonthIndex == 0))
                            ? AppTheme.appTheme.containerBackgroundColor()
                            : AppTheme.appTheme.grandientColorEnd(),
                        width: 28,
                        height: 28,
                      ))
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  String getWeekOrMonthStr() {
    if (currentChart == 0) {
      if (currentWeekIndex == 0) {
        return '本周';
      } else if (currentWeekIndex == 1) {
        return '上周';
      } else {
        return '$currentWeekIndex周前';
      }
    } else {
      if (currentMonthIndex == 0) {
        return '本月';
      } else if (currentMonthIndex == 1) {
        return '上月';
      } else {
        return '$currentMonthIndex月前';
      }
    }
  }

  BarChartData weekBarData() {
    Pair<DateTime> currentWeek =
        DateUtil.getWeekStartAndEnd(_now, currentWeekIndex);
    Pair<DateTime> previousWeek =
        DateUtil.getWeekStartAndEnd(_now, currentWeekIndex + 1);

    List<double> currentWeekNums = [];
    for (int i = 0; i < 7; i++) {
      currentWeekNums.add(
          HabitUtil.getTotalDoNumsOfDay(widget.habits, currentWeek.x0 + i.days)
              .toDouble());
    }
    List<double> previousWeekNums = [];
    for (int i = 0; i < 7; i++) {
      previousWeekNums.add(
          HabitUtil.getTotalDoNumsOfDay(widget.habits, previousWeek.x0 + i.days)
              .toDouble());
    }
    double maxY = 0;
    currentWeekNums.forEach((num) {
      if (num > maxY) {
        maxY = num;
      }
    });
    previousWeekNums.forEach((num) {
      if (num > maxY) {
        maxY = num;
      }
    });
    return BarChartData(
      maxY: maxY >= 5 ? maxY * 1.3 : 5,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipRoundedRadius: 16,
            tooltipPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tooltipBgColor: AppTheme.appTheme.cardBackgroundColor(),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  (rod.y - 1).toInt().toString(),
                  AppTheme.appTheme.numHeadline1(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ));
            }),
        touchCallback: (event, barTouchResponse) {
          setState(() {
            if (barTouchResponse?.spot != null) {
              touchedIndex = barTouchResponse.spot?.touchedBarGroupIndex;
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
            getTextStyles: (context, value) => AppTheme.appTheme.headline1(
                textColor: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14),
            margin: 16,
            getTitles: (double value) {
              return CompleteDay.getSimpleDay(value.toInt() + 1);
            },
          ),
          leftTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          rightTitles: SideTitles(showTitles: false)),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(show: false),
      barGroups: showingGroups(currentWeekNums, previousWeekNums, maxY),
    );
  }

  List<BarChartGroupData> showingGroups(List<double> currentWeekNums,
          List<double> previousWeekNums, double maxY) =>
      List.generate(7, (i) {
        return makeGroupData(i, currentWeekNums[i], previousWeekNums[i],
            isTouched: i == touchedIndex);
      });

  BarChartGroupData makeGroupData(
    int x,
    double currentY,
    double previousY, {
    bool isTouched = false,
    double width = 12,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      barsSpace: 6,
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched
              ? (currentY > 0 ? currentY + 1 : 1)
              : (currentY > 0 ? currentY : 1),
          colors: [Colors.white],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
          ),
        ),
        BarChartRodData(
          y: isTouched
              ? (previousY > 0 ? previousY + 1 : 1)
              : (previousY > 0 ? previousY : 1),
          colors: [
            HexColor.darken(AppTheme.appTheme.grandientColorEnd(), darken)
          ],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
          ),
        )
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  /// month line chart

  LineChartData monthLineData() {
    Pair<DateTime> currentMonth =
        DateUtil.getMonthStartAndEnd(_now, currentMonthIndex);
    Pair<DateTime> previousMonth =
        DateUtil.getMonthStartAndEnd(_now, currentMonthIndex + 1);

    List<double> currentMonthNums = [];
    for (int i = 0;
        i < (currentMonthIndex == 0 ? _now.day : currentMonth.x1.day);
        i++) {
      currentMonthNums.add(
          HabitUtil.getTotalDoNumsOfDay(widget.habits, currentMonth.x0 + i.days)
              .toDouble());
    }
    List<double> previousMonthNums = [];
    for (int i = 0; i < previousMonth.x1.day; i++) {
      previousMonthNums.add(HabitUtil.getTotalDoNumsOfDay(
              widget.habits, previousMonth.x0 + i.days)
          .toDouble());
    }
    double maxY = 0;
    currentMonthNums.forEach((num) {
      if (num > maxY) {
        maxY = num;
      }
    });
    previousMonthNums.forEach((num) {
      if (num > maxY) {
        maxY = num;
      }
    });
    return LineChartData(
        gridData: FlGridData(show: false),
        lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            getTouchedSpotIndicator: (bar, indexs) {
              return indexs
                  .map((e) => TouchedSpotIndicatorData(
                      FlLine(color: Colors.transparent, strokeWidth: 2),
                      FlDotData(
                          show: true,
                          getDotPainter: (FlSpot spot, double xPercentage,
                              LineChartBarData bar, int index) {
                            return FlDotCirclePainter(
                                radius: 5.5,
                                color: bar.colors[0].value == Colors.white.value
                                    ? bar.colors[0]
                                    : Colors.transparent,
                                strokeColor:
                                    bar.colors[0].value == Colors.white.value
                                        ? Colors.black12
                                        : Colors.transparent,
                                strokeWidth: 1);
                          })))
                  .toList();
            },
            touchTooltipData: LineTouchTooltipData(
                tooltipPadding: EdgeInsets.all(8),
                tooltipRoundedRadius: 16,
                tooltipBgColor: AppTheme.appTheme.cardBackgroundColor(),
                fitInsideVertically: true,
                fitInsideHorizontally: true,
                getTooltipItems: (spots) {
                  return spots
                      .map((spot) => (spot.barIndex == 1
                          ? LineTooltipItem(
                              '${(spot.y - 1).toInt()}\n${getMonthByIndex(spot.x.toInt())}',
                              AppTheme.appTheme.numHeadline1(
                                  fontSize: 20, fontWeight: FontWeight.bold))
                          : null))
                      .toList();
                })),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTextStyles: (context, value) => AppTheme.appTheme.numHeadline1(
                    textColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
              margin: 20,
              getTitles: (value) {
                print(value);
                switch (value.toInt()) {
                  case 1:
                    return '1';
                  case 5:
                    return '5';
                  case 10:
                    return '10';
                  case 15:
                    return '15';
                  case 20:
                    return '20';
                  case 25:
                    return '25';
                  case 30:
                    return '30';
                  default:
                    return '';
                }
              }),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: monthLines(currentMonthNums, previousMonthNums),
        maxX: 31,
        minX: 0,
        minY: 1,
        maxY: maxY >= 5 ? maxY * 1.3 : 5);
  }

  List<LineChartBarData> monthLines(
      List<double> currentMonthNums, List<double> previousMonthNums) {
    List<FlSpot> currentMonthSpots = [];
    for (int i = 0; i < currentMonthNums.length; i++) {
      currentMonthSpots.add(FlSpot(
          i + 1.0, currentMonthNums[i] > 0 ? currentMonthNums[i] + 1 : 1));
    }
    List<FlSpot> previousMonthSpots = [];
    for (int i = 0; i < previousMonthNums.length; i++) {
      previousMonthSpots.add(FlSpot(
          i + 1.0, previousMonthNums[i] > 0 ? previousMonthNums[i] + 1 : 1));
    }
    return [
      LineChartBarData(
        spots: previousMonthSpots,
        curveSmoothness: .33,
        isCurved: true,
        colors: [
          HexColor.darken(AppTheme.appTheme.grandientColorEnd(), darken),
        ],
        barWidth: 2,
        isStrokeCapRound: true,
        preventCurveOverShooting: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: currentMonthSpots,
        curveSmoothness: .33,
        isCurved: true,
        colors: [
          Colors.white,
        ],
        barWidth: 2,
        preventCurveOverShooting: true,
        isStrokeCapRound: true,
        dotData: FlDotData(
            show: true,
            getDotPainter: (FlSpot spot, double xPercentage,
                LineChartBarData bar, int index) {
              return FlDotCirclePainter(
                  radius: 2,
                  color: bar.colors[0].value == Colors.white.value
                      ? bar.colors[0]
                      : Colors.transparent,
                  strokeColor: bar.colors[0].value == Colors.white.value
                      ? Colors.black12
                      : Colors.transparent,
                  strokeWidth: 0);
            }),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }

  String getMonthByIndex(int index) {
    DateTime currentMonthFirstDay =
        DateUtil.getMonthStartAndEnd(_now, currentMonthIndex).x0;
    DateTime time =
        DateTime(currentMonthFirstDay.year, currentMonthFirstDay.month, index);
    return '${DateUtil.twoDigits(time.month)}.${DateUtil.twoDigits(time.day)}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
