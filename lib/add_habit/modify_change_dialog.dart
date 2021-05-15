import 'package:alarm_plugin/alarm_event.dart';
import 'package:alarm_plugin/alarm_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/flash_helper.dart';

class ModifyChangeDialog extends StatefulWidget {
  final String title;
  final String subTitle;

  const ModifyChangeDialog({
    Key key,
    this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  _ModifyChangeDialogState createState() => _ModifyChangeDialogState();
}

class _ModifyChangeDialogState extends State<ModifyChangeDialog>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.2, end: 1).animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeOutBack)),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: AppTheme.appTheme.containerBoxShadow(),
              color: AppTheme.appTheme.cardBackgroundColor()),
          height: 200,
          margin: EdgeInsets.only(left: 32, right: 32),
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                widget.title,
                style: AppTheme.appTheme
                    .headline1(fontWeight: FontWeight.bold, fontSize: 20)
                    .copyWith(decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                widget.subTitle,
                style: AppTheme.appTheme
                    .headline1(fontWeight: FontWeight.normal, fontSize: 16)
                    .copyWith(decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: AppTheme.appTheme.containerGradient(),
                      boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  width: 150,
                  height: 50,
                  child: Text(
                    '知道啦',
                    style: AppTheme.appTheme
                        .headline1(
                            textColor: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 16)
                        .copyWith(decoration: TextDecoration.none),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
