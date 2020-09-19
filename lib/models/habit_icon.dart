class HabitIcon {
  final String icon;
  bool isSelect = false;

  HabitIcon(this.icon, {this.isSelect = false});

  static List<HabitIcon> getIcons() {
    List<HabitIcon> icons = [];

    icons.add(HabitIcon('assets/images/aquarium-水族馆.png', isSelect: true));
    icons.add(HabitIcon('assets/images/bumblebee-熊峰.png'));
    icons.add(HabitIcon('assets/images/butterfly-蝴蝶.png'));
    icons.add(HabitIcon('assets/images/cat-footprint-猫抓.png'));
    icons.add(HabitIcon('assets/images/cute-hamster-可爱仓鼠.png'));
    icons.add(HabitIcon('assets/images/dinosaur-egg-龙宝宝.png'));
    icons.add(HabitIcon('assets/images/dog-狗.png'));
    icons.add(HabitIcon('assets/images/dove-鸽子.png'));
    icons.add(HabitIcon('assets/images/flamingo-火烈鸟.png'));
    icons.add(HabitIcon('assets/images/parrot-鹦鹉.png'));
    icons.add(HabitIcon('assets/images/swan-天鹅.png'));

    icons.add(HabitIcon('assets/images/badminton-player-羽毛球.png'));
    icons.add(HabitIcon('assets/images/basketball-篮球.png'));
    icons.add(HabitIcon('assets/images/cycling-自行车.png'));
    icons.add(HabitIcon('assets/images/exercise-运动.png'));
    icons.add(HabitIcon('assets/images/fishing-钓鱼.png'));
    icons.add(HabitIcon('assets/images/jump-rope-跳绳.png'));
    icons.add(HabitIcon('assets/images/pilates-普拉提.png'));
    icons.add(HabitIcon('assets/images/ping-pong-乒乓球.png'));
    icons.add(HabitIcon('assets/images/skateboard-滑板.png'));
    icons.add(HabitIcon('assets/images/tennis-racquet-网球.png'));
    icons.add(HabitIcon('assets/images/treadmill-跑步机.png'));

    return icons;
  }
}