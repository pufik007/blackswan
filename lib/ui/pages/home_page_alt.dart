import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tensorfit/ui/widgets/map_bloc/bloc.dart' as map;
import 'level_card_list_widget.dart';

import 'package:tensorfit/ui/pages/level_bloc/bloc.dart';
import 'package:tensorfit/ui/pages/level_bloc/level_bloc.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: close_sinks
  final _mapBloc = map.MapBloc();
  Level level;

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
                child: ListTile(
                  title: Container(
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
                  subtitle: Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Text('Workout plan',
                        style: TextStyle(fontSize: 32, color: Colors.white)),
                  ),
                ),
              ),
              LevelCardListWidget(level),
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
