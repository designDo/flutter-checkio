import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';

class AllHabitItemView extends StatefulWidget {
  static double nominalHeightClosed = 96;
  static double nominalHeightOpen = 290;
  final Habit habit;

  final Function(Habit) onTap;
  final bool isOpen;

  const AllHabitItemView({Key key, this.habit, this.onTap, this.isOpen})
      : super(key: key);

  @override
  _AllHabitItemViewState createState() => _AllHabitItemViewState();
}

class _AllHabitItemViewState extends State<AllHabitItemView> {
  bool _wasOpen;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen != _wasOpen) {
      _wasOpen = widget.isOpen;
    }
    double cardHeight = widget.isOpen
        ? AllHabitItemView.nominalHeightOpen
        : AllHabitItemView.nominalHeightClosed;
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        height: cardHeight,
        curve: !_wasOpen ? ElasticInCurve(.9) : Curves.elasticOut,
        duration: Duration(milliseconds: !_wasOpen ? 1200 : 1500),
        child: Container(
          color: Colors.red,
        ),
      ),
    );
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap(widget.habit);
    }
  }
}
