import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/app_theme.dart';

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

  Animation<double> closeIconAnimation;

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

    closeIconAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
            parent: editPageAnimationController,
            curve: Curves.decelerate,
            reverseCurve: Curves.decelerate));

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

  ///top context close the sheet
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Material(
      child: WillPopScope(
          onWillPop: () async {
            bool shouldClose = true;
            if (_index > 0) {
              backPage();
              return false;
            }
            await showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                      title: Text('Should Close?'),
                      actions: <Widget>[
                        CupertinoButton(
                          child: Text('Yes'),
                          onPressed: () {
                            shouldClose = true;
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoButton(
                          child: Text('No'),
                          onPressed: () {
                            shouldClose = false;
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
            return shouldClose;
          },
          child: Material(
            color: Colors.transparent,
            child: Navigator(
              onGenerateRoute: (_) => MaterialPageRoute(builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        AppTheme.appTheme.addHabitSheetBgLight(),
                        AppTheme.appTheme.addHabitSheetBgDark()
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
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
          )),
    );
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
                  child: SvgPicture.asset(
                    'assets/images/fanhui.svg',
                    color: Colors.white70,
                    width: 30,
                    height: 30,
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
            animation: closeIconAnimation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.translationValues(
                    40 * (1 - closeIconAnimation.value), 0, 0),
                child: FadeTransition(
                  opacity: closeIconAnimation,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(_context).pop();
                    },
                    child: SvgPicture.asset(
                      'assets/images/guanbi.svg',
                      color: Colors.white70,
                      width: 30,
                      height: 30,
                    ),
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
        duration: Duration(milliseconds: 500), curve: Curves.easeOutSine);
  }

  void nextPage() {
    pageController.animateToPage(_index + 1,
        duration: Duration(milliseconds: 500), curve: Curves.easeOutSine);
  }
}
