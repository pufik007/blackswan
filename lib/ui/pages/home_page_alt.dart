import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tensorfit/ui/widgets/map_bloc/bloc.dart' as map;
import 'level_card_list_widget.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import './home_page.dart';
import './profile_page.dart';
import '../../data/api/entities/user.dart';

class HomePageAlt extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageAlt> {
  // ignore: close_sinks
  final _mapBloc = map.MapBloc();
  Level level;
  ImageProvider image;
  Alignment imageAlign;
  DateTime date;
  String userEmail;
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
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text('Workout plan',
                                style: TextStyle(
                                    fontSize: 32, color: Colors.white)),
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage()));
                                    },
                                    color: Colors.deepPurple,
                                    child: Text(
                                      'Change',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                  _mapBloc.state.userEmail)));
                                    },
                                    color: Colors.deepPurple,
                                    child: Text(
                                      'Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                      Container(
                          height: 400,
                          child: LevelCardListWidget(
                              level, date, image, imageAlign, userEmail)),
                    ]),
              ),
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
