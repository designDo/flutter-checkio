import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timefly/add_habit/habit_edit_page.dart';
import 'package:timefly/utils/date_util.dart';

import '../app_theme.dart';

///当前时间提示 and 美丽的句子
class TimeAndWordView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<Offset> animation;

  const TimeAndWordView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: animation,
          child: Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 50,
                top: MediaQuery.of(context).padding.top + 26,
                bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {},
                  child: Text(
                    '${DateUtil.getNowTimeString()}好，',
                    style: AppTheme.appTheme
                        .headline1(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
                Text(
                  '且随疾风前行，身后亦须留心。',
                  style: AppTheme.appTheme
                      .headline1(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                Text(
                  'Follow the wind, but watch your back.',
                  style: AppTheme.appTheme
                      .numHeadline1(fontSize: 16, fontWeight: FontWeight.normal)
                      .copyWith(fontFamily: 'Montserrat'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class OneDayTipsView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<Offset> animation;

  const OneDayTipsView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: animation,
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (context) {
                return HabitEditPage(
                  isModify: false,
                  habit: null,
                );
              }));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                    gradient: AppTheme.appTheme.containerGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Text(
                  '点击添加一个习惯吧...',
                  style: AppTheme.appTheme.headline1(
                      textColor: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
