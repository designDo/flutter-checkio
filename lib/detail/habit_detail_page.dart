import 'package:flutter/material.dart';
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
    _controller.addListener(() {
      setState(() {});
    });
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
      body: Stack(
        children: [
          CustomScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.blueAccent,
                pinned: true,
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  centerTitle: false,
                  title: Text(
                    'Flight Report',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                  background: Container(
                    alignment: Alignment.center,
                    color: Colors.redAccent,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(List.generate(
                    30,
                    (index) => ListTile(
                          leading: Icon(Icons.wb_sunny),
                          title: Text('Monday'),
                          subtitle: Text('sunny, h: 80, l: 65'),
                        ))),
              ),
            ],
          ),
          _buildFab(),
        ],
      ),
    );
  }

  Widget _buildFab() {
    double top = 300.0 - 40;
    double scale = 1.0;
    if (_controller.hasClients) {
      double offset = _controller.offset;
      top -= offset;
      if (offset < 230 && offset > 0) {
        //offset small => don't scale down
        scale = 1.0 - (offset / 230);
      } else if (230 < offset) {
        //offset between scaleStart and scaleEnd => scale down
        scale = 0;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 1.0;
      }
    }
    return Positioned(
      top: top,
      left: 16.0,
      child: new Transform(
        transform: new Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: new FloatingActionButton(
          onPressed: () => {},
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
}
