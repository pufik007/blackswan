import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';
import 'package:tensorfit/ui/pages/level_bloc/bloc.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';

import '../../widgets/map_bloc/bloc.dart';

class LevelCardListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      bloc: BlocProvider.of<MapBloc>(context),
      builder: (context, state) {
        if (state is MapInit || state is MapLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is MapLoaded) {
          return this._getLevelCardList(state.levels, state.selectedLevelID);
        }

        return null;
      },
    );
  }

  Widget _getLevelCardList(List<Level> levels, int selectedLevelID) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              this._getLevels(
                  context, constraints.maxWidth, levels, selectedLevelID),
            ],
          ),
        );
      },
    );
  }

  Widget _getLevels(
      context, double width, List<Level> levels, int selectedLevelID) {
    var items = List<Widget>();
    var houseCount = levels.length;
    for (int i = 0; i < houseCount; i++) {
      var level = levels[i];
      items.add(this._getLevel(level, level.id == selectedLevelID));
    }
    return Row(
      children: items,
    );
  }

  Widget _getLevel(Level level, bool isSelected) {
    return Container(
      padding: new EdgeInsets.symmetric(vertical: 160.0, horizontal: 10.0),
      child: Maine(
        level: level,
        isSelected: isSelected,
      ),
    );
  }
}

Widget title() {
  return Container(
    padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    height: 40,
    width: 300,
    color: Colors.green[300],
    child: Align(
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(
          text: 'June 2',
          style: TextStyle(color: Colors.white, fontSize: 25),
          children: <TextSpan>[],
        ),
      ),
    ),
  );
}

Widget subTitle() {
  return Container(
    padding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    height: 60,
    width: 320,
    color: Colors.green[300],
    child: Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          text: 'Here will be some text to motivate users do exercise',
          style: TextStyle(color: Colors.white, fontSize: 13),
          children: <TextSpan>[],
        ),
      ),
    ),
  );
}

Widget firstLevel(level) {
  return Container(
    padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          text: 'Level ${level.number}',
          style: TextStyle(color: Colors.black, fontSize: 13),
          children: <TextSpan>[],
        ),
      ),
    ),
  );
}

Widget firstExercises() {
  return Container(
    padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          text: 'Exercise 5',
          style: TextStyle(color: Colors.black, fontSize: 13),
          children: <TextSpan>[],
        ),
      ),
    ),
  );
}

Widget firstDuration() {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(children: <Widget>[
        Icon(
          Icons.alarm,
          color: Colors.black,
          size: 15,
        ),
        SizedBox(width: 10),
        Text(
          '20 min',
          style: TextStyle(fontSize: 15, color: Colors.black),
        )
      ]));
}

Widget iconStars() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 55.0, horizontal: 20.0),
    child: AspectRatio(
      aspectRatio: 5,
      child: SvgPicture.asset(
        'assets/map/stars/stars_0.svg',
        alignment: Alignment.topCenter,
      ),
    ),
  );
}

class Maine extends StatelessWidget {
  final Level level;
  final bool isSelected;
  const Maine({Key key, this.level, this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: 520,
      width: 220,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Stack(children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            title(),
                            subTitle(),
                            firstLevel(level),
                            firstExercises(),
                            firstDuration(),
                            iconStars()
                          ],
                        )
                      ],
                    ))
              ],
            ),
          )
        ]),
      ),
    );

    Container(
      padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: Text(
        'description',
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
    );
    AspectRatio(
      aspectRatio: 1,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Row(children: <Widget>[
            Icon(Icons.alarm, color: Colors.black),
            SizedBox(width: 10),
            Text(
              'time',
              style: TextStyle(fontSize: 15, color: Colors.black),
            )
          ])),
    );
    Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: AspectRatio(
        aspectRatio: 5.1,
        child: SvgPicture.asset(
          'assets/map/stars/stars_0.svg',
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
