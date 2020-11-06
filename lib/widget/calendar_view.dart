import 'package:flutter/material.dart';
import 'package:timefly/utils/date_util.dart';

class CalendarView extends StatefulWidget {
  final DateTime currentDay;

  final double Function() caculatorHeight;

  const CalendarView({Key key, this.currentDay, this.caculatorHeight})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<DateTime> days;

  @override
  void initState() {
    days = DateUtil.getMonthDays(
        DateTime(widget.currentDay.year, widget.currentDay.month, 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.caculatorHeight(),
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          itemCount: days.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, childAspectRatio: 1.8),
          itemBuilder: (context, index) {
            DateTime day = days[index];
            if (day == null) {
              return Container();
            }
            return Container(
              alignment: Alignment.center,
              child: Text('${day.day}'),
            );
          }),
    );
  }
}
