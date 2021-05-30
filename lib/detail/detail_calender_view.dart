import 'dart:math';
import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/one_day/habit_check_view.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/widget/float_modal.dart';

import '../app_theme.dart';

///详情页面的 月 面板
///
class HabitDetailCalendarView extends StatefulWidget {
  final String habitId;
  final int createTime;
  final Color color;
  final Map<String, List<HabitRecord>> records;
  final List<DateTime> days;
  final int period;
  final List<int> completeDays;

  const HabitDetailCalendarView(
      {Key key,
      this.habitId,
      this.color,
      this.records,
      this.days,
      this.createTime,
      this.completeDays,
      this.period})
      : super(key: key);

  @override
  _HabitDetailCalendarViewState createState() =>
      _HabitDetailCalendarViewState();
}

class _HabitDetailCalendarViewState extends State<HabitDetailCalendarView> {
  List<DateTime> days;

  @override
  void initState() {
    days = widget.days;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: .3, right: .3),
          itemCount: days.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, childAspectRatio: 1.5, mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            DateTime day = days[index];
            Pair2<bool, int> contains = containsDay(day);
            if (day == null) {
              if (index < 7) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${DateUtil.getWeekendString(index + 1)}',
                    style: AppTheme.appTheme.numHeadline1(
                        textColor: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                );
              }
              return Container();
            }
            return GestureDetector(
              onTap: () async {
                if (DateUtil.isFuture(day)) {
                  FlashHelper.toast(context, '超出时间范围');
                  return;
                }
                if (DateUtil.isLast(day,
                    DateTime.fromMillisecondsSinceEpoch(widget.createTime))) {
                  FlashHelper.toast(context, '超出创建时间');
                  return;
                }
                if (widget.period != HabitPeriod.month &&
                    widget.completeDays.length != 7 &&
                    !widget.completeDays.contains(day.weekday)) {
                  FlashHelper.toast(context, '不在记录周期');
                  return;
                }
                showFloatingModalBottomSheet(
                    barrierColor: Colors.black87,
                    context: context,
                    builder: (context) {
                      return HabitCheckView(
                        habitId: widget.habitId,
                        isFromDetail: true,
                        start: DateUtil.startOfDay(day),
                        end: DateUtil.endOfDay(day),
                      );
                    });
              },
              onDoubleTap: () {},
              child: Container(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CustomPaint(
                    painter: ContainerPainter(contains.s, contains.t,
                        _lineHeight() / 2, widget.color),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${DateUtil.isToday(day.millisecondsSinceEpoch) ? '今' : day.day}',
                        style: AppTheme.appTheme.numHeadline1(
                            textColor: contains.s ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Pair2<bool, int> containsDay(DateTime date) {
    if (date == null) {
      return Pair2(false, 0);
    }
    bool contain = false;
    int count = 0;
    if (widget.records == null || widget.records.length == 0) {
      contain = false;
    } else if (widget.records
        .containsKey('${date.year}-${date.month}-${date.day}')) {
      contain = true;
      count = widget.records['${date.year}-${date.month}-${date.day}'].length;
    }
    return Pair2(contain, count);
  }

  double _lineHeight() {
    return ((MediaQuery.of(context).size.width - 20 * 2) / 7) / 1.5;
  }
}

class ContainerPainter extends CustomPainter {
  final int count;
  final bool needPaint;
  final double radius;
  final Color color;

  ContainerPainter(this.needPaint, this.count, this.radius, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Paint paint = Paint()..color = needPaint ? color : Colors.transparent;
    canvas.drawCircle(center, radius - 2, paint);

    for (int i = 0; i < count; i++) {
      canvas.drawCircle(
          center +
              Offset((radius + 3) * cos((-2 + i) * pi / 6),
                  (radius + 3) * sin((-2 + i) * pi / 6)),
          3,
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    ContainerPainter oldPinter = oldDelegate as ContainerPainter;
    return oldPinter.needPaint != this.needPaint ||
        oldPinter.count != this.count;
  }
}
