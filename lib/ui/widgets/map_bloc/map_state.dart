import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tensorfit/data/api/entities/level.dart';

@immutable
abstract class MapState extends Equatable {
  MapState();

  String get userEmail => null;
}

class MapInit extends MapState {
  @override
  List<Object> get props => [];
}

class MapLoading extends MapState {
  @override
  List<Object> get props => [];
}

class MapLoaded extends MapState {
  final List<Level> levels;
  final int selectedLevelID;
  final String userEmail;

  MapLoaded(this.levels, this.selectedLevelID, this.userEmail);

  @override
  List<Object> get props => [this.levels, this.selectedLevelID, this.userEmail];
}
