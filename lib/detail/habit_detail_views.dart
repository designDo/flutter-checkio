import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';

class HabitBaseInfoView extends StatelessWidget {
  final Habit habit;

  const HabitBaseInfoView({Key key, this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 16, top: 16, right: 16),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('${habit.createTime}')],
      ),
    );
  }
}
