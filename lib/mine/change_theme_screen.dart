import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_event.dart';
import 'package:timefly/blocs/theme/theme_state.dart';

import '../app_theme.dart';

class ChangeThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          AppThemeMode appThemeMode = state.themeMode;
          AppThemeColorMode appThemeColorMode = state.themeColorMode;
          AppFontMode appFontMode = state.fontMode;
          return ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              ThemeColorView(
                currentColorMode: appThemeColorMode,
                onTap: (colorMode) {
                  BlocProvider.of<ThemeBloc>(context).add(
                      ThemeChangeEvent(appThemeMode, colorMode, appFontMode));
                },
              ),
              Row(
                children: AppThemeMode.values
                    .map((mode) => GestureDetector(
                          onTap: () {
                            BlocProvider.of<ThemeBloc>(context).add(
                                ThemeChangeEvent(
                                    mode, appThemeColorMode, appFontMode));
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 32),
                            width: 100,
                            height: 100,
                            color: AppTheme.modeMainColor(mode),
                            child: mode == appThemeMode
                                ? Icon(Icons.check)
                                : SizedBox(),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        BlocProvider.of<ThemeBloc>(context).add(
                            ThemeChangeEvent(appThemeMode,
                                AppThemeColorMode.values[index], appFontMode));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 32),
                        height: 100,
                        width: 100,
                        color: AppTheme.themeMainColor(
                            AppThemeColorMode.values[index]),
                        child:
                            AppThemeColorMode.values[index] == appThemeColorMode
                                ? Icon(Icons.check)
                                : SizedBox(),
                      ),
                    );
                  },
                  itemCount: AppThemeColorMode.values.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

typedef OnTap = void Function(AppThemeColorMode colorMode);

///选择主题颜色view
class ThemeColorView extends StatefulWidget {
  final AppThemeColorMode currentColorMode;

  final OnTap onTap;

  const ThemeColorView({Key key, this.currentColorMode, this.onTap})
      : super(key: key);

  @override
  _ThemeColorViewState createState() => _ThemeColorViewState();
}

class _ThemeColorViewState extends State<ThemeColorView> {
  final scalFraction = 0.40;

  final pageHeight = 200.0;

  ///每一个Item占据的空间
  double viewPortFraction = 1 / 3;

  PageController pageController;

  ///中间的为目标
  double scrollPageIndex = 1.0;

  int currentPage = 1;

  @override
  void initState() {
    pageController = PageController(
        initialPage: currentPage, viewportFraction: viewPortFraction);
    Future.delayed(Duration(milliseconds: 500), () {
      scrollToIndex(widget.currentColorMode);
    });
    super.initState();
  }

  void scrollToIndex(AppThemeColorMode colorMode) {
    pageController.animateToPage(AppThemeColorMode.values.indexOf(colorMode),
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          gradient: LinearGradient(colors: [
            AppTheme.themeMainColor(widget.currentColorMode),
            AppTheme.themeSecondColor(widget.currentColorMode)
          ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
      margin: EdgeInsets.only(left: 16, right: 16),
      height: pageHeight,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            setState(() {
              scrollPageIndex = pageController.page;
            });
            return true;
          }
          return false;
        },
        child: PageView.builder(
          onPageChanged: (pos) {
            setState(() {
              currentPage = pos;
            });
          },
          physics: BouncingScrollPhysics(),
          controller: pageController,
          itemCount: AppThemeColorMode.values.length,
          itemBuilder: (context, index) {
            final scale = max(scalFraction,
                (1.0 - (index - scrollPageIndex).abs()) + viewPortFraction);
            return circleOffer(AppThemeColorMode.values[index], scale);
          },
        ),
      ),
    );
  }

  Widget circleOffer(AppThemeColorMode colorMode, double scale) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: pageHeight * scale,
        width: pageHeight * scale,
        child: GestureDetector(
          onTap: () {
            widget.onTap(colorMode);
            scrollToIndex(colorMode);
          },
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            shape: CircleBorder(
                side: BorderSide(color: Colors.grey.shade200, width: 5)),
            color: AppTheme.themeMainColor(colorMode),
          ),
        ),
      ),
    );
  }
}
