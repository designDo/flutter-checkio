import 'package:flutter/material.dart';
import 'package:timefly/models/habit.dart';

class HabitListView extends StatefulWidget {
  ///主页动画控制器，整体ListView的显示动画
  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;
  final List<Habit> habits;

  const HabitListView(
      {Key key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.habits})
      : super(key: key);

  @override
  _HabitListViewState createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0, 30 * (1.0 - widget.mainScreenAnimation.value), 0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  itemCount: widget.habits.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final int count =
                        widget.habits.length > 10 ? 10 : widget.habits.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController.forward();

                    return HabitView(
                      habit: widget.habits[index],
                      animationController: animationController,
                      animation: animation,
                    );
                  }),
            ),
          ),
        );
      },
    );
  }
}

class HabitView extends StatefulWidget {
  final Habit habit;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  const HabitView(
      {Key key, this.habit, this.animationController, this.animation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HabitView();
  }
}

class _HabitView extends State<HabitView> with SingleTickerProviderStateMixin {
  AnimationController tapAnimationController;
  Animation<double> tapAnimation;

  @override
  void initState() {
    tapAnimationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    tapAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        tapAnimationController.reverse();
      }
    });
    tapAnimation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
        parent: tapAnimationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    tapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - widget.animation.value), 0.0, 0.0),
            child: ScaleTransition(
              scale: tapAnimation,
              child: GestureDetector(
                onTap: () {
                  tapAnimationController.forward();
                },
                child: Container(
                  width: 130,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color(0xff5C5EDD).withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xff738AE6),
                            Color(0xff5C5EDD),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Text('${widget.habit.name}'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
