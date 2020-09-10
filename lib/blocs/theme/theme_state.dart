import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {

  ThemeState(this.themeData);

  @override
  List<Object> get props => [themeData];

  final ThemeData themeData;
}
