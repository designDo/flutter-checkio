import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';

class CustomEditField extends StatefulWidget {
  /// Container bg
  final BoxDecoration containerDecoration;
  final BoxDecoration numDecoration;

  final int maxLines;
  final int maxLength;
  final double minHeight;

  final String hintText;
  final TextStyle hintTextStyle;
  final TextStyle textStyle;
  final TextStyle numTextStyle;
  final bool autoFucus;
  final TextInputType inputType;

  final String initValue;
  final ValueChanged<String> onValueChanged;
  final VoidCallback onCompleted;

  const CustomEditField(
      {Key key,
      this.containerDecoration,
      this.maxLines,
      this.hintTextStyle,
      this.textStyle,
      this.initValue,
      this.onValueChanged,
      this.hintText,
      this.maxLength,
      this.numDecoration,
      this.numTextStyle,
      this.minHeight,
      this.autoFucus,
      this.inputType,
      this.onCompleted})
      : super(key: key);

  @override
  _CustomEditFieldState createState() => _CustomEditFieldState();
}

class _CustomEditFieldState extends State<CustomEditField>
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            constraints: BoxConstraints(
                minHeight: widget.minHeight == null ? 0 : widget.minHeight),
            margin: EdgeInsets.only(top: 10, left: 32, right: 32),
            decoration: widget.containerDecoration,
            child: TextField(
              strutStyle: StrutStyle(height: 1.5),
              controller: editingController,
              showCursor: true,
              autofocus: widget.autoFucus == null ? false : widget.autoFucus,
              style: widget.textStyle,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                  hintStyle: widget.hintTextStyle,
                  hintText: widget.hintText,
                  fillColor: Colors.transparent,
                  filled: true,
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              maxLines: (widget.maxLines == null || widget.maxLines == 1)
                  ? null
                  : widget.maxLines,
              keyboardType: widget.inputType == null
                  ? (widget.maxLines == null || widget.maxLines == 1)
                      ? TextInputType.name
                      : TextInputType.multiline
                  : widget.inputType,
              cursorColor: AppTheme.appTheme.grandientColorStart(),
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
              onEditingComplete: widget.onCompleted ?? () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ),
          ScaleTransition(
            scale: numAnimation,
            child: Padding(
                padding: EdgeInsets.only(right: 25),
                child: Container(
                  alignment: Alignment.center,
                  decoration: widget.numDecoration,
                  width: 50,
                  height: 35,
                  child: Text(
                    '${_value.length}/${widget.maxLength}',
                    style: widget.numTextStyle,
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
