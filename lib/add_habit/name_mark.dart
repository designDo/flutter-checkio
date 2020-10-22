import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';

import 'edit_name.dart';

class NameAndMarkPage extends StatefulWidget {
  final Habit habit;
  final Function onPageNext;
  final Function onStartEdit;
  final Function onEndEdit;
  final AnimationController editAnimationController;

  const NameAndMarkPage(
      {Key key,
      this.onPageNext,
      this.onStartEdit,
      this.editAnimationController,
      this.onEndEdit,
      this.habit})
      : super(key: key);

  @override
  _NameAndMarkPageState createState() => _NameAndMarkPageState();
}

class _NameAndMarkPageState extends State<NameAndMarkPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _animationController;
  Animation<double> editAnimation;
  String _name = '';
  String _mark = '';

  static int type_name = 1;
  static int type_mark = 2;

  int edit_type;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    Future.delayed(
        Duration(milliseconds: 400), () => _animationController.forward());

    editAnimation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: widget.editAnimationController,
        curve: Curves.easeInCubic,
        reverseCurve: Curves.easeOutCubic));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.editAnimationController,
      builder: (context, child) {
        return Transform(
          transform:
              Matrix4.translationValues(0, 80 * (1 - editAnimation.value), 0),
          child: FadeTransition(
            opacity: editAnimation,
            child: Column(
              children: [
                SizedBox(
                  height: 68,
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0, 0.1, curve: Curves.decelerate)),
                      child: Text('给习惯取一个好听的名字\n并编辑一句鼓励自己的话',
                          strutStyle: StrutStyle(height: 2),
                          style: AppTheme.appTheme.textStyle(
                              textColor: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    );
                  },
                ),
                SizedBox(
                  height: 32,
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0.1, 0.3, curve: Curves.decelerate)),
                      child: Padding(
                          padding: EdgeInsets.only(left: 32, right: 32),
                          child: GestureDetector(
                            onTap: () async {
                              widget.onStartEdit();
                              edit_type = type_name;
                              gotoEditName(context);
                            },
                            onDoubleTap: () {},
                            child: Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                alignment: Alignment.centerLeft,
                                width: 400,
                                height: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.08)),
                                child: Text(
                                  _name.length == 0 ? '名字 ...' : _name,
                                  style: AppTheme.appTheme.textStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      textColor: _name.length == 0
                                          ? Colors.white.withOpacity(0.5)
                                          : Colors.white),
                                )),
                          )),
                    );
                  },
                ),
                SizedBox(
                  height: 42,
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0.3, 0.5, curve: Curves.decelerate)),
                      child: Padding(
                          padding: EdgeInsets.only(left: 32, right: 32),
                          child: GestureDetector(
                            onTap: () {
                              widget.onStartEdit();
                              edit_type = type_mark;
                              gotoEditName(context);
                            },
                            onDoubleTap: () {},
                            child: Container(
                                padding: EdgeInsets.only(left: 16, top: 16),
                                width: 400,
                                height: 130,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(0.08)),
                                child: Text(
                                  _mark.length == 0 ? '千里之行，始于足下 ...' : _mark,
                                  strutStyle: StrutStyle(height: 1.5),
                                  style: AppTheme.appTheme.textStyle(
                                    fontSize: 16,
                                    textColor: _mark.length == 0
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          )),
                    );
                  },
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.5, 1, curve: Curves.elasticOut),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (_name.length == 0) {
                            return;
                          }
                          widget.habit.name = _name;
                          widget.habit.mark = _mark;
                          widget.onPageNext();
                        },
                        onDoubleTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 250,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32)),
                              color: _name.length > 0
                                  ? Colors.white
                                  : Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.25)),
                          child: Text(
                            '下一步',
                            style: AppTheme.appTheme.textStyle(
                                textColor: _name.length > 0
                                    ? AppTheme.appTheme.gradientColorDark()
                                    : Colors.black.withOpacity(0.2),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void gotoEditName(BuildContext context) async {
    Future.delayed(Duration(milliseconds: 300), () async {
      String value = await Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, ani1, ani2) {
            return EditNameView(
              editValue: edit_type == type_name ? _name : _mark,
              editType: edit_type,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Animation<double> myAnimation = Tween<double>(begin: 0, end: 1.0)
                .animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutSine,
                    reverseCurve: Interval(0, 0.5, curve: Curves.easeInSine)));
            return Transform(
              transform:
                  Matrix4.translationValues(0, 90 * (1 - myAnimation.value), 0),
              child: FadeTransition(
                opacity: myAnimation,
                child: child,
              ),
            );
          }));
      setState(() {
        if (edit_type == type_name) {
          _name = value;
        } else if (edit_type == type_mark) {
          _mark = value;
        }
      });
      Future.delayed(Duration(milliseconds: 200), () {
        widget.onEndEdit();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
