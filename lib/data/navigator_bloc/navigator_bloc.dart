import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'navigator_event.dart';

abstract class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigateBack) {
      if (navigatorKey.currentState.canPop()) {
        navigatorKey.currentState.pop();
      }
    }
  }
}

class LoginNavigatorBloc extends NavigatorBloc {
  LoginNavigatorBloc({GlobalKey<NavigatorState> navigatorKey})
      : super(navigatorKey: navigatorKey);

  @override
  Stream<dynamic> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigateToLogIn) {
      navigatorKey.currentState.pushNamed('/log_in');
    } else if (event is NavigateToCreateAccount) {
      navigatorKey.currentState.pushNamed('/create_account');
    }

    yield* super.mapEventToState(event);
  }
}

class HomeNavigatorBloc extends NavigatorBloc {
  HomeNavigatorBloc({GlobalKey<NavigatorState> navigatorKey})
      : super(navigatorKey: navigatorKey);

  @override
  Stream<dynamic> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigateToCreateJourney) {
      navigatorKey.currentState.pushNamed('/create_journey');
    } else if (event is NavigateToLevel) {
      navigatorKey.currentState.pushNamed('/level',
          arguments: [event.level, event.image, event.imageAlign]);
    } else if (event is NavigateToCameraPredictionPage) {
      navigatorKey.currentState
          .pushNamed('/camera_prediction_page', arguments: [event.level, event.exerciseDetections]);
    }

    yield* super.mapEventToState(event);
  }
}
