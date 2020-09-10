import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timefly/add_habit/habit_add_sheet.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/db/database_provider.dart';
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
      color: AppTheme.background,
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
                    widget = Text('habit');
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
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Theme.of(context).primaryColor),
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
              showFloatingModalBottomSheet(
                  context: context,
                  builder: (context, scrollController) {
                    return HabitAddSheet();
                  },
                  barrierColor: HexColor("#435269"));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: HexColor('#738AE6').withOpacity(0.6),
                          offset: const Offset(1.1, 4.0),
                          blurRadius: 8.0),
                    ],
                    gradient: LinearGradient(
                      colors: <HexColor>[
                        HexColor('#5C5EDD'),
                        HexColor('#738AE6'),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
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
