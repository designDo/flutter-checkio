import 'package:flutter/material.dart';
import 'package:timefly/utils/hex_color.dart';

class EditNameView extends StatefulWidget {
  final Animation<double> animation;

  const EditNameView({
    Key key,
    this.animation,
  }) : super(key: key);

  @override
  _EditNameViewState createState() => _EditNameViewState();
}

class _EditNameViewState extends State<EditNameView> {
  bool focus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
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
            children: [
              SizedBox(
                height: 40,
              ),
              Text('习惯名字',
                  style: TextStyle(
                    fontFamily: 'MaShanZheng',
                    letterSpacing: 3,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: 62,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  showCursor: true,
                  autofocus: true,
                  onChanged: (value) async {
                    print('value');
                  },
                  onSubmitted: (value) async {
                    Navigator.of(context).pop();
                  },
                  cursorColor: Colors.blueAccent,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  decoration: InputDecoration(
                      hintText: '名字 ...',
                      hintStyle: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      fillColor: HexColor('#7976CD'),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#7976CD')),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#7976CD')),
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                ),
              )
            ],
          )),
    );
  }
}
