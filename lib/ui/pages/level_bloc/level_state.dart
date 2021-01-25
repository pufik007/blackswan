import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import '../../../data/api/entities/exerciseDetection.dart';

@immutable
abstract class LevelState extends Equatable {
  LevelState();
}

class LevelLoading extends LevelState {
  @override
  List<Object> get props => [];
}

class LevelLoaded extends LevelState {
  final Level level;
  final List<ExerciseInfo> exercises;

  LevelLoaded(this.level, this.exercises);

  @override
  List<Object> get props => [this.level, this.exercises];
}

class ExerciseDetectionLoaded extends LevelState {
  final List<ExerciseDetection> exerciseDetections;

  ExerciseDetectionLoaded(this.exerciseDetections);

  @override
  List<Object> get props => [this.exerciseDetections];
}
