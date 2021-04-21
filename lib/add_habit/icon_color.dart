import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/models/habit_color.dart';
import 'package:timefly/models/habit_icon.dart';

import '../app_theme.dart';

class IconAndColorPage extends StatefulWidget {
  final String selectedIcon;
  final Color selectedColor;

  const IconAndColorPage({Key key, this.selectedIcon, this.selectedColor})
      : super(key: key);

  @override
  _IconAndColorPageState createState() => _IconAndColorPageState();
}

class _IconAndColorPageState extends State<IconAndColorPage> {
  List<HabitIcon> icons = [];
  HabitIcon _selectIcon;

  List<HabitColor> backgroundColors = [];
  HabitColor _selectBackgroundColor;

  @override
  void initState() {
    icons = HabitIcon.getIcons();

    icons.forEach((icon) {
      if (icon.icon == widget.selectedIcon) {
        icon.isSelect = true;
        _selectIcon = icon;
      } else {
        icon.isSelect = false;
      }
    });

    backgroundColors = HabitColor.getBackgroundColors();
    backgroundColors.forEach((color) {
      if (color.color.value == widget.selectedColor.value) {
        color.isSelect = true;
        _selectBackgroundColor = color;
      } else {
        color.isSelect = false;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppTheme.appTheme.cardBackgroundColor(),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
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
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          shape: BoxShape.rectangle,
                          color: (icons[index].isSelect
                              ? _selectBackgroundColor.color
                              : AppTheme.appTheme.containerBackgroundColor())),
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
                                    : AppTheme.appTheme
                                        .containerBackgroundColor(),
                                width: habitColor.isSelect ? 3 : 1.5),
                            color: Colors.transparent),
                        child: habitColor.isSelect
                            ? SizedBox()
                            : Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: habitColor.color),
                                width: 28,
                                height: 28),
                        duration: Duration(milliseconds: 300),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 40,
              child: GestureDetector(
                onTap: () {
                  Map<String, dynamic> result = Map();
                  print(_selectIcon.icon);
                  result['icon'] = _selectIcon.icon;
                  result['color'] = _selectBackgroundColor.color;
                  Navigator.of(context).pop(result);
                },
                child: SvgPicture.asset(
                  'assets/images/duigou.svg',
                  width: 35,
                  height: 35,
                  color: AppTheme.appTheme.normalColor(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
