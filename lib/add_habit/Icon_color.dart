import 'package:flutter/material.dart';

import '../app_theme.dart';

class IconAndColorPage extends StatefulWidget {
  @override
  _IconAndColorPageState createState() => _IconAndColorPageState();
}

class _IconAndColorPageState extends State<IconAndColorPage> {
  List<Icon> icons = [];
  Icon _selectIcon;
  double _sliderValue = 0;

  @override
  void initState() {
    icons = Icon.getIcons();
    _selectIcon = icons[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(
            height: 18,
          ),
          Text('请挑选一个图标和颜色吧',
              style: AppTheme.appTheme.textStyle(
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColorDark.withOpacity(0.08),
                border: Border.all(color: Colors.white, width: 2)),
            width: 80,
            height: 80,
            child: Image.asset(
              _selectIcon.icon,
              fit: BoxFit.contain,
              width: 50,
              height: 50,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            height: 220,
            child: GridView.builder(
              padding: EdgeInsets.only(left: 18),
              itemCount: icons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      icons.forEach((element) {
                        element.isSelect = false;
                      });
                      icons[index].isSelect = true;
                      _selectIcon = icons[index];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        shape: BoxShape.rectangle,
                        color: (icons[index].isSelect
                            ? Colors.white
                            : Colors.transparent)),
                    alignment: Alignment.center,
                    child: Image.asset(
                      icons[index].icon,
                      width: 40,
                      height: 40,
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}

class Icon {
  final String icon;
  bool isSelect = false;

  Icon(this.icon, {this.isSelect = false});

  static List<Icon> getIcons() {
    List<Icon> icons = [];

    icons.add(Icon('assets/images/aquarium-水族馆.png', isSelect: true));
    icons.add(Icon('assets/images/bumblebee-熊峰.png'));
    icons.add(Icon('assets/images/butterfly-蝴蝶.png'));
    icons.add(Icon('assets/images/cat-footprint-猫抓.png'));
    icons.add(Icon('assets/images/cute-hamster-可爱仓鼠.png'));
    icons.add(Icon('assets/images/dinosaur-egg-龙宝宝.png'));
    icons.add(Icon('assets/images/dog-狗.png'));
    icons.add(Icon('assets/images/dove-鸽子.png'));
    icons.add(Icon('assets/images/flamingo-火烈鸟.png'));
    icons.add(Icon('assets/images/parrot-鹦鹉.png'));
    icons.add(Icon('assets/images/swan-天鹅.png'));

    icons.add(Icon('assets/images/badminton-player-羽毛球.png'));
    icons.add(Icon('assets/images/basketball-篮球.png'));
    icons.add(Icon('assets/images/cycling-自行车.png'));
    icons.add(Icon('assets/images/exercise-运动.png'));
    icons.add(Icon('assets/images/fishing-钓鱼.png'));
    icons.add(Icon('assets/images/jump-rope-跳绳.png'));
    icons.add(Icon('assets/images/pilates-普拉提.png'));
    icons.add(Icon('assets/images/ping-pong-乒乓球.png'));
    icons.add(Icon('assets/images/skateboard-滑板.png'));
    icons.add(Icon('assets/images/tennis-racquet-网球.png'));
    icons.add(Icon('assets/images/treadmill-跑步机.png'));

    return icons;
  }
}
