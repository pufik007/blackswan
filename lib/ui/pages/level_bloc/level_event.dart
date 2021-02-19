import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LevelEvent extends Equatable {
  final List _properties;

  LevelEvent([this._properties]);

  @override
  List<Object> get props => this._properties;
}

class Load extends LevelEvent {
  Load() : super([]);
}

class LoadDetections extends LevelEvent {
  final List<String> exerciseIds;

  LoadDetections(this.exerciseIds) : super([exerciseIds]);
}

class HarderExercise extends LevelEvent {
  final int exerciseID;

  HarderExercise(this.exerciseID) : super([exerciseID]);
}

class EasierExercise extends LevelEvent {
  final int exerciseID;

  EasierExercise(this.exerciseID) : super([exerciseID]);
}
