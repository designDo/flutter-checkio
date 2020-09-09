import 'package:flutter/material.dart';
import 'package:timefly/utils/hex_color.dart';

class EditNameView extends StatefulWidget {
  final String editValue;

  const EditNameView({
    Key key,
    this.editValue,
  }) : super(key: key);

  @override
  _EditNameViewState createState() => _EditNameViewState();
}

class _EditNameViewState extends State<EditNameView>
    with WidgetsBindingObserver {
  ///文本内容
  String _value = '';
  TextEditingController editingController;

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          //关闭键盘
          print('close');
          Navigator.of(context).pop(_value);
        } else {
          //显示键盘
          print('open');
        }
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    editingController = TextEditingController(text: widget.editValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          color: Colors.transparent,
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
                  controller: editingController,
                  showCursor: true,
                  autofocus: true,
                  onChanged: (value) async {
                    _value = value;
                  },
                  onSubmitted: (value) async {
                    // Navigator.of(context).pop(value);
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    editingController.dispose();
    super.dispose();
  }
}
