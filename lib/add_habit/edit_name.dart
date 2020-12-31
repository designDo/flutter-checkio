import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/widget/custom_edit_field.dart';

class EditNameView extends StatefulWidget {
  final HabitRecord habitRecord;

  const EditNameView({
    Key key,
    this.habitRecord,
  }) : super(key: key);

  @override
  _EditNameViewState createState() => _EditNameViewState();
}

class _EditNameViewState extends State<EditNameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 32, bottom: 32),
          margin: EdgeInsets.only(left: 32, right: 32),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white),
          child: CustomEditField(
            maxLength: 50,
            autoFucus: true,
            initValue: widget.habitRecord.content,
            hintText: '记录些什么 ...',
            hintTextStyle: AppTheme.appTheme.textStyle(
                textColor: Colors.black.withOpacity(0.5),
                fontWeight: FontWeight.normal,
                fontSize: 16),
            textStyle: AppTheme.appTheme.textStyle(
                textColor: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16),
            minHeight: 100,
            containerDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: AppTheme.appTheme.containerBackgroundColor()),
            numDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(3, 3),
                      blurRadius: 6)
                ]),
            numTextStyle: TextStyle(
                color: AppTheme.appTheme.gradientColorLight(),
                fontWeight: FontWeight.bold,
                fontSize: 15),
            onValueChanged: (value) {
              widget.habitRecord.content = value;
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.done),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
