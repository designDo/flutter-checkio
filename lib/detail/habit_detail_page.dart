import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/utils/system_util.dart';

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
        shadowColor: Colors.black.withOpacity(0.3),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
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
