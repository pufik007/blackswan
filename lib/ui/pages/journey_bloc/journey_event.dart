import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tensorfit/ui/pages/journey_bloc/user_gender_type.dart';

@immutable
abstract class JourneyEvent extends Equatable {
  final List _properties;

  JourneyEvent([this._properties]);

  @override
  List<Object> get props => this._properties;
}

class SelectDateOfBirth extends JourneyEvent {
  final DateTime dateOfBirth;

  SelectDateOfBirth(this.dateOfBirth) : super([dateOfBirth]);
}

class SelectWeight extends JourneyEvent {
  final int weight;

  SelectWeight(this.weight) : super([weight]);
}

class SelectHeight extends JourneyEvent {
  final int height;

  SelectHeight(this.height) : super([height]);
}

class SelectGender extends JourneyEvent {
  final UserGenderType gender;

  SelectGender(this.gender) : super([gender]);
}

class SelectGoal extends JourneyEvent {
  final int goalID;

  SelectGoal(this.goalID) : super([goalID]);
}

class DeselectGoal extends JourneyEvent {
  final int goalID;

  DeselectGoal(this.goalID) : super([goalID]);
}

class Prev extends JourneyEvent {
  Prev() : super([]);
}

class Next extends JourneyEvent {
  Next() : super([]);
}

class UpdateUser extends JourneyEvent {
  UpdateUser() : super([]);
}

class CreateJourney extends JourneyEvent {
  CreateJourney() : super([]);
}