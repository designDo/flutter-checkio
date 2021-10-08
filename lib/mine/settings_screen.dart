import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_event.dart';
import 'package:timefly/blocs/theme/theme_state.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/utils/system_util.dart';
import 'package:timefly/widget/custom_edit_field.dart';

import '../app_theme.dart';
import 'change_theme_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        SystemUtil.changeStateBarMode(
            AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark);

        AppThemeMode appThemeMode = state.themeMode;
        AppThemeColorMode appThemeColorMode = state.themeColorMode;
        AppFontMode appFontMode = state.fontMode;

        return Scaffold(
          body: Container(
            color: AppTheme.appTheme.containerBackgroundColor(),
            child: Stack(
              children: [
                ListView(physics: ClampingScrollPhysics(), children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top, right: 24),
                    alignment: Alignment.topRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Image.asset(
                        'assets/images/user_icon.jpg',
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  ChangeUserInfoView(),
                  DarkModeView(
                    appThemeMode: appThemeMode,
                    appThemeColorMode: appThemeColorMode,
                    appFontMode: appFontMode,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ThemeColorView(
                    currentColorMode: appThemeColorMode,
                    onTap: (colorMode) async {
                      BlocProvider.of<ThemeBloc>(context).add(ThemeChangeEvent(
                          appThemeMode, colorMode, appFontMode));
                      SharedPreferences shared =
                          await SharedPreferences.getInstance();
                      shared.setString(COLOR_MODE, colorMode.toString());
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      SessionUtils.sharedInstance().logout();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: 32, right: 32, top: 48, bottom: 32),
                      height: 55,
                      width: 220,
                      decoration: BoxDecoration(
                          boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                          gradient: AppTheme.appTheme.containerGradient(),
                          borderRadius: BorderRadius.all(Radius.circular(35))),
                      child: Text(
                        '退出',
                        style: AppTheme.appTheme.headline1(
                            textColor: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ]),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 26),
                    height: 45,
                    child: Container(
                      alignment: Alignment.center,
                      width: 90,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(26),
                              bottomRight: Radius.circular(26)),
                          color: AppTheme.appTheme.cardBackgroundColor(),
                          boxShadow: AppTheme.appTheme.containerBoxShadow()),
                      child: SvgPicture.asset(
                        'assets/images/fanhui.svg',
                        width: 25,
                        height: 25,
                        color: AppTheme.appTheme.normalColor().withOpacity(0.8),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChangeUserInfoView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeUserInfoViewState();
  }
}

class _ChangeUserInfoViewState extends State<ChangeUserInfoView> {
  String userName;

  @override
  void initState() {
    userName = SessionUtils.sharedInstance().currentUser.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32, left: 22, right: 22),
      padding: EdgeInsets.only(top: 16, bottom: 24),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: AppTheme.appTheme.cardBackgroundColor(),
          boxShadow: AppTheme.appTheme.containerBoxShadow()),
      child: Column(
        children: [
          CustomEditField(
            maxLength: 10,
            autoFucus: false,
            inputType: TextInputType.name,
            initValue: userName,
            hintText: '名字',
            hintTextStyle: AppTheme.appTheme
                .hint(fontWeight: FontWeight.bold, fontSize: 18),
            textStyle: AppTheme.appTheme
                .headline1(fontWeight: FontWeight.bold, fontSize: 18),
            containerDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: AppTheme.appTheme.containerBackgroundColor()),
            numDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppTheme.appTheme.cardBackgroundColor(),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: AppTheme.appTheme.containerBoxShadow()),
            numTextStyle: AppTheme.appTheme
                .themeText(fontWeight: FontWeight.bold, fontSize: 15),
            onValueChanged: (value) {
              userName = value;
            },
            onCompleted: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              if (userName.isEmpty) {
                FlashHelper.toast(context, '请输入名字');
                return;
              }
              try {
                SessionUtils.sharedInstance().updateName(userName);
              } catch (e) {
                print(e);
              }
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 32, right: 32, top: 16),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: AppTheme.appTheme.containerBackgroundColor()),
            height: 65,
            child: Text(
              SessionUtils.sharedInstance().currentUser.phone,
              style: AppTheme.appTheme.numHeadline1(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  textColor: AppTheme.appTheme.normalColor().withOpacity(0.5)),
            ),
          )
        ],
      ),
    );
  }
}

class DarkModeView extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final AppThemeColorMode appThemeColorMode;

  final AppFontMode appFontMode;

  const DarkModeView(
      {Key key, this.appThemeMode, this.appThemeColorMode, this.appFontMode})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DarkModeViewState();
  }
}

///切换暗黑模式
class _DarkModeViewState extends State<DarkModeView> {
  bool checked = false;

  @override
  void initState() {
    checked = widget.appThemeMode == AppThemeMode.Dark;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32, left: 22, right: 22),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: AppTheme.appTheme.cardBackgroundColor(),
          boxShadow: AppTheme.appTheme.containerBoxShadow()),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${checked ? '开' : '关'}',
                style: AppTheme.appTheme
                    .headline1(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                '黑夜模式',
                style: AppTheme.appTheme.headline1(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    textColor:
                        AppTheme.appTheme.normalColor().withOpacity(0.5)),
              )
            ],
          ),
          Expanded(child: SizedBox()),
          Checkbox(
              value: checked,
              activeColor: AppTheme.appTheme.grandientColorStart(),
              onChanged: (value) async {
                SharedPreferences shared =
                    await SharedPreferences.getInstance();
                setState(() {
                  checked = value;
                  BlocProvider.of<ThemeBloc>(context).add(ThemeChangeEvent(
                      checked ? AppThemeMode.Dark : AppThemeMode.Light,
                      widget.appThemeColorMode,
                      widget.appFontMode));

                  shared.setString(
                      THEME_MODE,
                      checked
                          ? AppThemeMode.Dark.toString()
                          : AppThemeMode.Light.toString());
                });
              })
        ],
      ),
    );
  }
}
