import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../data/api/entities/exercise_detection.dart';
import '../../../data/api/entities/exercise_info.dart';

@immutable
abstract class ExerciseDetectionState extends Equatable {
  ExerciseDetectionState();
}

class ExerciseDetectionLoading extends ExerciseDetectionState {
  final List<ExerciseInfo> exercises = [];

  @override
  List<Object> get props => [this.exercises];
}

class ExerciseDetectionLoad extends ExerciseDetectionState {
  final List<ExerciseDetection> exerciseDetect;
  final List<ExerciseInfo> exercises;

  ExerciseDetectionLoad(this.exerciseDetect, this.exercises);

  @override
  List<Object> get props => [this.exerciseDetect, this.exercises];
}
