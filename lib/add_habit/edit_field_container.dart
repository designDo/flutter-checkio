import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';

class EditFiledContainer extends StatefulWidget {
  ///1 名字 2 标志 3 日志
  final int editType;
  final String initValue;
  final String hintValue;
  final ValueChanged<String> onValueChanged;

  const EditFiledContainer(
      {Key key,
      this.editType,
      this.initValue,
      this.onValueChanged,
      this.hintValue})
      : super(key: key);

  @override
  _EditFiledContainerState createState() => _EditFiledContainerState();
}

class _EditFiledContainerState extends State<EditFiledContainer>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ///文本内容
  String _value = '';
  TextEditingController editingController;
  AnimationController numAnimationController;
  Animation<double> numAnimation;

  @override
  void initState() {
    _value = widget.initValue;
    editingController = TextEditingController(text: widget.initValue);
    numAnimationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    numAnimation = CurvedAnimation(
        parent: numAnimationController, curve: Curves.easeOutBack);
    if (widget.initValue.length > 0) {
      numAnimationController.forward(from: 0.3);
    }
    super.initState();
  }

  int getMaxLength() {
    int maxLength = 10;
    switch (widget.editType) {
      case 1:
        maxLength = 10;
        break;
      case 2:
        maxLength = 50;
        break;
      case 3:
        maxLength = 20;
        break;
    }
    return maxLength;
  }

  int getMaxLines() {
    int maxLines = 1;
    switch (widget.editType) {
      case 1:
        maxLines = 1;
        break;
      case 2:
        maxLines = 5;
        break;
      case 3:
        maxLines = 2;
        break;
    }
    return maxLines;
  }

  int getMinLines() {
    int minLines = 1;
    switch (widget.editType) {
      case 1:
        minLines = 1;
        break;
      case 2:
        minLines = 4;
        break;
      case 3:
        minLines = 2;
        break;
    }
    return minLines;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 32, right: 32),
            child: TextField(
              strutStyle: StrutStyle(height: 1.5),
              maxLength: getMaxLength(),
              maxLines: getMaxLines(),
              minLines: getMinLines(),
              controller: editingController,
              showCursor: true,
              autofocus: false,
              onChanged: (value) async {
                setState(() {
                  _value = value;
                  widget.onValueChanged(value);
                });
                if (value.length == 1) {
                  numAnimationController.forward(from: 0.3);
                } else if (value.length > 1) {
                  numAnimationController.forward(from: 0.3);
                } else {
                  numAnimationController.reverse(from: 0.3);
                }
              },
              onSubmitted: (value) async {},
              cursorColor: AppTheme.appTheme.gradientColorDark(),
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.black,
                  fontWeight:
                      widget.editType == 1 ? FontWeight.bold : FontWeight.w500,
                  fontSize: 18),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: 16,
                      top: widget.editType == 1 ? 23 : 15,
                      bottom: widget.editType == 1 ? 23 : 15,
                      right: 16),
                  hintText: widget.hintValue,
                  hintStyle: AppTheme.appTheme.textStyle(
                      textColor: Colors.black.withOpacity(0.5),
                      fontWeight: widget.editType == 1
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 18),
                  fillColor: AppTheme.appTheme.containerBackgroundColor(),
                  counterText: '',
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
          ),
          ScaleTransition(
            scale: numAnimation,
            child: Padding(
                padding: EdgeInsets.only(right: 25),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(3, 3),
                            blurRadius: 6)
                      ]),
                  width: 50,
                  height: 35,
                  child: Text(
                    '${_value.length}/${getMaxLength()}',
                    style: TextStyle(
                        color: AppTheme.appTheme.gradientColorLight(),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    editingController.dispose();
    numAnimationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
