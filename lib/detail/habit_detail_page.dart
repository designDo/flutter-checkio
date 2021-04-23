import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timefly/add_habit/habit_edit_page.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/detail/habit_detail_views.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/system_util.dart';

///detail page
class HabitDetailPage extends StatefulWidget {
  final String habitId;

  const HabitDetailPage({Key key, this.habitId}) : super(key: key);

  @override
  _HabitDetailPageState createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage>
    with SingleTickerProviderStateMixin {
  ScrollController _controller;
  AnimationController _animationController;

  @override
  void initState() {
    _controller = ScrollController();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    Future.delayed(Duration(milliseconds: 300), () {
      _animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUtil.getSystemUiOverlayStyle(
          AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark),
      child: BlocBuilder<HabitsBloc, HabitsState>(
        builder: (context, state) {
          if (state is HabitsLoadInProgress) {
            return CircularProgressIndicator();
          }
          if (state is HabitLoadSuccess) {
            final Habit habit = state.habits
                .firstWhere((element) => element.id == widget.habitId);
            return _body(habit);
          }
          return Container();
        },
      ),
    );
  }

  Widget _body(Habit habit) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            iconSize: 32,
            padding: EdgeInsets.all(14),
            icon: SvgPicture.asset(
              'assets/images/fanhui.svg',
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: AppTheme.appTheme.isDark()
            ? AppTheme.appTheme.cardBackgroundColor()
            : Color(habit.mainColor).withOpacity(0.8),
        actions: [
          IconButton(
            iconSize: 33,
            padding: EdgeInsets.all(16),
            icon: SvgPicture.asset(
              'assets/images/bianji.svg',
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (context) {
                return HabitEditPage(
                  isModify: true,
                  habit: habit,
                );
              }));
            },
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(2),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1)),
              child: Image.asset(habit.iconPath),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              habit.name,
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      body: CustomScrollView(
        controller: _controller,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              HabitBaseInfoView(
                habit: habit,
                animationController: _animationController,
              ),
              HabitCompleteRateView(
                habit: habit,
                animationController: _animationController,
              ),
              HabitMonthInfoView(
                habit: habit,
                animationController: _animationController,
              ),
              HabitCheckInfoView(
                habit: habit,
                animationController: _animationController,
              ),
              HabitUtil.containAllDay(habit)
                  ? HabitStreakInfoView(
                      habit: habit,
                      animationController: _animationController,
                    )
                  : SizedBox(),
              HabitRecentRecordsView(
                habit: habit,
              ),
              Container(
                height: 100,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
