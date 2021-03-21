import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timefly/add_habit/habit_edit_page.dart';
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
        leading: Container(
          margin: EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SvgPicture.asset(
              'assets/images/fanhui.svg',
              color: Colors.white,
            ),
          ),
        ),
        leadingWidth: 42,
        backgroundColor: Color(widget.habit.mainColor).withOpacity(0.8),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (context) {
                  return HabitEditPage(
                    isModify: true,
                    habit: widget.habit,
                  );
                }));
              },
              child: SvgPicture.asset(
                'assets/images/bianji.svg',
                color: Colors.white,
                width: 26,
                height: 26,
              ),
            ),
          )
        ],
        title: Text(widget.habit.name),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _controller,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(List.generate(
                30,
                (index) => Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.wb_sunny),
                        title: Text('Monday'),
                        subtitle: Text('sunny, h: 80, l: 65'),
                      ),
                    ))),
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
