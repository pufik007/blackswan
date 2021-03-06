import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../api/entities/exercise_detection.dart';
import '../../data/api/entities/level.dart';

@immutable
abstract class NavigatorEvent extends Equatable {
  final List _properties;

  NavigatorEvent([this._properties]);

  @override
  List<Object> get props => this._properties;
}

class NavigateToLogIn extends NavigatorEvent {
  NavigateToLogIn() : super([]);
}

class NavigateToCreateAccount extends NavigatorEvent {
  NavigateToCreateAccount() : super([]);
}

class NavigateToCreateJourney extends NavigatorEvent {
  NavigateToCreateJourney() : super([]);
}

class NavigateToLevel extends NavigatorEvent {
  final Level level;
  final ImageProvider image;
  final Alignment imageAlign;

  NavigateToLevel(this.level, this.image, this.imageAlign)
      : super([level, image]);
}

class NavigateToCameraPredictionPage extends NavigatorEvent {
  final Level level;
  final List<ExerciseDetection> exerciseDetections;
  NavigateToCameraPredictionPage(this.level, this.exerciseDetections)
      : super([level]);
}

class NavigateBack extends NavigatorEvent {
  NavigateBack() : super([]);
}
