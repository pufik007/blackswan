import 'package:flutter_bloc/flutter_bloc.dart';
import './Product.dart';
import './item_card.dart';
import './item_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tensorfit/ui/widgets/map_bloc/bloc.dart' as map;
import 'package:flutter_svg/svg.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import '../../ui/pages/journey_bloc/LevelCardListWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: close_sinks
  final _mapBloc = map.MapBloc();

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
    var theme = Theme.of(context);
    var color = Color.fromARGB(255, 167, 165, 168);
    var style = theme.textTheme.body2.copyWith(color: color);
    var size = 30.0;

    return BlocProvider(
        create: (context) => this._mapBloc,
        child: Scaffold(
          backgroundColor: Colors.indigo[800],
          body: Stack(children: <Widget>[
            LevelCardListWidget(),
            Container(
                child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                Container(
                  padding:
                      new EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
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
                Container(
                  padding: const EdgeInsets.all(5.0),
                  height: 400,
                ),
              ],
            )),
          ]),
        ));
  }

  @override
  void dispose() {
    this._mapBloc.close();
    super.dispose();
  }
}
