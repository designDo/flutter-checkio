import 'package:flutter/material.dart';
import 'package:timefly/add_habit/add_habit_page.dart';
import 'package:timefly/utils/hex_color.dart';

class HabitAddSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HabitAddSheet();
  }
}

class _HabitAddSheet extends State<HabitAddSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <HexColor>[
              HexColor('#7971C4'),
              HexColor('#8389E9'),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: AddHabitPageView(),
            ),
          ],
        ),
      ),
    );
  }
}
