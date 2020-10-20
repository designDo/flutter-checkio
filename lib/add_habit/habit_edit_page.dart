import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/add_habit/Icon_color.dart';
import 'package:timefly/add_habit/edit_field_container.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/complete_time.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_color.dart';
import 'package:timefly/models/habit_icon.dart';
import 'package:timefly/utils/uuid.dart';
import 'package:timefly/widget/float_modal.dart';

class HabitEditPage extends StatefulWidget {
  @override
  _HabitEditPageState createState() => _HabitEditPageState();
}

class _HabitEditPageState extends State<HabitEditPage> {
  List<HabitIcon> icons = [];
  HabitIcon _selectIcon;

  List<HabitColor> colors;
  HabitColor _selectColor;

  List<CompleteTime> completeTimes = [];

  String _name = '';
  String _mark = '';

  @override
  void initState() {
    icons = HabitIcon.getIcons();
    _selectIcon = icons[0];
    colors = HabitColor.getBackgroundColors();
    _selectColor = colors[0];
    completeTimes = CompleteTime.getCompleteTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.cardBackgroundColor(),
      body: Column(
        children: [
          barView(),
          Expanded(
            child: Container(
              child: ListView(
                padding: EdgeInsets.only(bottom: 20),
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.8),
                                  width: 2),
                              shape: BoxShape.circle,
                              color: _selectColor.color),
                          width: 60,
                          height: 60,
                          child: Image.asset(_selectIcon.icon),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: 60,
                          width: 30,
                          child: InkWell(
                            onTap: () {
                              showFloatingModalBottomSheet(
                                  context: context,
                                  barrierColor: Colors.black87,
                                  builder: (context, scroller) {
                                    return IconAndColorPage();
                                  });
                            },
                            child: SvgPicture.asset(
                              'assets/images/bianji.svg',
                              color: Colors.black,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  EditFiledContainer(
                    editType: 1,
                    initValue: '',
                    onValueChanged: (value) {
                      _name = value;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 18, top: 8),
                    child: Text(
                      'Time Space',
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.black38,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  timeView(),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 18, top: 16),
                    child: Text(
                      'Reminder',
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.black38,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  timeReminderView(),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 18, top: 16),
                    child: Text(
                      'Note',
                      style: AppTheme.appTheme.textStyle(
                          textColor: Colors.black38,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                  EditFiledContainer(
                    editType: 2,
                    initValue: '',
                    onValueChanged: (value) {
                      _mark = value;
                    },
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_name.length == 0) {
                        return;
                      }
                      if (timeOfDay == null) {
                        return;
                      }
                      await DatabaseProvider.db.insert(Habit(
                          id: Uuid().generateV4(),
                          name: _name,
                          iconPath: _selectIcon.icon,
                          mainColor: _selectColor.color.value,
                          mark: _mark,
                          remindTimes: [
                            '${timeOfDay.hour}:${timeOfDay.minute}'
                          ],
                          createTime: DateTime.now().millisecondsSinceEpoch,
                          completed: false));
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                      alignment: Alignment.center,
                      width: 250,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(32)),
                          color: AppTheme.appTheme.gradientColorLight()),
                      child: Text(
                        '完成',
                        style: AppTheme.appTheme.textStyle(
                            textColor: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget barView() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: 60 + MediaQuery.of(context).padding.top,
      child: Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset(
                'assets/images/fanhui.svg',
                color: Colors.black,
                width: 30,
                height: 30,
              ),
            ),
          )),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '新建习惯',
                style: AppTheme.appTheme.textStyle(
                    textColor: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: RaisedButton(
                onPressed: () {},
                child: Text('Save'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget habitIconsView() {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      height: 190,
      child: GridView.builder(
        padding: EdgeInsets.only(left: 32),
        itemCount: icons.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemBuilder: (context, index) {
          HabitIcon habitIcon = icons[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                icons.forEach((element) {
                  element.isSelect = false;
                });
                habitIcon.isSelect = true;
                _selectIcon = habitIcon;
              });
            },
            child: AnimatedContainer(
              decoration: BoxDecoration(
                  borderRadius: habitIcon.isSelect
                      ? BorderRadius.all(Radius.circular(10))
                      : BorderRadius.all(Radius.circular(30)),
                  shape: BoxShape.rectangle,
                  color: Colors.transparent,
                  border: Border.all(
                      color: habitIcon.isSelect
                          ? AppTheme.appTheme.gradientColorLight()
                          : Colors.transparent,
                      width: 2)),
              alignment: Alignment.center,
              child: Image.asset(
                icons[index].icon,
                width: 40,
                height: 40,
              ),
              duration: Duration(milliseconds: 300),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget habitColorsView() {
    return Container(
      height: 110,
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 32),
          itemCount: colors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
          itemBuilder: (context, index) {
            HabitColor habitColor = colors[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  colors.forEach((element) {
                    element.isSelect = false;
                  });
                  habitColor.isSelect = true;
                  _selectColor = habitColor;
                });
              },
              child: AnimatedContainer(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: habitColor.isSelect
                            ? habitColor.color
                            : AppTheme.appTheme
                                .gradientColorLight()
                                .withOpacity(0.3),
                        width: habitColor.isSelect ? 4 : 1.5),
                    color: Colors.transparent),
                child: habitColor.isSelect
                    ? SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: habitColor.color),
                        width: 25,
                        height: 25),
                duration: Duration(milliseconds: 300),
              ),
            );
          }),
    );
  }

  Widget timeView() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      height: 50,
      child: ListView.builder(
        padding: EdgeInsets.only(left: 16, right: 16),
        itemBuilder: (context, index) {
          CompleteTime completeTime = completeTimes[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                completeTimes.forEach((element) {
                  element.isSelect = false;
                });
                completeTime.isSelect = true;
              });
            },
            child: AnimatedContainer(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 16),
              width: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: completeTime.isSelect
                          ? Colors.black
                          : Colors.transparent,
                      width: 2),
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColorDark.withOpacity(0.08)),
              child: Text(
                CompleteTime.getTime(completeTime.time),
                style: AppTheme.appTheme.textStyle(
                    textColor: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              duration: Duration(milliseconds: 300),
            ),
          );
        },
        itemCount: completeTimes.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  TimeOfDay timeOfDay;

  Widget timeReminderView() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 35, top: 16),
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () async {
          TimeOfDay result = await showTimePicker(
              context: context,
              initialTime: timeOfDay == null ? TimeOfDay.now() : timeOfDay,
              cancelText: '取消',
              confirmText: '确定',
              helpText: '选择时间');
          setState(() {
            timeOfDay = result;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).primaryColorDark.withOpacity(0.08)),
          width: 50,
          height: 50,
          child: timeOfDay == null
              ? SvgPicture.asset(
                  'assets/images/jia.svg',
                  color: Colors.black,
                  width: 30,
                  height: 30,
                )
              : Text(
                  '${timeOfDay.hour}:${timeOfDay.minute}',
                  style: AppTheme.appTheme.textStyle(
                      textColor: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
