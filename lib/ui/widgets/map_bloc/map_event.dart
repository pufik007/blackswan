import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MapEvent extends Equatable {
  final List _properties;

  MapEvent([this._properties]);

  @override
  List<Object> get props => this._properties;
}

class Load extends MapEvent {
  Load() : super([]);
}

