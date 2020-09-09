import 'package:flutter/material.dart';
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

  ///控制PageView
  PageController pageController;

  ///页面切换
  ValueChanged<int> onPageChanged;

  ///点击下一步
  Function onPageNext;

  ///点击开始编辑事件
  Function onStartEdit;

  ///完成编辑事件
  Function onEndEdit;

  int _index = 0;

  @override
  void initState() {
    onStartEdit = () {
      editPageAnimationController.forward();
    };

    onEndEdit = () {
      editPageAnimationController.reverse();
    };

    editPageAnimationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

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
      onStartEdit: onStartEdit,
      onEndEdit: onEndEdit,
      editAnimationController: editPageAnimationController,
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
                      getBarView(),
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

  Widget getBarView() {
    return Row(
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
          child: AnimatedBuilder(
            animation: editPageAnimationController,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.translationValues(
                    80 * (editPageAnimationController.value), 0, 0),
                child: InkWell(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
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
