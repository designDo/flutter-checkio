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
