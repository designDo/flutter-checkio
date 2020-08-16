import 'package:flutter/material.dart';
import 'package:timefly/habit_progress/one_day_screen.dart';
import 'package:timefly/one_day/one_day_screen.dart';

import 'app_theme.dart';
import 'models/tabIcon_data.dart';
import 'widget/bottom_bar_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //每个页面显示动画基础
  AnimationController animationController;

  // tab data
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),vsync: this);

    tabBody = OneDayScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            tabBody,
            bottomBar(),
          ],
        ),
      ),
    );
  }

 Widget bottomBar() {
   return Column(
     children: <Widget>[
       const Expanded(
         child: SizedBox(),
       ),
       BottomBarView(
         tabIconsList: tabIconsList,
         addClick: () {},
         changeIndex: (int index) {
           if (index == 0 || index == 2) {
             animationController.reverse().then<dynamic>((data) {
               if (!mounted) {
                 return;
               }
               setState(() {
                 tabBody =
                     OneDayScreen(animationController: animationController);
               });
             });
           } else if (index == 1 || index == 3) {
             animationController.reverse().then<dynamic>((data) {
               if (!mounted) {
                 return;
               }
               setState(() {
                 tabBody =
                     HabitProgressScreen(animationController: animationController);
               });
             });
           }
         },
       ),
     ],
   );

 }
}
