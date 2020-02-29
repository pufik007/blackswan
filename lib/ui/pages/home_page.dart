import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/app_bloc/app_bloc.dart';
import 'package:tensorfit/data/app_bloc/app_event.dart';
import 'package:tensorfit/data/data.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(Data.instance.journey.body),
            FlatButton(
              color: theme.buttonColor,
              highlightColor: theme.highlightColor,
              splashColor: theme.splashColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Text('Logout', style: theme.primaryTextTheme.button),
              onPressed: () {
                BlocProvider.of<AppBloc>(context).add(Logout());
              },
            ),
            FlatButton(
              color: theme.buttonColor,
              highlightColor: theme.highlightColor,
              splashColor: theme.splashColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Text('Reset Journey', style: theme.primaryTextTheme.button),
              onPressed: () {
                BlocProvider.of<HomeNavigatorBloc>(context).add(NavigateToCreateJourney());
              },
            ),
          ],
        ),
      ),
    );
  }
}
