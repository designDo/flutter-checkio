import 'package:data_plugin/bmob/bmob_sms.dart';
import 'package:data_plugin/bmob/response/bmob_sent.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name;
  String phone;
  String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                name = value;
              },
            ),
            TextField(
              onChanged: (value) {
                phone = value;
              },
            ),
            TextField(
              onChanged: (value) {
                code = value;
              },
            ),
            TextButton(
                onPressed: () {
                  BmobSms bmobSms = BmobSms();
                  bmobSms.template = "";
                  bmobSms.mobilePhoneNumber = phone;
                  bmobSms.sendSms().then((BmobSent bmobSent) {
                    print("发送成功:" + bmobSent.smsId.toString());
                  }).catchError((e) {
                    print(e);
                  });
                },
                child: Text('sendCode')),
            TextButton(
                onPressed: () {
                  BmobUser bmobUserRegister = BmobUser();
                  bmobUserRegister.username = name;
                  bmobUserRegister.mobilePhoneNumber = phone;
                  bmobUserRegister.loginBySms(code).then((BmobUser bmobUser) {
                    print("登录注册成功：" +
                        bmobUser.getObjectId() +
                        "\n" +
                        bmobUser.username);
                  }).catchError((e) {
                    print(e);
                    print('error');
                  });
                },
                child: Text('login'))
          ],
        ),
      ),
    );
  }
}
