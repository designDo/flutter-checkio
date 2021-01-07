import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/add_habit/habit_edit_page.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:timefly/notification/notification_plugin.dart';
import 'package:timefly/one_day/habit_list_view.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/system_util.dart';

class OneDayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OneDayScreenState();
  }
}

class _OneDayScreenState extends State<OneDayScreen>
    with TickerProviderStateMixin {
  ///整个页面动画控制器
  AnimationController screenAnimationController;

  @override
  void initState() {
    screenAnimationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    screenAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    screenAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemUtil.changeStateBarMode(Brightness.dark);
    return Container(
      child: BlocBuilder<HabitsBloc, HabitsState>(
        builder: (context, state) {
          if (state is HabitsLoadInProgress) {
            return Container();
          }
          if (state is HabitLoadSuccess) {
            List<OnDayHabitListData> listData = getHabits((state).habits);
            print('HabitLoadSuccess ListData');
            final int count = listData.length;
            return ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  OnDayHabitListData data = listData[index];
                  Widget widget;
                  switch (data.type) {
                    case OnDayHabitListData.typeHeader:
                      widget = getHeaderView(
                          Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: screenAnimationController,
                                  curve: Interval((1 / count) * index, 1,
                                      curve: Curves.fastOutSlowIn))),
                          screenAnimationController);
                      break;
                    case OnDayHabitListData.typeTip:
                      widget = getTipsView(
                          Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: screenAnimationController,
                                  curve: Interval((1 / count) * index, 1,
                                      curve: Curves.fastOutSlowIn))),
                          screenAnimationController);
                      break;
                    case OnDayHabitListData.typeTitle:
                      widget = getTitleView(
                          data.value,
                          Tween<double>(begin: 0, end: 1).animate(
                              CurvedAnimation(
                                  parent: screenAnimationController,
                                  curve: Interval((1 / count) * index, 1,
                                      curve: Curves.fastOutSlowIn))),
                          screenAnimationController);
                      break;
                    case OnDayHabitListData.typeHabits:
                      widget = HabitListView(
                        mainScreenAnimation: Tween<double>(begin: 0, end: 1)
                            .animate(CurvedAnimation(
                                parent: screenAnimationController,
                                curve: Interval((1 / count) * index, 1,
                                    curve: Curves.fastOutSlowIn))),
                        mainScreenAnimationController:
                            screenAnimationController,
                        habits: data.value,
                      );
                      break;
                  }
                  return widget;
                });
          }
          return Container();
        },
      ),
    );
  }

  List<OnDayHabitListData> getHabits(List<Habit> habits) {
    List<OnDayHabitListData> datas = [];
    datas.add(
        OnDayHabitListData(type: OnDayHabitListData.typeHeader, value: null));
    datas
        .add(OnDayHabitListData(type: OnDayHabitListData.typeTip, value: null));
    datas.addAll(HabitUtil.sortByCompleteTime(habits));
    return datas;
  }

  Widget getHeaderView(
      Animation animation, AnimationController animationController) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: animation,
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 40, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    await NotificationPlugin.getInstance()
                        .scheduleNotification();
                  },
                  child: Text(
                    'Hello,Good Morning',
                    style: AppTheme.appTheme.textStyle(),
                  ),
                ),
                Text(
                  'You have 7 habits last !!',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getTipsView(
      Animation animation, AnimationController animationController) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: animation,
          child: GestureDetector(
            onTap: () async {
              Habit newHabit = await Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (context) {
                return HabitEditPage();
              }));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0xFF738AE6).withOpacity(0.8),
                          offset: const Offset(13.1, 4.0),
                          blurRadius: 16.0),
                    ],
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF738AE6),
                        Color(0xFF5C5EDD),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Text(
                  'You can add a habit Here!!!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getTitleView(String title, Animation animation,
      AnimationController animationController) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Container(
            margin: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              title,
              style: AppTheme.appTheme.textStyle(
                  textColor: AppTheme.appTheme.textColorSecond(),
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
