import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/models/habit.dart';

class UserInfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 16, top: MediaQuery.of(context).padding.top + 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: Image.network(
              'https://c-ssl.duitang.com/uploads/item/201903/06/20190306091021_kzhxr.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            '亚索',
            style: AppTheme.appTheme.textStyle(
                textColor: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          )
        ],
      ),
    );
  }
}

class HabitsTotalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabitsBloc, HabitsState>(
      builder: (context, state) {
        if (state is HabitLoadSuccess) {
          List<Habit> habits = state.habits;
          int habitNum = habits.length;
          int checkNum = 0;
          habits.forEach((habit) {
            if (habit.records != null && habit.records.length > 0) {
              checkNum += habit.records.length;
            }
          });
          return Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 38),
            child: Row(
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/images/habit_check.svg',
                      width: 80,
                      height: 80,
                      color: Colors.grey.withOpacity(0.075),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$habitNum',
                          style: AppTheme.appTheme
                              .textStyle(
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27)
                              .copyWith(fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '习惯',
                          style: AppTheme.appTheme.textStyle(
                              textColor: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                      ],
                    )
                  ],
                  alignment: Alignment.center,
                )),
                Expanded(
                    child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/images/bianji.svg',
                      width: 80,
                      height: 80,
                      color: Colors.grey.withOpacity(0.075),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$checkNum',
                          style: AppTheme.appTheme
                              .textStyle(
                                  textColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27)
                              .copyWith(fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '记录',
                          style: AppTheme.appTheme.textStyle(
                              textColor: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                      ],
                    )
                  ],
                  alignment: Alignment.center,
                )),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

class UserProView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26, right: 26, top: 32),
      alignment: Alignment.center,
      height: 90,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xFF738AE6).withOpacity(0.3),
                offset: const Offset(5.1, 6.0),
                blurRadius: 12.0,
                spreadRadius: 0),
          ],
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF738AE6),
              Color(0xFF5C5EDD),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Text(
        '解锁专业版\n成为自己的英雄',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16),
      ),
    );
  }
}

class EnterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 26, right: 26, top: 26),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: AspectRatio(
                aspectRatio: 0.8,
                child: _item(
                    'assets/images/icon_fivestar.svg', '给TimeFly\n5星好评',
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color(0xFF738AE6).withOpacity(0.3),
                              offset: const Offset(5.1, 4.0),
                              blurRadius: 12.0,
                              spreadRadius: 0),
                        ],
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF738AE6),
                            Color(0xFF5C5EDD),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    colored: true),
              )),
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: AspectRatio(
                aspectRatio: 0.8,
                child: _item('assets/images/icon_theme.svg', '主题\n更多主题色'),
              ))
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Expanded(
                  child: AspectRatio(
                aspectRatio: 0.8,
                child: _item('assets/images/icon_contect.svg', '联系我\n建议和疑问'),
              )),
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: AspectRatio(
                aspectRatio: 0.8,
                child: _item('assets/images/icon_today.svg', '这一天\n我在这一天...'),
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget _item(String iconPath, String text,
      {BoxDecoration decoration, bool colored = false}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: decoration == null
          ? BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
              boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.075),
                      offset: const Offset(5.1, 4.0),
                      blurRadius: 16.0),
                ])
          : decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 26,
            height: 26,
            color: colored ? Colors.white : Color(0xFF5C5EDD),
          ),
          Expanded(child: SizedBox()),
          Text(
            text,
            style: AppTheme.appTheme.textStyle(
                textColor: colored ? Colors.white : Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16),
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
