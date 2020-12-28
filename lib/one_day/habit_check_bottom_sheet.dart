import 'package:flutter/material.dart';
import 'package:timefly/add_habit/edit_field_container.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/utils/date_util.dart';

class HabitCheckView extends StatefulWidget {
  final Habit habit;

  const HabitCheckView({Key key, this.habit}) : super(key: key);

  @override
  _HabitCheckViewState createState() => _HabitCheckViewState();
}

class _HabitCheckViewState extends State<HabitCheckView> {
  final GlobalKey<AnimatedListState> checkTimeListKey =
      GlobalKey<AnimatedListState>();
  List<int> todayChecks = [];

  String note;

  @override
  void initState() {
    if (widget.habit.todayChek != null) {
      todayChecks.addAll(widget.habit.todayChek);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(
              height: 26,
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 6),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color:
                                Color(widget.habit.mainColor).withOpacity(0.3),
                            offset: Offset(0, 7),
                            blurRadius: 10)
                      ],
                      shape: BoxShape.circle,
                      color: Color(widget.habit.mainColor).withOpacity(0.5)),
                  width: 60,
                  height: 60,
                  child: Image.asset(widget.habit.iconPath),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: Color(widget.habit.mainColor)),
                  child: Text(
                    '${HabitPeroid.getPeroid(widget.habit.period)}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              margin: EdgeInsets.only(left: 26),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Text(
                    'Today Check',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    '(Long Press Delete)',
                    style: AppTheme.appTheme.textStyle(
                        textColor: Colors.black45,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            checkListView(),
            EditFiledContainer(
              editType: 2,
              initValue: '',
              hintValue: "记录些什么...",
              onValueChanged: (value) {
                note = value;
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'times': _onAdd(DateTime.now().millisecondsSinceEpoch),
                  'note': note
                });
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }

  Widget checkListView() {
    if (todayChecks.length == 0) {
      return Container();
    }
    return Container(
      height: 55,
      child: AnimatedList(
          key: checkTimeListKey,
          padding: EdgeInsets.only(left: 16, right: 16),
          scrollDirection: Axis.horizontal,
          initialItemCount: todayChecks.length,
          itemBuilder: (context, index, animation) {
            return CheckTiemView(
              key: GlobalKey(),
              time: todayChecks[index],
              animation: animation,
              onDelete: _onDelete,
            );
          }),
    );
  }

  void _onDelete(int time) {
    int index = todayChecks.indexOf(time);
    checkTimeListKey.currentState.removeItem(
        index,
        (context, animation) => CheckTiemView(
              key: GlobalKey(),
              time: time,
              animation: animation,
            ),
        duration: Duration(milliseconds: 500));
    todayChecks.removeAt(index);
  }

  List<int> _onAdd(int time) {
    return []
      ..add(time)
      ..addAll(todayChecks);
  }
}

///长按显示删除按钮
class CheckTiemView extends StatefulWidget {
  final int time;
  final Animation<dynamic> animation;
  final Function(int time) onDelete;

  const CheckTiemView({Key key, this.time, this.onDelete, this.animation})
      : super(key: key);

  @override
  _CheckTiemViewState createState() => _CheckTiemViewState();
}

class _CheckTiemViewState extends State<CheckTiemView>
    with TickerProviderStateMixin {
  AnimationController transAnimationController;
  AnimationController scaleAnimationController;

  @override
  void initState() {
    transAnimationController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    scaleAnimationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    transAnimationController.dispose();
    scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.animation,
      child: SizeTransition(
        axis: Axis.horizontal,
        sizeFactor: widget.animation,
        child: GestureDetector(
          onLongPress: () {
            transAnimationController.repeat(reverse: true);
            scaleAnimationController.forward();
          },
          onTap: () {
            transAnimationController.reset();
            scaleAnimationController.reverse();
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              AnimatedBuilder(
                animation: transAnimationController,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.translationValues(
                        0, transAnimationController.value * 15, 0),
                    child: Container(
                      margin: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Colors.blueAccent, width: 3)),
                      alignment: Alignment.center,
                      width: 80,
                      height: 40,
                      child: Text(
                        '${DateUtil.parseHourAndMin(widget.time)}',
                        style: AppTheme.appTheme.textStyle(
                            textColor: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
              ScaleTransition(
                scale: CurvedAnimation(
                    parent: scaleAnimationController,
                    curve: Curves.fastOutSlowIn),
                child: GestureDetector(
                  onTap: () {
                    transAnimationController.reset();
                    widget.onDelete(widget.time);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Colors.blueAccent),
                      alignment: Alignment.center,
                      width: 23,
                      height: 23,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 23,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
