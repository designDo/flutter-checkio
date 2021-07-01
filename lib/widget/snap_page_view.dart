import 'package:flutter/material.dart';
import 'dart:math';

const SCALE_FRACTION = 0.6;
const FULL_SCALE = 1.0;
const PAGER_HEIGHT = 100.0;

class ItCrowdPage extends StatefulWidget {
  @override
  _ItCrowdPageState createState() => _ItCrowdPageState();
}

class _ItCrowdPageState extends State<ItCrowdPage> {
  double viewPortFraction = 0.25;

  PageController pageController;

  int currentPage = 1;

  List<Color> listOfCharacters = [
    Colors.redAccent,
    Colors.blue,
    Colors.pink,
    Colors.purpleAccent
  ];

  double page = 1.0;

  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: viewPortFraction);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PAGER_HEIGHT,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            setState(() {
              page = pageController.page;
              print(page);
            });
          }
        },
        child: PageView.builder(
          onPageChanged: (pos) {
            setState(() {
              currentPage = pos;
            });
          },
          physics: BouncingScrollPhysics(),
          controller: pageController,
          itemCount: listOfCharacters.length,
          itemBuilder: (context, index) {
            final scale = max(SCALE_FRACTION,
                (FULL_SCALE - (index - page).abs()) + viewPortFraction);
            print(scale);
            return circleOffer(listOfCharacters[index], scale);
          },
        ),
      ),
    );
  }

  Widget circleOffer(Color color, double scale) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: color,
        margin: EdgeInsets.only(bottom: 10),
        height: PAGER_HEIGHT * scale,
        width: PAGER_HEIGHT * scale,
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          shape: CircleBorder(
              side: BorderSide(color: Colors.grey.shade200, width: 5)),
          color: color,
        ),
      ),
    );
  }
}
