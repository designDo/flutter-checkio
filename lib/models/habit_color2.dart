import 'package:flutter/material.dart';

class HabitColor {
  ///作为唯一key存入数据库
  final Color startColor;
  final Color endColor;
  bool isSelect;

  HabitColor(this.startColor, this.endColor, {this.isSelect = false});

  bool equals(HabitColor color) {
    return startColor == color.startColor;
  }
}

class HabitColorsUtil {
  static HabitColorsUtil _instance = HabitColorsUtil();

  static HabitColorsUtil instance() => _instance;
  List<HabitColor> _habitColors = [];

  void initHabitColors() {
    _habitColors
        .add(HabitColor(Color(0xff738AE6), Color(0xff5C5EDD), isSelect: true));
    _habitColors.add(HabitColor(Color(0xffF45C43), Color(0xffEB3349)));
    _habitColors.add(HabitColor(Color(0xffF09819), Color(0xffFF512F)));
    _habitColors.add(HabitColor(Color(0xffAA076B), Color(0xff61045F)));
    _habitColors.add(HabitColor(Color(0xffFF512F), Color(0xffDD2476)));
    _habitColors.add(HabitColor(Color(0xffDA22FF), Color(0xff9733EE)));
    _habitColors.add(HabitColor(Color(0xff00CDAC), Color(0xff02AAB0)));
    _habitColors.add(HabitColor(Color(0xffe52d27), Color(0xffb31217)));
    _habitColors.add(HabitColor(Color(0xff2b5876), Color(0xff4e4376)));
    _habitColors.add(HabitColor(Color(0xffF9D423), Color(0xffe65c00)));

    _habitColors.add(HabitColor(Color(0xff6dd5ed), Color(0xff2193b0)));
    _habitColors.add(HabitColor(Color(0xffcc2b5e), Color(0xff753a88)));
    _habitColors.add(HabitColor(Color(0xff1488CC), Color(0xff2B32B2)));
    _habitColors.add(HabitColor(Color(0xffB79891), Color(0xff94716B)));
    _habitColors.add(HabitColor(Color(0xff536976), Color(0xff292E49)));
    _habitColors.add(HabitColor(Color(0xffffe259), Color(0xffffa751)));
    _habitColors.add(HabitColor(Color(0xffACBB78), Color(0xff799F0C)));
    _habitColors.add(HabitColor(Color(0xffffdde1), Color(0xffee9ca7)));
    _habitColors.add(HabitColor(Color(0xff6dd5ed), Color(0xff2193b0)));
    _habitColors.add(HabitColor(Color(0xff2C5364), Color(0xff203A43)));

    _habitColors.add(HabitColor(Color(0xff4286f4), Color(0xff373B44)));
    _habitColors.add(HabitColor(Color(0xffFF0099), Color(0xff493240)));
    _habitColors.add(HabitColor(Color(0xff8E2DE2), Color(0xff4A00E0)));
    _habitColors.add(HabitColor(Color(0xfff953c6), Color(0xffb91d73)));
    _habitColors.add(HabitColor(Color(0xffc31432), Color(0xff240b36)));
    _habitColors.add(HabitColor(Color(0xfff5af19), Color(0xfff12711)));
    _habitColors.add(HabitColor(Color(0xffeaafc8), Color(0xff654ea3)));
    _habitColors.add(HabitColor(Color(0xffFF416C), Color(0xffFF4B2B)));
    _habitColors.add(HabitColor(Color(0xff00B4DB), Color(0xff0083B0)));
    _habitColors.add(HabitColor(Color(0xffad5389), Color(0xff3c1053)));
  }

  List<HabitColor> getHabitColors() {
    if (_habitColors.length == 0) {
      initHabitColors();
    }
    return _habitColors;
  }

  HabitColor getColor(Color startColor) {
    if (_habitColors.length == 0) {
      initHabitColors();
    }
    return _habitColors.firstWhere((color) => color.startColor == startColor);
  }
}
