import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tensorfit/data/api/entities/exerciseDetection.dart';

@immutable
abstract class ExerciseDetectionState extends Equatable {
  ExerciseDetectionState();
}

class ExerciseDetectionLoading extends ExerciseDetectionState {
  @override
  List<Object> get props => [];
}

class ExerciseDetectionLoad extends ExerciseDetectionState {
  final List<ExerciseDetection> exerciseDetect;

  ExerciseDetectionLoad(this.exerciseDetect);

  @override
  List<Object> get props => [this.exerciseDetect];
}
