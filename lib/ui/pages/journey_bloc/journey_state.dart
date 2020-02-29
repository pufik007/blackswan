import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tensorfit/data/api/entities/goal.dart';
import 'package:tensorfit/ui/pages/journey_bloc/user_data_type.dart';
import 'package:tensorfit/ui/pages/journey_bloc/user_gender_type.dart';

@immutable
abstract class JourneyState extends Equatable {
  JourneyState();
}

class JourneyDataState extends JourneyState {
  final UserDataType type;
  final bool jump;

  final DateTime dateOfBirth;
  final int weight;
  final int height;
  final UserGenderType gender;

  JourneyDataState(
    this.type,
    this.jump,
    this.dateOfBirth,
    this.weight,
    this.height,
    this.gender,
  );

  @override
  List<Object> get props => [this.type, this.jump, this.dateOfBirth, this.weight, this.height, this.gender];
}

class JourneyGoalState extends JourneyState {
  final bool changeUserData;
  final List<Goal> goals;
  final List<int> selectedGoals;

  bool get valid => this.selectedGoals.length > 0;

  bool get selectGoals => this.selectedGoals.length < 2;

  JourneyGoalState(
    this.changeUserData,
    this.goals,
    this.selectedGoals,
  );

  @override
  List<Object> get props => [DateTime.now()];
}
