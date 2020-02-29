import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AppEvent extends Equatable {
  final List _properties;

  AppEvent([this._properties]);

  @override
  List<Object> get props => this._properties;
}

class Load extends AppEvent {
  Load() : super([]);
}

class Update extends AppEvent {
  Update() : super([]);
}

class Logout extends AppEvent {
  Logout() : super([]);
}