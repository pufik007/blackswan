import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ExerciseDetectionEvent extends Equatable {
  final List _properties;

  ExerciseDetectionEvent([this._properties]);

  @override
  List<Object> get props => this._properties;
}

class LoadExerciseDetection extends ExerciseDetectionEvent {
  LoadExerciseDetection() : super([]);
}
