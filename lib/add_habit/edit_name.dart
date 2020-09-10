import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/utils/hex_color.dart';

class EditNameView extends StatefulWidget {
  final String editValue;
  final int editType;

  const EditNameView({
    Key key,
    this.editValue,
    this.editType,
  }) : super(key: key);

  @override
  _EditNameViewState createState() => _EditNameViewState();
}

class _EditNameViewState extends State<EditNameView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  ///文本内容
  String _value = '';
  TextEditingController editingController;

  ///这两个字段为了解决Android手机导航键隐藏时，键盘回调
  ///打开页面 close close open
  ///关闭页面 close close
  ///initState之后延迟1s设置为false
  bool init = true;
  bool hasClose = true;

  AnimationController numAnimationController;
  Animation<double> numAnimation;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          //关闭键盘
          if (!init && hasClose) {
            Navigator.of(context).pop(_value);
          }
          hasClose = !hasClose;
        } else {
          //显示键盘
        }
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    editingController = TextEditingController(text: widget.editValue);
    Future.delayed(Duration(milliseconds: 1000), () {
      init = false;
    });
    numAnimationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    numAnimation = CurvedAnimation(
        parent: numAnimationController, curve: Curves.easeOutBack);
    if (widget.editValue.length > 0) {
      numAnimationController.forward(from: 0.3);
    }
    _value = widget.editValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text(widget.editType == 1 ? '习惯名字' : '标志',
                  style: TextStyle(
                    letterSpacing: 3,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(
                height: 62,
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 32, right: 32),
                    child: TextField(
                      strutStyle: StrutStyle(height: 1.5),
                      maxLength: widget.editType == 1 ? 10 : 40,
                      maxLines: widget.editType == 1 ? 1 : 5,
                      minLines: widget.editType == 1 ? 1 : 4,
                      controller: editingController,
                      showCursor: true,
                      autofocus: true,
                      onChanged: (value) async {
                        setState(() {
                          _value = value;
                        });
                        if (value.length == 1) {
                          numAnimationController.forward(from: 0.3);
                        } else if (value.length > 1) {
                          numAnimationController.forward(from: 0.3);
                        } else {
                          numAnimationController.reverse(from: 0.3);
                        }
                      },
                      onSubmitted: (value) async {},
                      cursorColor: Colors.blueAccent,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 16, top: 30, bottom: 30, right: 16),
                          hintText: widget.editType == 1 ? '名字 ...' : '标记 ...',
                          hintStyle: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                          fillColor: HexColor('#7976CD'),
                          counterText: '',
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
                  ScaleTransition(
                    scale: numAnimation,
                    child: Padding(
                        padding: EdgeInsets.only(right: 25),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          width: 50,
                          height: 35,
                          child: Text(
                            '${_value.length}/${widget.editType == 1 ? 10 : 50}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(right: 30, top: 16),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    width: 50,
                    height: 50,
                    child: SvgPicture.asset(
                      'assets/images/duigou.svg',
                      color: Colors.black87,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    editingController.dispose();
    numAnimationController.dispose();
    super.dispose();
  }
}
