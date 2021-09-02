import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';
import 'package:tensorfit/ui/pages/gender_page.dart';

class ProfilePage extends StatelessWidget {
  final String userEmail;

  ProfilePage(this.userEmail);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('name: $userEmail'),
        backgroundColor: Colors.deepPurple,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       BlocProvider.of<AppBloc>(context).add(Logout());
        //     },
        //     icon: Icon(Icons.logout),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.topLeft,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              onPressed: () {
                BlocProvider.of<HomeNavigatorBloc>(context)
                    .add(NavigateToCreateJourney());
              },
              child: Text(
                'Journey',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.topLeft,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ViewGenderPage(),
                  ),
                );
              },
              child: Text(
                'GenderPage',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
