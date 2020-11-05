import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/all_habits/all_habit_item_view.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/habit_util.dart';

class AllHabitsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllHabitsScreenState();
  }
}

class _AllHabitsScreenState extends State<AllHabitsScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  Habit _selectedHabit;

  List<Habit> habits;

  double _listPadding = 20;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    topBarAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          getMainListViewUI(),
          getAppBarUI(),
        ],
      ),
    );
  }

  Widget getMainListViewUI() {
    //之前动画不显示是主动画没开始，导致初始进度为0
    animationController.forward();
    return BlocBuilder<HabitsBloc, HabitsState>(
      builder: (context, state) {
        if (state is HabitsLoadInProgress) {
          return Container();
        }
        if (state is HabitLoadSuccess) {
          List<Habit> listData = HabitUtil.sortByCreateTime((state).habits);
          if (listData.length > 0) {
            habits = listData;
            return ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: _listPadding / 2, horizontal: _listPadding),
                    child: AllHabitItemView(
                      habit: listData[index],
                      isOpen: listData[index] == _selectedHabit,
                      onTap: _handleHabitTapped,
                    ),
                  );
                },
                itemCount: listData.length,
                controller: scrollController,
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      24,
                  bottom: MediaQuery.of(context).padding.bottom,
                ));
          }
        }
        return Container();
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '所有习惯',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: GestureDetector(
                                onTap: () {
                                  print('add habit');
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  void _handleHabitTapped(Habit data) {
    setState(() {
      //If the same habit was tapped twice, un-select it
      if (_selectedHabit == data) {
        _selectedHabit = null;
      }
      //Open tapped habit card and scroll to it
      else {
        _selectedHabit = data;
        var selectedIndex = habits.indexOf(_selectedHabit);
        var closedHeight = AllHabitItemView.nominalHeightClosed;
        //Calculate scrollTo offset, subtract a bit so we don't end up perfectly at the top
        var offset =
            selectedIndex * (closedHeight + _listPadding) - closedHeight * .35;
        scrollController.animateTo(offset,
            duration: Duration(milliseconds: 700), curve: Curves.easeOutQuad);
      }
    });
  }
}
