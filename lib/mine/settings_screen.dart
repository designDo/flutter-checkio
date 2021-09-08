import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_state.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/utils/system_util.dart';
import 'package:timefly/widget/custom_edit_field.dart';

import '../app_theme.dart';

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
        return Container(
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
                    child: Image.network(
                      'https://c-ssl.duitang.com/uploads/item/201903/06/20190306091021_kzhxr.jpg',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ChangeUserInfoView(),
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
      padding: EdgeInsets.only(top: 16, bottom: 16),
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
                .hint(fontWeight: FontWeight.normal, fontSize: 16),
            textStyle: AppTheme.appTheme
                .headline1(fontWeight: FontWeight.normal, fontSize: 16),
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
              User user = SessionUtils.sharedInstance().currentUser;
              BmobUser bmobUser = BmobUser();
              bmobUser.objectId = user.id;
              bmobUser.mobilePhoneNumber = user.phone;
              bmobUser.mobilePhoneNumberVerified = true;
              bmobUser.username = userName;
              try {
                await bmobUser.update();
                SessionUtils.sharedInstance().updateName(userName);
              } catch (e) {
                print(e);
              }
            },
          )
        ],
      ),
    );
  }
}
