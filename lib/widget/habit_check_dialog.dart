import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/add_habit/edit_field_container.dart';

class HabitCheckDialog extends StatefulWidget {
  final String name;

  const HabitCheckDialog({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HabitCheckDialogState();
  }
}

class _HabitCheckDialogState extends State<HabitCheckDialog> {
  String log = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.86,
        height: 216,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              '确定完成了“${widget.name}”吗？',
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 12,
            ),
            EditFiledContainer(
              editType: 3,
              initValue: '',
              hintValue: '记录些什么...',
              onValueChanged: (value) {
                log = value;
              },
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/images/guanbi.svg',
                    width: 35,
                    height: 35,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 80,
                ),
                GestureDetector(
                  child: SvgPicture.asset(
                    'assets/images/duigou.svg',
                    width: 35,
                    height: 35,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(log);
                  },
                )
              ],
            ),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
