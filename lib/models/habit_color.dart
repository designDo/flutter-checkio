import 'package:flutter/material.dart';

class HabitColor {
  final Color color;
  bool isSelect = false;

  HabitColor(this.color, {this.isSelect = false});

  static List<HabitColor> getBackgroundColors() {
    List<HabitColor> backgroundColors = [];

    backgroundColors.add(HabitColor(Colors.deepPurpleAccent, isSelect: true));
    backgroundColors.add(HabitColor(Colors.purple));
    backgroundColors.add(HabitColor(Colors.lightBlue));
    backgroundColors.add(HabitColor(Colors.red));
    backgroundColors.add(HabitColor(Colors.blueAccent));
    backgroundColors.add(HabitColor(Colors.pink));
    backgroundColors.add(HabitColor(Colors.deepOrange));
    return backgroundColors;
  }
}
