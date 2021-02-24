import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/app_bloc/app_bloc.dart';
import 'package:tensorfit/data/app_bloc/app_event.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';

class ProfilePage extends StatelessWidget {
  final String userEmail;

  ProfilePage(this.userEmail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            alignment: Alignment.topLeft,
            color: Colors.white,
            child: Text(
              "Логин - $userEmail",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.topLeft,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  BlocProvider.of<AppBloc>(context).add(Logout());
                },
                color: Colors.deepPurple,
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.topLeft,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  BlocProvider.of<HomeNavigatorBloc>(context)
                      .add(NavigateToCreateJourney());
                },
                color: Colors.deepPurple,
                child: Text(
                  'Journey',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
