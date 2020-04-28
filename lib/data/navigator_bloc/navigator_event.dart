import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tensorfit/data/api/entities/level.dart';

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

  NavigateToLevel(this.level) : super([level]);
}

class NavigateBack extends NavigatorEvent {
  NavigateBack() : super([]);
}