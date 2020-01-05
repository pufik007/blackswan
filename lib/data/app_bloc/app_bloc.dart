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
        yield LoggedIn(this._getTheme());
      }
    } else if (event is Login) {
      yield LoggedIn(this._getTheme());
    } else if (event is Logout) {
      await Data.instance.logout();
      yield LoggedOff(this._getTheme());
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
