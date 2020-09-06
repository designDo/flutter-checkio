import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timefly/utils/hex_color.dart';

class NameAndMarkPage extends StatefulWidget {
  final Function onPageNext;

  const NameAndMarkPage({Key key, this.onPageNext}) : super(key: key);

  @override
  _NameAndMarkPageState createState() => _NameAndMarkPageState();
}

class _NameAndMarkPageState extends State<NameAndMarkPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _animationController;

  String _name = '';

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    Future.delayed(
        Duration(milliseconds: 400), () => _animationController.forward());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 18,
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0, 0.1, curve: Curves.decelerate)),
              child: Text(
                '给习惯取一个好听的名字\n并编辑一句鼓励自己的话',
                strutStyle: StrutStyle(height: 2),
                style: GoogleFonts.maShanZheng(
                    letterSpacing: 3,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        SizedBox(
          height: 32,
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.1, 0.3, curve: Curves.decelerate)),
              child: Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: TextField(
                  onChanged: (value) async {
                    setState(() {
                      _name = value;
                    });
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
              ),
            );
          },
        ),
        SizedBox(
          height: 42,
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.3, 0.5, curve: Curves.decelerate)),
              child: Padding(
                padding: EdgeInsets.only(left: 32, right: 32),
                child: TextField(
                  minLines: 2,
                  maxLines: 3,
                  cursorColor: Colors.blueAccent,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  decoration: InputDecoration(
                      hintText: '坚持就是胜利 ...',
                      hintStyle: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      fillColor: HexColor('#7976CD'),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#7976CD')),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#7976CD')),
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                ),
              ),
            );
          },
        ),
        Expanded(
          flex: 2,
          child: SizedBox(),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: _animationController,
                curve: Interval(0.5, 1, curve: Curves.elasticOut),
              ),
              child: GestureDetector(
                onTap: () {
                  if (_name.length == 0) {
                    return;
                  }
                  widget.onPageNext();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      color: _name.length > 0
                          ? Colors.white
                          : HexColor('#726DBD')),
                  child: Text(
                    '下一步',
                    style: TextStyle(
                        color: HexColor('#625FAC'),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
        Expanded(
          flex: 1,
          child: SizedBox(),
        )
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
