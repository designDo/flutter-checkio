import 'package:alarm_calendar/alarm_calendar.dart';
import 'package:alarm_calendar/calendar_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/flash_helper.dart';

class AddHabitLoadingDialog extends StatefulWidget {
  final Habit habit;
  final CalendarEvent calendarEvent;
  final bool isModify;

  const AddHabitLoadingDialog(
      {Key key, this.habit, this.calendarEvent, this.isModify})
      : super(key: key);

  @override
  _AddHabitLoadingDialogState createState() => _AddHabitLoadingDialogState();
}

class _AddHabitLoadingDialogState extends State<AddHabitLoadingDialog>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animationController.forward();
    Future.delayed(Duration(milliseconds: 200), () => addHabit());
  }

  String message = '';

  void addHabit() async {
    setState(() {
      message = '正在保存习惯';
    });
    int satrt = DateTime.now().millisecondsSinceEpoch;
    if (widget.isModify) {
      BlocProvider.of<HabitsBloc>(context).add(HabitUpdate(widget.habit));
    } else {
      BlocProvider.of<HabitsBloc>(context).add(HabitsAdd(widget.habit));
    }
    int end = DateTime.now().millisecondsSinceEpoch;

    if (end - satrt < 500) {
      Future.delayed(Duration(milliseconds: 500), () => insertCalendar());
    }
  }

  void insertCalendar() async {
    if (widget.calendarEvent == null) {
      Navigator.of(context).pop();
      return;
    }
    //TODO check permission
    setState(() {
      message = '正在设置日历提醒事件';
    });
    int satrt = DateTime.now().millisecondsSinceEpoch;
    CalendarInsertResult result =
        await AlarmCalendar.insertEvent(widget.calendarEvent);
    FlashHelper.toast(context, result.message);
    int end = DateTime.now().millisecondsSinceEpoch;
    if (end - satrt < 500) {
      Future.delayed(
          Duration(milliseconds: 500), () => Navigator.of(context).pop());
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
              .animate(CurvedAnimation(
                  parent: animationController, curve: Curves.fastOutSlowIn)),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: AppTheme.appTheme.containerBoxShadow(),
                color: AppTheme.appTheme.cardBackgroundColor()),
            height: 200,
            margin: EdgeInsets.only(left: 32, right: 32),
            child: Column(
              children: [Text('$message')],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
