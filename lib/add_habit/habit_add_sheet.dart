import 'package:flutter/material.dart';
import 'package:timefly/add_habit/add_habit_page.dart';
import 'package:timefly/add_habit/edit_name.dart';
import 'package:timefly/utils/hex_color.dart';

import 'Icon_color.dart';
import 'name_mark.dart';

class HabitAddSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitAddSheet();
  }
}

class _HabitAddSheet extends State<HabitAddSheet>
    with TickerProviderStateMixin {
  List<Widget> widgets = [];

  ///编辑页面动画， X 向右平移，姓名编辑页面向下平移淡出，编辑页面向上平移淡出
  AnimationController editPageAnimationController;
  PageController pageController;

  ///页面切换
  ValueChanged<int> onPageChanged;

  ///点击下一步
  Function onPageNext;

  ///点击编辑
  Function onEdit;
  int _index = 0;

  @override
  void initState() {
    onEdit = () {

    };

    editPageAnimationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    pageController = PageController();
    onPageChanged = (index) {
      setState(() {
        _index = index;
      });
    };
    onPageNext = () {
      nextPage();
    };

    widgets.add(NameAndMarkPage(
      onPageNext: onPageNext,
      onEdit: onEdit,
      editAnimation: Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
          parent: editPageAnimationController,
          curve: Interval(0, 0.5,
              curve: Interval(0, 1, curve: Curves.fastOutSlowIn)))),
    ));
    widgets.add(IconAndColorPage());
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
          color: Colors.transparent,
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(builder: (context) {
              return Container(
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
                        child: PageView.builder(
                            onPageChanged: onPageChanged,
                            physics: NeverScrollableScrollPhysics(),
                            controller: pageController,
                            itemCount: widgets.length,
                            itemBuilder: (context, index) {
                              return widgets[index];
                            }),
                      ),
                    ]),
              );
            }),
          ),
        ));
  }

  @override
  void dispose() {
    editPageAnimationController.dispose();
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
