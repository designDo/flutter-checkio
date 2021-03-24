import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timefly/add_habit/habit_edit_page.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/detail/habit_detail_views.dart';
import 'package:timefly/models/habit.dart';

///detail page
class HabitDetailPage extends StatefulWidget {
  final Habit habit;

  const HabitDetailPage({Key key, this.habit}) : super(key: key);

  @override
  _HabitDetailPageState createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
        backgroundColor: Color(widget.habit.mainColor).withOpacity(0.8),
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
                  habit: widget.habit,
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
              child: Image.asset(widget.habit.iconPath),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              widget.habit.name,
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
            delegate: SliverChildListDelegate(
              [
                HabitBaseInfoView(habit: widget.habit,)
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _spaceBarBg() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: <Color>[
          Color(0xFF738AE6),
          Color(0xFF5C5EDD),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      height: 300,
    );
  }
}
