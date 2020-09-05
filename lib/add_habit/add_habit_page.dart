import 'package:flutter/material.dart';
import 'package:timefly/add_habit/name_mark.dart';

class AddHabitPageView extends StatefulWidget {
  @override
  _AddHabitPageViewState createState() => _AddHabitPageViewState();
}

class _AddHabitPageViewState extends State<AddHabitPageView> {
  List<Widget> widgets = [];
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    widgets.add(NameAndMarkPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return widgets[index];
        });
  }
}
