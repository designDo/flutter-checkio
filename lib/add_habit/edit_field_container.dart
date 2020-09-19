import 'package:flutter/material.dart';
import 'package:timefly/app_theme.dart';

class EditFiledContainer extends StatefulWidget {
  final int editType;
  final String initValue;

  const EditFiledContainer({Key key, this.editType, this.initValue})
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
              maxLength: widget.editType == 1 ? 10 : 50,
              maxLines: widget.editType == 1 ? 1 : 5,
              minLines: widget.editType == 1 ? 1 : 4,
              controller: editingController,
              showCursor: true,
              autofocus: false,
              onChanged: (value) async {
                setState(() {
                  _value = value;
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
                      top: widget.editType == 1 ? 30 : 15,
                      bottom: widget.editType == 1 ? 30 : 15,
                      right: 16),
                  hintText: widget.editType == 1 ? '名字 ...' : '标记 ...',
                  hintStyle: AppTheme.appTheme.textStyle(
                      textColor: Colors.black.withOpacity(0.5),
                      fontWeight: widget.editType == 1
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 18),
                  fillColor: Colors.white,
                  counterText: '',
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: AppTheme.appTheme.gradientColorLight()),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: AppTheme.appTheme.gradientColorDark()),
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
                      border: Border.all(
                          color: Colors.black.withOpacity(0.6), width: 3)),
                  width: 50,
                  height: 35,
                  child: Text(
                    '${_value.length}/${widget.editType == 1 ? 10 : 50}',
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
