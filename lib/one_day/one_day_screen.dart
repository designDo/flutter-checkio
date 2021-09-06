import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/blocs/user_bloc.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/one_day/habit_list_view.dart';
import 'package:timefly/one_day/one_day_normal_view.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/system_util.dart';

import 'one_day_rate_view.dart';

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
    screenAnimationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
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
    SystemUtil.changeStateBarMode(
        AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark);
    return Container(
      child: BlocBuilder<HabitsBloc, HabitsState>(
        builder: (context, state) {
          if (state is HabitsLoadInProgress) {
            return Container();
          }
          if (state is HabitLoadSuccess) {
            List<OnDayHabitListData> listData = getHabits(state.habits);
            final int count = listData.length;
            return ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  OnDayHabitListData data = listData[index];
                  Widget widget;
                  switch (data.type) {
                    case OnDayHabitListData.typeHeader:
                      widget = TimeAndWordView(
                          animation: Tween<Offset>(
                                  begin: Offset(0, 0.5), end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: screenAnimationController,
                                  curve: Interval((1 / count) * index, 1,
                                      curve: Curves.fastOutSlowIn))),
                          animationController: screenAnimationController);
                      break;
                    case OnDayHabitListData.typeTip:
                      widget = OneDayTipsView(
                        animation:
                            Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: screenAnimationController,
                                    curve: Interval((1 / count) * index, 1,
                                        curve: Curves.fastOutSlowIn))),
                        animationController: screenAnimationController,
                        habitLength: state.habits.length,
                      );
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
                    case OnDayHabitListData.typeRate:
                      widget = OneDayRateView(
                        period: data.value,
                        allHabits: state.habits,
                        animation:
                            Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: screenAnimationController,
                                    curve: Interval((1 / count) * index, 1,
                                        curve: Curves.fastOutSlowIn))),
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
    int weekend = DateTime.now().weekday;
    int dayPeroidHabitCount = habits
        .where((element) =>
            element.period == HabitPeriod.day &&
            element.completeDays.contains(weekend))
        .length;
    int weekPeroidHabitCount =
        habits.where((element) => element.period == HabitPeriod.week).length;
    int monthPeroidHabitCount =
        habits.where((element) => element.period == HabitPeriod.month).length;

    if (dayPeroidHabitCount == 0 &&
        weekPeroidHabitCount == 0 &&
        monthPeroidHabitCount == 0) {
      datas.add(
          OnDayHabitListData(type: OnDayHabitListData.typeTip, value: null));
    } else {
      if (dayPeroidHabitCount > 0) {
        datas.add(OnDayHabitListData(
            type: OnDayHabitListData.typeRate, value: HabitPeriod.day));
      }
      if (weekPeroidHabitCount > 0) {
        datas.add(OnDayHabitListData(
            type: OnDayHabitListData.typeRate, value: HabitPeriod.week));
      }
      if (monthPeroidHabitCount > 0) {
        datas.add(OnDayHabitListData(
            type: OnDayHabitListData.typeRate, value: HabitPeriod.month));
      }
    }
    datas.addAll(HabitUtil.sortByCompleteTime(habits));
    return datas;
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
              style: AppTheme.appTheme
                  .headline2(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
