import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AppState extends Equatable {
  final List _properties;

  AppState([this._properties]);

  @override
  List<Object> get props => this._properties;
}

class Loading extends AppState {
  Loading() : super([]);
}

class LoggedOff extends AppState {
  final ThemeData theme;

  LoggedOff(this.theme) : super([theme]);
}

class LoggedIn extends AppState {
  final ThemeData theme;

  LoggedIn(this.theme) : super([theme]);
}

class JourneyCreation extends AppState {
  final ThemeData theme;
  final bool fillUserData;

  JourneyCreation(this.theme, this.fillUserData) : super([theme,fillUserData]);
}

class JourneyValidation extends AppState {
  final ThemeData theme;

  JourneyValidation(this.theme) : super([theme]);
}