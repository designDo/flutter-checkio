import 'package:flutter/material.dart';
import 'package:timefly/add_habit/add_habit_page.dart';
import 'package:timefly/utils/hex_color.dart';

class HabitAddSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitAddSheet();
  }
}

class _HabitAddSheet extends State<HabitAddSheet> {
  PageController pageController;
  ValueChanged<int> onPageChanged;
  Function onPageNext;
  int _index = 0;

  @override
  void initState() {
    pageController = PageController();
    onPageChanged = (index) {
      setState(() {
        _index = index;
      });
    };
    onPageNext = () {
      nextPage();
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_index > 0) {
          backPage();
          return false;
        }
        return true;
      },
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <HexColor>[
                HexColor('#7971C4'),
                HexColor('#8389E9'),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: _index == 0
                        ? SizedBox()
                        : InkWell(
                            onTap: () {
                              backPage();
                            },
                            child: Icon(
                              Icons.keyboard_backspace,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: AddHabitPageView(
                  pageController: pageController,
                  onPageChanged: onPageChanged,
                  onPageNext: onPageNext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void backPage() {
    pageController.animateToPage(_index - 1,
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  void nextPage() {
    pageController.animateToPage(_index + 1,
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}
