import 'package:flutter/material.dart';
import 'package:timefly/utils/hex_color.dart';

import 'edit_name.dart';

class NameAndMarkPage extends StatefulWidget {
  final Function onPageNext;
  final Function onEdit;
  final Animation<double> editAnimation;

  const NameAndMarkPage(
      {Key key, this.onPageNext, this.onEdit, this.editAnimation})
      : super(key: key);

  @override
  _NameAndMarkPageState createState() => _NameAndMarkPageState();
}

class _NameAndMarkPageState extends State<NameAndMarkPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _animationController;

  String _name = '';

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    Future.delayed(
        Duration(milliseconds: 400), () => _animationController.forward());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.editAnimation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
              0, 200 * (1 - widget.editAnimation.value), 0),
          child: FadeTransition(
            opacity: widget.editAnimation,
            child: Column(
              children: [
                SizedBox(
                  height: 18,
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
                            onTap: () {
                              widget.onEdit();
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (context, ani1, ani2) {
                                return EditNameView(
                                  animation: ani1,
                                );
                              }, transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                var tween = Tween<double>(begin: 0, end: 1.0);
                                var curvedAnimation = CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.fastOutSlowIn,
                                );

                                return FadeTransition(
                                  opacity: tween.animate(curvedAnimation),
                                  child: child,
                                );
                              }));
                            },
                            child: Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                width: 400,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: HexColor('#7976CD')),
                                child: Text(
                                  '名字',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
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
                        child: TextField(
                          minLines: 2,
                          maxLines: 3,
                          cursorColor: Colors.blueAccent,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          decoration: InputDecoration(
                              hintText: '坚持就是胜利 ...',
                              hintStyle: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                              fillColor: HexColor('#7976CD'),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: HexColor('#7976CD')),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: HexColor('#7976CD')),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                        ),
                      ),
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
