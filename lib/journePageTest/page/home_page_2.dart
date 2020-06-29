import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(0.0),
          margin: EdgeInsets.symmetric(vertical: 140.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 200.0,
                color: Colors.grey[400],
                child: Text("June 2"),
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(15.0),
              ),
              Container(
                width: 200.0,
                color: Colors.blue,
                child: Text("June 3"),
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(15.0),
              ),
              Container(
                width: 200.0,
                color: Colors.green,
                child: Text("June 4"),
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(15.0),
              ),
              Container(
                width: 200.0,
                color: Colors.yellow,
                child: Text("June 5"),
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.all(15.0),
              ),
              Container(
                width: 200.0,
                color: Colors.orange,
                child: Text("June 6"),
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
