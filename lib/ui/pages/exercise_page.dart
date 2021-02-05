import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ExercisePage extends StatelessWidget {
  final int id;
  final String name;
  final String description;
  final int duration;

  ExercisePage(this.id, this.description, this.name, this.duration);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('id - $id'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Hero(
              tag: id, 
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset('gif url'),
              ),
            ),
            Card(
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
              child: Container(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Text('$name', style: TextStyle(fontSize: 26.0),),
                    Divider(),
                   
                    Text("$description"),              
                    Text("duration - $duration sec"),              
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}