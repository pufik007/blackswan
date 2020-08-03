import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import '../../ui/widgets/map_bloc/bloc.dart';
import 'package:tensorfit/ui/widgets/map_bloc/bloc.dart' as level;
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/ui/pages/level_bloc/bloc.dart';
import '../../ui/pages/level_bloc/level_bloc.dart';

class ExerciseLevelCameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      bloc: BlocProvider.of<MapBloc>(context),
      builder: (context, state) {
        if (state is MapInit || state is MapLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is MapLoaded) {
          return _getLevels(state.levels, state.selectedLevelID);
        }
        return null;
      },
    );
  }
}

Widget _getLevels(List<Level> levels, int selectedLevelID) {
  var items = List<Widget>();
  var houseCount = levels.length;
  for (int i = 0; i < houseCount; i++) {
    var level = levels[i];
    items.add(_getLevel(level, level.id == selectedLevelID));
  }
  return Text(
    " min",
    style: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 50,
    ),
  );
}

Widget _getLevel(Level level, bool isSelected) {
  return Container(
    child: LevelCard(
      level: level,
      isSelected: isSelected,
    ),
  );
}

class LevelCard extends StatelessWidget {
  final Level level;
  final bool isSelected;
  const LevelCard({Key key, this.level, this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 550.0),
        child: (level != null)
            ? Text("")
            : Text(
                "$level.number min",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
      ),
    );
  }
}
