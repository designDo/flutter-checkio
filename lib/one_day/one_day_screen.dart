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
import 'package:timefly/one_day/habit_item_view.dart';
import 'package:timefly/utils/habit_util.dart';

class OneDayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OneDayScreenState();
  }
}

class _OneDayScreenState extends State<OneDayScreen>
    with TickerProviderStateMixin {
  AnimationController headerController;
  Animation<Offset> headerAnimation;
  AnimationController tipController;
  Animation<Offset> tipAnimation;

  @override
  void initState() {
    headerController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    headerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        tipController.forward();
      }
    });
    headerAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: headerController, curve: Curves.decelerate));
    tipController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    tipAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: tipController, curve: Curves.decelerate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<HabitsBloc, HabitsState>(
        builder: (context, state) {
          if (state is HabitsLoadInProgress) {
            return Container();
          }
          if (state is HabitLoadSuccess) {
            List<OnDayHabitListData> listData = getHabits((state).habits);
            print('HabitLoadSuccess ListData');
            headerController.forward();
            return ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  OnDayHabitListData data = listData[index];
                  Widget widget;
                  switch (data.type) {
                    case OnDayHabitListData.typeHeader:
                      widget = getHeaderView();
                      break;
                    case OnDayHabitListData.typeTip:
                      widget = getTipsView();
                      break;
                    case OnDayHabitListData.typeTitle:
                      widget = getTitleView(data.value);
                      break;
                    case OnDayHabitListData.typeHabit:
                      widget = HabitItemView(
                        habit: data.value,
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

  Widget getHeaderView() {
    return AnimatedBuilder(
      animation: headerController,
      builder: (context, child) {
        return SlideTransition(
          position: headerAnimation,
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

  Widget getTipsView() {
    return AnimatedBuilder(
      animation: tipController,
      builder: (context, child) {
        return SlideTransition(
          position: tipAnimation,
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
                          color: AppTheme.appTheme
                              .gradientColorLight()
                              .withOpacity(0.8),
                          offset: const Offset(13.1, 4.0),
                          blurRadius: 16.0),
                    ],
                    gradient: LinearGradient(
                      colors: <Color>[
                        AppTheme.appTheme.gradientColorLight(),
                        AppTheme.appTheme.gradientColorDark(),
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

  Widget getTitleView(String title) {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 10),
      child: Text(
        title,
        style: AppTheme.appTheme.textStyle(
            textColor: AppTheme.appTheme.textColorSecond(),
            fontWeight: FontWeight.w600,
            fontSize: 15),
      ),
    );
  }
}
