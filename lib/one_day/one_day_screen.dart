import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timefly/add_habit/habit_add_sheet.dart';
import 'package:timefly/add_habit/habit_edit_page.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/one_day/habit_item_view.dart';
import 'package:timefly/utils/hex_color.dart';
import 'package:timefly/widget/float_modal.dart';

class OneDayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OneDayScreenState();
  }
}

class _OneDayScreenState extends State<OneDayScreen>
    with TickerProviderStateMixin {
  AnimationController headerController;
  Animation<Offset> headerAnimation;
  AnimationController tipController;
  Animation<Offset> tipAnimation;

  @override
  void initState() {
    headerController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    headerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        tipController.forward();
      }
    });
    headerAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: headerController, curve: Curves.decelerate));
    tipController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    tipAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: tipController, curve: Curves.decelerate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getListData(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SizedBox();
          }
          List<ListData> listData = snapshot.data;
          headerController.forward();
          return ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                ListData data = listData[index];
                Widget widget;
                switch (data.type) {
                  case ListData.typeHeader:
                    widget = getHeaderView();
                    break;
                  case ListData.typeTip:
                    widget = getTipsView();
                    break;
                  case ListData.typeTitle:
                    widget = Text('title');
                    break;
                  case ListData.typeHabit:
                    widget = HabitItemView(habit: data.value,);
                    break;
                }
                return widget;
              });
        },
      ),
    );
  }

  ///获取列表所有数据
  Future<List<ListData>> getListData() async {
    List<ListData> datas = [];
    datas.add(ListData(type: ListData.typeHeader, value: null));
    var habits = await DatabaseProvider.db.getHabits();
    if (habits.length > 0) {
      datas.add(ListData(type: ListData.typeTip, value: habits.length));
      for (var habit in habits) {
        datas.add(ListData(type: ListData.typeHabit, value: habit));
      }
    } else {
      datas.add(ListData(type: ListData.typeTip, value: null));
    }
    return datas;
  }

  Widget getHeaderView() {
    return AnimatedBuilder(
      animation: headerController,
      builder: (context, child) {
        return SlideTransition(
          position: headerAnimation,
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 40, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,Good Morning',
                  style: AppTheme.appTheme.textStyle(),
                ),
                Text(
                  'You have 7 habits last !!',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getTipsView() {
    return AnimatedBuilder(
      animation: tipController,
      builder: (context, child) {
        return SlideTransition(
          position: tipAnimation,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                return HabitEditPage();
              }));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.appTheme
                              .gradientColorLight()
                              .withOpacity(0.8),
                          offset: const Offset(13.1, 4.0),
                          blurRadius: 16.0),
                    ],
                    gradient: LinearGradient(
                      colors: <Color>[
                        AppTheme.appTheme.gradientColorLight(),
                        AppTheme.appTheme.gradientColorDark(),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Text(
                  'You can add a habit Here!!!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ListData {
  static const int typeHeader = 0;
  static const int typeTip = 1;
  static const int typeTitle = 2;
  static const int typeHabit = 3;

  final int type;
  final dynamic value;

  const ListData({this.type, this.value});
}
