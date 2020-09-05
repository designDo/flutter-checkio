import 'package:flutter/material.dart';
import 'package:timefly/utils/hex_color.dart';

class AddHabitPageView extends StatefulWidget {
  @override
  _AddHabitPageViewState createState() => _AddHabitPageViewState();
}

class _AddHabitPageViewState extends State<AddHabitPageView> {
  List<Widget> widgets = [];
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    widgets.add(nameAndIconPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return widgets[index];
        });
  }

  Widget nameAndIconPage() {
    return Column(
      children: [
        SizedBox(
          height: 32,
        ),
        Text(
          '给习惯取一个好听的名字\n并选择一个喜欢的图标吧',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: EdgeInsets.only(left: 32, right: 32),
          child: TextField(
            cursorColor: Colors.blueAccent,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            decoration: InputDecoration(
                hintText: '名字 ...',
                hintStyle: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                fillColor: HexColor('#738AE6'),
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor('#738AE6')),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor('#738AE6')),
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(),
        ),
        InkWell(
          child: Container(
            alignment: Alignment.center,
            width: 150,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(32)),
                shape: BoxShape.rectangle),
            child: Text('下一步'),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        )
      ],
    );
  }
}
