import 'package:flutter/material.dart';
import 'package:timefly/all_habits/all_habit_item_view.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';

class AllHabitListView extends StatefulWidget {
  final List<Habit> habits;

  const AllHabitListView({Key key, this.habits}) : super(key: key);

  @override
  _AllHabitListViewState createState() => _AllHabitListViewState();
}

class _AllHabitListViewState extends State<AllHabitListView>
    with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();

  Habit _selectedHabit;

  double _listPadding = 16;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ClipPath(
      clipper: TopClipper(),
      child: Container(
        margin: EdgeInsets.only(top: 6),
        child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: _listPadding / 2,
                ),
                child: AllHabitItemView(
                  habit: widget.habits[index],
                  isOpen: widget.habits[index] == _selectedHabit,
                  onTap: _handleHabitTapped,
                ),
              );
            },
            itemCount: widget.habits.length,
            controller: scrollController,
            padding: EdgeInsets.only(
              top: 3,
              bottom: MediaQuery.of(context).padding.bottom,
            )),
      ),
    );
  }

  void _handleHabitTapped(Habit data) {
    setState(() {
      //If the same habit was tapped twice, un-select it
      if (_selectedHabit == data) {
        _selectedHabit = null;
      }
      //Open tapped habit card and scroll to it
      else {
        _selectedHabit = data;
        var selectedIndex = widget.habits.indexOf(_selectedHabit);
        var closedHeight = AllHabitItemView.nominalHeightClosed;
        //Calculate scrollTo offset, subtract a bit so we don't end up perfectly at the top
        var offset =
            selectedIndex * (closedHeight + _listPadding) - closedHeight * .8;
        scrollController.animateTo(offset,
            duration: Duration(milliseconds: 700), curve: Curves.easeOutQuad);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 20);
    var point0 = Offset(size.width / 2, 0);
    var point1 = Offset(size.width, 20);
    path.quadraticBezierTo(point0.dx, point0.dy, point1.dx, point1.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
