import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

class NavigateBack extends NavigatorEvent {
  NavigateBack() : super([]);
}