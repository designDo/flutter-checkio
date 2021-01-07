import 'package:flutter/material.dart';
import 'package:timefly/all_habits/all_habit_item_view.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';

class AllHabitListView extends StatefulWidget {
  final int completeTime;

  const AllHabitListView({Key key, this.completeTime}) : super(key: key);

  @override
  _AllHabitListViewState createState() => _AllHabitListViewState();
}

class _AllHabitListViewState extends State<AllHabitListView>
    with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();

  Habit _selectedHabit;

  List<Habit> habits;

  double _listPadding = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: FutureBuilder<List<Habit>>(
        future:
            DatabaseProvider.db.getHabitsWithCompleteTime(widget.completeTime),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            habits = snapshot.data;
            return ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: _listPadding / 2, horizontal: 8),
                    child: AllHabitItemView(
                      habit: habits[index],
                      isOpen: habits[index] == _selectedHabit,
                      onTap: _handleHabitTapped,
                    ),
                  );
                },
                itemCount: habits.length,
                controller: scrollController,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ));
          }
          return Container();
        },
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
        var selectedIndex = habits.indexOf(_selectedHabit);
        var closedHeight = AllHabitItemView.nominalHeightClosed;
        //Calculate scrollTo offset, subtract a bit so we don't end up perfectly at the top
        var offset =
            selectedIndex * (closedHeight + _listPadding) - closedHeight * .35;
        scrollController.animateTo(offset,
            duration: Duration(milliseconds: 700), curve: Curves.easeOutQuad);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
