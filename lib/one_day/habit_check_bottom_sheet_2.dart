import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timefly/add_habit/edit_name.dart';
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
  final ScrollController scrollController = ScrollController();

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
          controller: scrollController,
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
          scrollController.animateTo(0,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
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
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 28),
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
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 16),
                        child: Text(
                          'AAAAAAAA',
                          style: AppTheme.appTheme.textStyle(
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          editNote(context, record);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color:
                                  AppTheme.appTheme.containerBackgroundColor()),
                          alignment: Alignment.topLeft,
                          width: double.infinity,
                          constraints: BoxConstraints(minHeight: 80),
                          child: Text(
                            '${record.content}',
                            style: AppTheme.appTheme.textStyle(
                                textColor: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  )),
            ),
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

  void editNote(BuildContext context, HabitRecord record) async {
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, ani1, ani2) {
          return EditNameView(
            habitRecord: record,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Animation<double> myAnimation = Tween<double>(begin: 0, end: 1.0)
              .animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutSine,
                  reverseCurve: Interval(0, 0.5, curve: Curves.easeInSine)));
          return Transform(
            transform:
                Matrix4.translationValues(0, 100 * (1 - myAnimation.value), 0),
            child: FadeTransition(
              opacity: myAnimation,
              child: child,
            ),
          );
        }));
  }
}
