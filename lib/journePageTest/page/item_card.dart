import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/ui/pages/level_bloc/bloc.dart';

import '../../ui/pages/level_bloc/level_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ItemCard extends StatelessWidget {
  final Level level;

  const ItemCard(this.level);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: this._buildBody(context),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange[800],
        elevation: 6.0,
        child: Icon(
          Icons.play_circle_outline,
          size: 50.0,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/ui/camera.dart');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => LevelBloc(this.level)..add(Load()),
      child: BlocBuilder<LevelBloc, LevelState>(
        builder: (context, state) {
          if (state is LevelLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is LevelLoaded) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  this._buildHeader(context, state.exercises),
                ],
              ),
            );
          }

          return null;
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<ExerciseInfo> exercises) {
    var theme = Theme.of(context);
    var color = Colors.white;

    var info = MediaQuery.of(context);
    var offset = info.size.width / 25;

    var duration = 0;
    for (final exercise in exercises) {
      if (exercise.duration != null) {
        duration += (exercise.duration / 60).floor();
      }
    }

    return Container(
      width: 220,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(8.5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (context) => ItemPage(productId: product.id)),
              // );
            },
            child: Row(
              children: <Widget>[
                Container(
                  height: 0,
                ),
                Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    color: Colors.red,
                    width: 220,
                    height: 50,
                    child: Text(
                      'title',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    )),
              ],
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            color: Colors.red,
            height: 60,
            child: Text(
              'title',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Text(
              'level',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              'description',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          AspectRatio(
            aspectRatio: 8.5,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                child: Row(children: <Widget>[
                  Icon(Icons.alarm, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    'time',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )
                ])),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
            child: AspectRatio(
              aspectRatio: 5.1,
              child: SvgPicture.asset(
                'assets/map/stars/stars_0.svg',
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
