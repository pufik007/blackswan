import 'dart:ui';

import 'package:flutter/material.dart';
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
      padding: new EdgeInsets.symmetric(vertical: 200.0, horizontal: 10.0),
      child: Maine(
        level: level,
        isSelected: isSelected,
      ),
    );
  }
}

class Maine extends StatelessWidget {
  final Level level;
  final bool isSelected;
  const Maine({Key key, this.level, this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      color: Colors.white,
      height: 300,
      width: 200,
      child: Text(
        'June 2',
        style: TextStyle(fontSize: 22, color: Colors.black),
      ),
    );

    Container(
      padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
      child: Text(
        'level',
        style: TextStyle(fontSize: 15, color: Colors.black),
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
