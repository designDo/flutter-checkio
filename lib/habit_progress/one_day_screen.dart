import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';

class HabitProgressScreen extends StatefulWidget {
  const HabitProgressScreen({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;

  @override
  State<StatefulWidget> createState() {
    return _HabitProgressScreenState();
  }
}

class _HabitProgressScreenState extends State<HabitProgressScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.red,
        ),
      ),
    );
  }
}
