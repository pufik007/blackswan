import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tensorfit/ui/widgets/map_bloc/bloc.dart' as map;
import 'level_card_list_widget.dart';
import 'package:tensorfit/data/api/entities/level.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: close_sinks
  final _mapBloc = map.MapBloc();
  Level level;
  ImageProvider image;
  Alignment imageAlign;
  DateTime date;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    this._mapBloc.add(map.Load());
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => this._mapBloc,
      child: Scaffold(
          backgroundColor: Colors.indigo[800],
          body: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                padding:
                    new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: new EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 10.0),
                        child: Text(
                          'Here will be a city allustration',
                          style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                          ),
                        ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          child: Text('Workout plan',
                              style: TextStyle(fontSize: 32, color: Colors.white)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: RaisedButton(
                            onPressed: null, 
                            color: Colors.red, 
                              child: Text('213', 
                                style: TextStyle(
                                  color: Colors.red),
                                ),
                        )
                        )],
                        
                    ),
                  ]
                ),
              ),
              LevelCardListWidget(level, date, image, imageAlign),
            ],
          )),
    );
  }

  @override
  void dispose() {
    this._mapBloc.close();
    super.dispose();
  }
}
