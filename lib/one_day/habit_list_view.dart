import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/one_day/habit_check_view.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/widget/circle_progress_bar.dart';
import 'package:timefly/widget/float_modal.dart';

class HabitListView extends StatefulWidget {
  ///主页动画控制器，整体ListView的显示动画
  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  final List<Habit> habits;

  const HabitListView(
      {Key key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.habits})
      : super(key: key);

  @override
  _HabitListViewState createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0, 30 * (1.0 - widget.mainScreenAnimation.value), 0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  itemCount: widget.habits.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final int count =
                        widget.habits.length > 10 ? 10 : widget.habits.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController.forward();

                    return HabitView(
                      key: GlobalKey(),
                      habit: widget.habits[index],
                      animationController: animationController,
                      animation: animation,
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}

class HabitView extends StatefulWidget {
  final Habit habit;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  const HabitView(
      {Key key, this.habit, this.animationController, this.animation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HabitView();
  }
}

class _HabitView extends State<HabitView> with SingleTickerProviderStateMixin {
  AnimationController tapAnimationController;
  Animation<double> tapAnimation;

  int _initValue = 0;
  int _maxValue = 1;

  @override
  void initState() {
    tapAnimationController =
        AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    tapAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        tapAnimationController.reverse();
      }
    });
    tapAnimation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
        parent: tapAnimationController, curve: Curves.fastOutSlowIn));
    setCheckValue();
    super.initState();
  }

  DateTime start;
  DateTime end;

  void setCheckValue() {
    DateTime now = DateTime.now();
    switch (widget.habit.period) {
      case HabitPeriod.day:
        start = DateUtil.startOfDay(now);
        end = DateUtil.endOfDay(now);
        break;
      case HabitPeriod.week:
        start = DateUtil.firstDayOfWeekend(DateTime.now());
        end = DateUtil.endOfDay(DateTime.now());
        break;
      case HabitPeriod.month:
        start = DateUtil.firstDayOfMonth(now);
        end = DateUtil.endOfDay(now);
        break;
    }
    _initValue = HabitUtil.filterHabitRecordsWithTime(widget.habit.records,
            start: start, end: end)
        .length;
    _maxValue = widget.habit.doNum;
    if (_initValue > _maxValue) {
      _maxValue = _initValue;
    }
  }

  @override
  void dispose() {
    tapAnimationController.dispose();
    super.dispose();
  }

  _showCheckBottomSheet() async {
    await showFloatingModalBottomSheet(
        barrierColor: Colors.black87,
        context: context,
        builder: (context) {
          return HabitCheckView(
            habitId: widget.habit.id,
            isFromDetail: false,
            start: start,
            end: end,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - widget.animation.value), 0.0, 0.0),
            child: ScaleTransition(
              scale: tapAnimation,
              child: GestureDetector(
                onTap: () async {
                  tapAnimationController.forward();
                  Future.delayed(Duration(milliseconds: 300), () async {
                    /// return today check List<int>
                    _showCheckBottomSheet();
                  });
                },
                onLongPress: () {
                  tapAnimationController.forward();
                },
                onDoubleTap: () {},
                child: Container(
                  width: 130,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.appTheme.cardBackgroundColor(),
                        boxShadow: AppTheme.appTheme.containerBoxShadow(),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(28.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10, top: 10, bottom: 10, right: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 6),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Color(widget.habit.mainColor)
                                                .withOpacity(0.3),
                                            offset: Offset(0, 7),
                                            blurRadius: 10)
                                      ],
                                      shape: BoxShape.circle,
                                      color: Color(widget.habit.mainColor)
                                          .withOpacity(0.5)),
                                  width: 45,
                                  height: 45,
                                  child: Image.asset(widget.habit.iconPath),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(3)),
                                      color: Color(widget.habit.mainColor)),
                                  child: Text(
                                    '${HabitPeriod.getPeriod(widget.habit.period)}',
                                    style: AppTheme.appTheme.headline1(
                                        fontSize: 11,
                                        textColor: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 45,
                              child: Text(
                                '${widget.habit.name}',
                                maxLines: 2,
                                style: AppTheme.appTheme.headline1(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              getReminderTime(),
                              style: AppTheme.appTheme
                                  .numHeadline2(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                      '$_initValue/${widget.habit.doNum}',
                                      maxLines: 1,
                                      style: AppTheme.appTheme
                                          .numHeadline1(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircleProgressBar(
                                      backgroundColor: AppTheme.appTheme
                                          .containerBackgroundColor(),
                                      foregroundColor:
                                          Color(widget.habit.mainColor),
                                      value: _initValue / _maxValue),
                                )),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String getReminderTime() {
    return (widget.habit.remindTimes == null ||
            widget.habit.remindTimes.length == 0)
        ? ''
        : '${widget.habit.remindTimes[0]}';
  }
}
