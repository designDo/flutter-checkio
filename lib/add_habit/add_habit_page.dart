import 'package:flutter/material.dart';
import 'package:timefly/add_habit/Icon_color.dart';
import 'package:timefly/add_habit/name_mark.dart';

class AddHabitPageView extends StatefulWidget {
  final AnimationController editAnimationController;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final Function onPageNext;

  const AddHabitPageView(
      {Key key, this.onPageNext, this.pageController, this.onPageChanged, this.editAnimationController})
      : super(key: key);

  @override
  _AddHabitPageViewState createState() => _AddHabitPageViewState();
}

class _AddHabitPageViewState extends State<AddHabitPageView> {
  List<Widget> widgets = [];

  @override
  void initState() {
    widgets.add(NameAndMarkPage(
      onPageNext: widget.onPageNext,

    ));
    widgets.add(IconAndColorPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        onPageChanged: widget.onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        controller: widget.pageController,
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return widgets[index];
        });
  }
}
