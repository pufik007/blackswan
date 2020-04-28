import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc();

  @override
  AppState get initialState => Loading();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is Load) {
      await Data.load();
      if (Data.instance.token == null) {
        yield LoggedOff(this._getTheme());
      } else {
        yield await this.checkJourney();
      }
    } else if (event is Update) {
      yield await this.checkJourney();
    } else if (event is Logout) {
      await Data.instance.logout();
      yield LoggedOff(this._getTheme());
    }
  }

  Future<AppState> checkJourney() async {
    var journey = await Data.instance.getJourney(true);

    if (journey == null) {
      return JourneyCreation(this._getTheme(), Data.instance.needFillUserData);
    } else if (journey.state == 'completed') {
      return LoggedIn(this._getTheme());
    } else {
      return JourneyValidation(this._getTheme());
    }
  }

  ThemeData _getTheme() {
    return ThemeData(
      primaryColor: Colors.grey[700],
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.white,
      buttonColor: Color.fromARGB(255, 57, 64, 79),
      textTheme: TextTheme(
        body1: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
      ),
    );
  }
}
