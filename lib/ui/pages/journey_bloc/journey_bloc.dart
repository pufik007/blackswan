import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tensorfit/data/api/entities/goal.dart';
import 'package:tensorfit/data/app_bloc/bloc.dart' as app;
import 'package:tensorfit/data/data.dart';
import 'package:tensorfit/ui/pages/journey_bloc/user_data_type.dart';
import 'package:tensorfit/ui/pages/journey_bloc/user_gender_type.dart';

import 'journey_event.dart';
import 'journey_state.dart';

enum JourneyInputType {
  UserData,
  UserGoal,
}

class JourneyBloc extends Bloc<JourneyEvent, JourneyState> {
  final app.AppBloc _appBloc;

  JourneyBloc(
    this._appBloc,
    this._fillUserData,
    this._dateOfBirth,
    this._weight,
    this._height,
    this._gender,
    this._selectedGoals,
  );

  bool _fillUserData;

  JourneyInputType _inputType;

  UserDataType _userDataType = UserDataType.DateOfBirth;
  DateTime _dateOfBirth;
  int _weight;
  int _height;
  UserGenderType _gender;

  List<int> _selectedGoals;

  @override
  JourneyState get initialState {
    this._inputType = this._fillUserData ? JourneyInputType.UserData : JourneyInputType.UserGoal;
    return this._state();
  }

  @override
  Stream<JourneyState> mapEventToState(JourneyEvent event) async* {
    if (event is Prev) {
      if (this._inputType == JourneyInputType.UserData) {
        var index = UserDataType.values.indexOf(this._userDataType) - 1;
        if (index >= 0) {
          this._userDataType = UserDataType.values[index];
          yield this._state(jump: true);
        }
      } else if (this._fillUserData) {
        this._inputType = JourneyInputType.UserData;
        this._selectedGoals.clear();
        yield this._state(jump: true);
      }
    } else if (event is Next) {
      var index = UserDataType.values.indexOf(this._userDataType) + 1;
      if (index < UserDataType.values.length) {
        this._userDataType = UserDataType.values[index];
        yield this._state(jump: true);
      }
    } else if (event is UpdateUser) {
      var res = await Data.instance.fillUserData(this._dateOfBirth, this._height, this._weight, this._gender);
      if (res == null) {
        this._inputType = JourneyInputType.UserGoal;
        yield this._state();
      }
    } else if (event is CreateJourney) {
      var goals = List<Goal>();
      for(var goal in Data.instance.goals) {
        if(this._selectedGoals.contains(goal.id)) {
          goals.add(goal);
        }
      }
      await Data.instance.createJourney(goals);
      this._appBloc.add(app.Update());
    } else if (event is SelectDateOfBirth) {
      if (this._userDataType == UserDataType.DateOfBirth) {
        this._dateOfBirth = event.dateOfBirth;
        yield this._state();
      }
    } else if (event is SelectHeight) {
      if (this._userDataType == UserDataType.Height) {
        this._height = event.height;
        yield this._state();
      }
    } else if (event is SelectWeight) {
      if (this._userDataType == UserDataType.Weight) {
        this._weight = event.weight;
        yield this._state();
      }
    } else if (event is SelectGender) {
      if (this._userDataType == UserDataType.Gender) {
        this._gender = event.gender;
        yield this._state();
      }
    } else if (event is SelectGoal) {
      if (this._inputType == JourneyInputType.UserGoal && !this._selectedGoals.contains(event.goalID) && this._selectedGoals.length < 2) {
        this._selectedGoals.add(event.goalID);
        yield this._state();
      }
    } else if (event is DeselectGoal) {
      if (this._inputType == JourneyInputType.UserGoal && this._selectedGoals.contains(event.goalID)) {
        this._selectedGoals.remove(event.goalID);
        yield this._state();
      }
    }
  }

  JourneyState _state({bool jump = false}) {
    if (this._inputType == JourneyInputType.UserData) {
      return JourneyDataState(this._userDataType, jump, this._dateOfBirth, this._weight, this._height, this._gender);
    } else {
      var goals = List<Goal>();
      for (var value in Data.instance.goals) {
        switch (this._gender) {
          case UserGenderType.Female:
            if (value.gender == 'female') {
              goals.add(value);
            }
            break;
          default:
            if (value.gender == 'male') {
              goals.add(value);
            }
            break;
        }
      }

      return JourneyGoalState(this._fillUserData, goals, this._selectedGoals);
    }
  }
}
