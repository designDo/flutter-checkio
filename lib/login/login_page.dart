import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/utils/system_util.dart';
import 'package:timefly/utils/uuid.dart';
import 'package:timefly/widget/custom_edit_field.dart';

import '../app_theme.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  String phone = '';
  String code = '';
  String sendText = 'Send';

  Timer timer;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void countDown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int count = 10 - timer.tick;
      if (count > 0) {
        setState(() {
          sendText = '$count';
        });
      } else {
        timer.cancel();
        setState(() {
          sendText = 'Send';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUtil.getSystemUiOverlayStyle(
          AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark),
      child: Scaffold(
        backgroundColor: AppTheme.appTheme.cardBackgroundColor(),
        body: Column(
          children: [
            SizedBox(
              height: 64,
            ),
            Text(
              'Time Fly',
              style: AppTheme.appTheme
                  .headline1(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 48,
            ),
            ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                parent: _animationController,
                curve: Interval(0, 0.3, curve: Curves.fastOutSlowIn),
              )),
              child: CustomEditField(
                maxLength: 11,
                autoFucus: false,
                inputType: TextInputType.phone,
                initValue: '',
                hintText: '手机号',
                hintTextStyle: AppTheme.appTheme
                    .hint(fontWeight: FontWeight.normal, fontSize: 16),
                textStyle: AppTheme.appTheme
                    .headline1(fontWeight: FontWeight.normal, fontSize: 16),
                containerDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: AppTheme.appTheme.containerBackgroundColor()),
                numDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppTheme.appTheme.cardBackgroundColor(),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: AppTheme.appTheme.containerBoxShadow()),
                numTextStyle: AppTheme.appTheme
                    .themeText(fontWeight: FontWeight.bold, fontSize: 15),
                onValueChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ScaleTransition(
                  scale:
                      Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.3, 0.6, curve: Curves.fastOutSlowIn),
                  )),
                  child: Container(
                    width: 250,
                    child: CustomEditField(
                      maxLength: 6,
                      autoFucus: false,
                      inputType: TextInputType.phone,
                      initValue: '',
                      hintText: '验证码',
                      hintTextStyle: AppTheme.appTheme
                          .hint(fontWeight: FontWeight.normal, fontSize: 16),
                      textStyle: AppTheme.appTheme.headline1(
                          fontWeight: FontWeight.normal, fontSize: 16),
                      containerDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: AppTheme.appTheme.containerBackgroundColor()),
                      numDecoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: AppTheme.appTheme.cardBackgroundColor(),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: AppTheme.appTheme.containerBoxShadow()),
                      numTextStyle: AppTheme.appTheme
                          .themeText(fontWeight: FontWeight.bold, fontSize: 15),
                      onValueChanged: (value) {
                        setState(() {
                          code = value;
                        });
                      },
                    ),
                  ),
                ),
                SlideTransition(
                  position: Tween<Offset>(begin: Offset(2, 0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _animationController,
                          curve:
                              Interval(0.6, 0.8, curve: Curves.fastOutSlowIn))),
                  child: GestureDetector(
                    onTap: () {
                      if (!hasPhone()) {
                        return;
                      }
                      if (timer != null && timer.isActive) {
                        return;
                      }
                      Future.delayed(Duration(seconds: 2), () {
                        FlashHelper.toast(context, "Send success");
                      });
                    },
                    onDoubleTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: hasPhone()
                              ? AppTheme.appTheme.grandientColorEnd()
                              : AppTheme.appTheme
                                  .grandientColorEnd()
                                  .withOpacity(0.5)),
                      child: Text(
                        sendText,
                        style: AppTheme.appTheme.headline1(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            textColor: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.8, 1, curve: Curves.fastOutSlowIn),
              )),
              child: GestureDetector(
                onTap: () {
                  FlashHelper.toast(context, '登录成功');
                  User user = User(Uuid().generateV4(), '', phone);
                  SessionUtils.sharedInstance().login(user);
                  Navigator.of(context).pop();
                },
                onDoubleTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  width: 220,
                  decoration: BoxDecoration(
                      boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                      gradient: hasPhoneAndCode()
                          ? AppTheme.appTheme.containerGradient()
                          : AppTheme.appTheme
                              .containerGradientWithOpacity(opacity: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  child: Text(
                    'Login',
                    style: AppTheme.appTheme.headline1(
                        textColor: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool hasPhone() {
    return phone.length == 11;
  }

  bool hasPhoneAndCode() {
    return hasPhone() && code.length == 6;
  }
}
