import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_color.dart';

import '../app_theme.dart';

class IconAndColorPage extends StatefulWidget {
  @override
  _IconAndColorPageState createState() => _IconAndColorPageState();
}

class _IconAndColorPageState extends State<IconAndColorPage> {
  List<Icon> icons = [];
  Icon _selectIcon;

  List<HabitColor> backgroundColors = [];
  HabitColor _selectBackgroundColor;

  @override
  void initState() {
    icons = Icon.getIcons();
    _selectIcon = icons[0];
    backgroundColors = HabitColor.getBackgroundColors();
    _selectBackgroundColor = backgroundColors[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              AppTheme.appTheme.addHabitSheetBgLight(),
              AppTheme.appTheme.addHabitSheetBgDark()
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(right: 32, top: 16),
              alignment: Alignment.centerRight,
              child: SvgPicture.asset(
                'assets/images/guanbi.svg',
                color: Colors.white70,
                width: 30,
                height: 30,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              height: 240,
              child: GridView.builder(
                padding: EdgeInsets.only(left: 18),
                itemCount: icons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        icons.forEach((element) {
                          element.isSelect = false;
                        });
                        icons[index].isSelect = true;
                        _selectIcon = icons[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          shape: BoxShape.rectangle,
                          color: (icons[index].isSelect
                              ? Colors.white
                              : Colors.transparent)),
                      alignment: Alignment.center,
                      child: Image.asset(
                        icons[index].icon,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
              height: 130,
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 18),
                  itemCount: backgroundColors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16),
                  itemBuilder: (context, index) {
                    HabitColor habitColor = backgroundColors[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          backgroundColors.forEach((element) {
                            element.isSelect = false;
                          });
                          backgroundColors[index].isSelect = true;
                          _selectBackgroundColor = backgroundColors[index];
                        });
                      },
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: habitColor.isSelect
                                    ? habitColor.color
                                    : Colors.white.withOpacity(0.3),
                                width: habitColor.isSelect ? 6 : 1.5),
                            color: Colors.transparent),
                        child: habitColor.isSelect
                            ? SizedBox()
                            : Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: habitColor.color),
                                width: 32,
                                height: 32),
                        duration: Duration(milliseconds: 300),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class Icon {
  final String icon;
  bool isSelect = false;

  Icon(this.icon, {this.isSelect = false});

  static List<Icon> getIcons() {
    List<Icon> icons = [];

    icons.add(Icon('assets/images/aquarium-水族馆.png', isSelect: true));
    icons.add(Icon('assets/images/bumblebee-熊峰.png'));
    icons.add(Icon('assets/images/butterfly-蝴蝶.png'));
    icons.add(Icon('assets/images/cat-footprint-猫抓.png'));
    icons.add(Icon('assets/images/cute-hamster-可爱仓鼠.png'));
    icons.add(Icon('assets/images/dinosaur-egg-龙宝宝.png'));
    icons.add(Icon('assets/images/dog-狗.png'));
    icons.add(Icon('assets/images/dove-鸽子.png'));
    icons.add(Icon('assets/images/flamingo-火烈鸟.png'));
    icons.add(Icon('assets/images/parrot-鹦鹉.png'));
    icons.add(Icon('assets/images/swan-天鹅.png'));

    icons.add(Icon('assets/images/badminton-player-羽毛球.png'));
    icons.add(Icon('assets/images/basketball-篮球.png'));
    icons.add(Icon('assets/images/cycling-自行车.png'));
    icons.add(Icon('assets/images/exercise-运动.png'));
    icons.add(Icon('assets/images/fishing-钓鱼.png'));
    icons.add(Icon('assets/images/jump-rope-跳绳.png'));
    icons.add(Icon('assets/images/pilates-普拉提.png'));
    icons.add(Icon('assets/images/ping-pong-乒乓球.png'));
    icons.add(Icon('assets/images/skateboard-滑板.png'));
    icons.add(Icon('assets/images/tennis-racquet-网球.png'));
    icons.add(Icon('assets/images/treadmill-跑步机.png'));

    return icons;
  }
}
