import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HabitCheckView extends StatefulWidget {
  ///若是今天需要拿todayCheck
  final bool isToday;

  ///根据time获取totalCheck对于的值
  final DateTime time;
  final Habit habit;

  const HabitCheckView({Key key, this.isToday = false, this.time, this.habit})
      : super(key: key);

  @override
  _HabitCheckViewState createState() => _HabitCheckViewState();
}

class _HabitCheckViewState extends State<HabitCheckView> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final SlidableController slidableController = SlidableController();

  List<HabitRecord> todayChecks;

  @override
  void initState() {
    todayChecks = widget.habit.todayCheck;
    if (todayChecks == null) {
      todayChecks = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      body: Container(
        child: AnimatedList(
          key: listKey,
          initialItemCount: todayChecks.length,
          itemBuilder: (context, index, animation) {
            return getCheckItemView(context, todayChecks[index], animation);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          listKey.currentState
              .insertItem(0, duration: const Duration(milliseconds: 500));
          todayChecks.insert(
              0,
              HabitRecord(
                  time: DateTime.now().millisecondsSinceEpoch,
                  content: "aaaa"));
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.check,
          size: 40,
        ),
      ),
    );
  }

  Widget getCheckItemView(
      BuildContext context, HabitRecord record, Animation<dynamic> animation) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
      child: TimelineTile(
        beforeLineStyle: LineStyle(thickness: 2, color: Colors.black26),
        indicatorStyle: IndicatorStyle(
          width: 30,
          color: AppTheme.appTheme.containerBackgroundColor(),
          indicatorXY: 0.5,
          iconStyle: IconStyle(
            color: Colors.red,
            iconData: Icons.check_circle_outline,
          ),
        ),
        alignment: TimelineAlign.manual,
        lineXY: 0.1,
        isFirst: todayChecks.indexOf(record) == 0,
        isLast: todayChecks.indexOf(record) == todayChecks.length - 1,
        endChild: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset(0, 0),
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: Slidable(
            key: GlobalKey(),
            controller: slidableController,
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removeItem(record);
                },
              )
            ],
            child: Container(
                padding: EdgeInsets.only(left: 28),
                height: 128.0,
                child: Card(
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Item item',
                      ),
                    ))),
          ),
        ),
      ),
    );
  }

  void removeItem(HabitRecord record) {
    int index = todayChecks.indexOf(record);
    listKey.currentState.removeItem(
        index, (_, animation) => getCheckItemView(_, record, animation),
        duration: const Duration(milliseconds: 500));
    todayChecks.removeAt(index);
  }
}
