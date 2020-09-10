import 'package:flutter/material.dart';
import 'package:timefly/utils/hex_color.dart';

import 'edit_name.dart';

class NameAndMarkPage extends StatefulWidget {
  final Function onPageNext;
  final Function onStartEdit;
  final Function onEndEdit;
  final AnimationController editAnimationController;

  const NameAndMarkPage(
      {Key key,
      this.onPageNext,
      this.onStartEdit,
      this.editAnimationController,
      this.onEndEdit})
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
                  height: 32,
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(0, 0.1, curve: Curves.decelerate)),
                      child: Text(
                        '给习惯取一个好听的名字\n并编辑一句鼓励自己的话',
                        strutStyle: StrutStyle(height: 2),
                        style: TextStyle(
                            fontFamily: 'MaShanZheng',
                            letterSpacing: 3,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
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
                            child: Container(
                                padding: EdgeInsets.only(left: 16, top: 28),
                                width: 400,
                                height: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: HexColor('#7976CD')),
                                child: Text(
                                  _name.length == 0 ? '名字 ...' : _name,
                                  style: TextStyle(
                                      color: _name.length == 0
                                          ? Colors.white70
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
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
                            child: Container(
                                padding: EdgeInsets.only(left: 16, top: 16),
                                width: 400,
                                height: 150,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: HexColor('#7976CD')),
                                child: Text(
                                  _mark.length == 0 ? 'mark ...' : _mark,
                                  strutStyle: StrutStyle(height: 1.5),
                                  style: TextStyle(
                                      color: _mark.length == 0
                                          ? Colors.white70
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
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
                          widget.onPageNext();
                        },
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
                                  : HexColor('#726DBD')),
                          child: Text(
                            '下一步',
                            style: TextStyle(
                                color: HexColor('#625FAC'),
                                fontSize: 20,
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
                    reverseCurve: Interval(0, 0.6, curve: Curves.decelerate)));
            return Transform(
              transform: Matrix4.translationValues(
                  0, 180 * (1 - myAnimation.value), 0),
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
      Future.delayed(Duration(milliseconds: 300), () {
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
