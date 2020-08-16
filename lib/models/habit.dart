import 'package:equatable/equatable.dart';

class Habit extends Equatable {

  final String id;
  final String name;
  final String note;
  final bool complete;

  Habit(this.id, this.name, this.note, this.complete);

  @override
  List<Object> get props => [];

}