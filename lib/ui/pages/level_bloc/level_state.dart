import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';

@immutable
abstract class LevelState extends Equatable {
  LevelState();

  List<ExerciseInfo> get exercises => null;
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
