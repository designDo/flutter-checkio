import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/add_habit/edit_name.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/record_bloc.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:time/time.dart';

class HabitCheckView extends StatefulWidget {
  ///首页签到进入，start 和 end 是一个周期，而详情进入是某一天，需要单独判断
  final bool isFromDetail;
  final DateTime start;
  final DateTime end;

  final String habitId;

  const HabitCheckView(
      {Key key, this.habitId, this.start, this.end, this.isFromDetail})
      : super(key: key);

  @override
  _HabitCheckViewState createState() => _HabitCheckViewState();
}

class _HabitCheckViewState extends State<HabitCheckView> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final SlidableController slidableController = SlidableController();
  final ScrollController scrollController = ScrollController();

  List<HabitRecord> habitRecords = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordBloc(BlocProvider.of<HabitsBloc>(context))
        ..add(RecordLoad(widget.habitId, widget.start, widget.end)),
      child: BlocBuilder<RecordBloc, RecordState>(
        builder: (context, state) {
          if (state is RecordLoadSuccess) {
            habitRecords = HabitUtil.filterHabitRecordsWithTime(state.records,
                start: widget.start, end: widget.end);
            return Scaffold(
              backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
              body: Stack(
                children: [
                  Container(
                    child: AnimatedList(
                      key: listKey,
                      padding: EdgeInsets.only(top: 50, bottom: 16),
                      controller: scrollController,
                      initialItemCount: habitRecords.length,
                      itemBuilder: (context, index, animation) {
                        return getCheckItemView(
                            context, habitRecords[index], animation);
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(right: 16, top: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset(
                        'assets/images/guanbi.svg',
                        color: AppTheme.appTheme.normalColor(),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  int checkTime;
                  if (widget.isFromDetail) {
                    ///判断是否为当天
                    ///当天，time: DateTime.now().millisecondsSinceEpoch
                    ///N天 time: DateTime.now().copyWith(start.year,start.month,satrt.day).millisecondsSinceEpoch
                    ///即是 N天年月日 and 此时的时分秒
                    if (DateUtil.isToday(widget.start.millisecondsSinceEpoch)) {
                      checkTime = DateTime.now().millisecondsSinceEpoch;
                    } else {
                      checkTime = DateTime.now()
                          .copyWith(
                              year: widget.start.year,
                              month: widget.start.month,
                              day: widget.start.day)
                          .millisecondsSinceEpoch;
                    }
                  } else {
                    checkTime = DateTime.now().millisecondsSinceEpoch;
                  }

                  HabitRecord record = HabitRecord(
                    habitId: widget.habitId,
                    time: checkTime,
                    content: '',
                  );

                  BlocProvider.of<RecordBloc>(context).add(RecordAdd(record));
                  listKey.currentState.insertItem(0,
                      duration: const Duration(milliseconds: 500));

                  scrollController.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                },
                backgroundColor: AppTheme.appTheme.grandientColorEnd(),
                child: SvgPicture.asset(
                  'assets/images/jia.svg',
                  color: Colors.white,
                  width: 40,
                  height: 40,
                ),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget getCheckItemView(
      BuildContext context, HabitRecord record, Animation<dynamic> animation) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
      child: TimelineTile(
        beforeLineStyle: LineStyle(
            thickness: 2,
            color: AppTheme.appTheme.normalColor().withOpacity(0.5)),
        indicatorStyle: IndicatorStyle(
          width: 35,
          color: AppTheme.appTheme.containerBackgroundColor(),
          indicatorXY: 0.5,
          iconStyle: IconStyle(
            color: AppTheme.appTheme.normalColor(),
            iconData: Icons.check_circle_outline,
          ),
        ),
        alignment: TimelineAlign.manual,
        lineXY: 0.1,
        isFirst: habitRecords.indexOf(record) == 0,
        isLast: habitRecords.indexOf(record) == habitRecords.length - 1,
        endChild: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset(0, 0),
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20, left: 28),
            child: Slidable(
              key: GlobalKey(),
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: [
                GestureDetector(
                  onTap: () async {
                    removeItem(context, record);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.redAccent.withOpacity(0.35),
                                offset: const Offset(2, 2.0),
                                blurRadius: 6.0),
                          ],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.red),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: AppTheme.appTheme.cardBackgroundColor(),
                      boxShadow: AppTheme.appTheme.containerBoxShadow()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 16),
                        child: Text(
                          '${DateUtil.parseHourAndMinAndSecond(record.time)}',
                          style: AppTheme.appTheme.numHeadline1(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24),
                        child: Text(
                          '${DateUtil.parseYearAndMonthAndDay(record.time)}',
                          style: AppTheme.appTheme.numHeadline2(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
                          constraints: BoxConstraints(minHeight: 60),
                          child: Text(
                            '${record.content.length == 0 ? '记录些什么...' : record.content}',
                            style: record.content.length == 0
                                ? AppTheme.appTheme.headline2(
                                    fontSize: 16, fontWeight: FontWeight.w500)
                                : AppTheme.appTheme.headline1(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void removeItem(BuildContext context, HabitRecord record) async {
    BlocProvider.of<RecordBloc>(context)
        .add(RecordDelete(widget.habitId, record.time));

    int index = habitRecords.indexOf(record);
    listKey.currentState.removeItem(
        index, (_, animation) => getCheckItemView(_, record, animation),
        duration: const Duration(milliseconds: 500));
  }

  void editNote(BuildContext context, HabitRecord record) async {
    Mutable<String> content = Mutable(record.content);
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, ani1, ani2) {
          return EditFiledView(
            content: content,
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
    BlocProvider.of<RecordBloc>(context).add(RecordUpdate(record.copyWith(
        habitId: record.habitId, time: record.time, content: content.value)));
  }
}
