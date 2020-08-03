import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/ui/pages/level_bloc/bloc.dart';
import '../../ui/pages/level_bloc/level_bloc.dart';

class ExerciseLevelCameraPage extends StatelessWidget {
  final Level level;
  const ExerciseLevelCameraPage(this.level);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LevelBloc(level)..add(Load()),
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
                  _getLevels(context, state.exercises),
                ],
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _getLevels(BuildContext context, List<ExerciseInfo> exercises) {
    var duration = 0;
    for (final exercise in exercises) {
      if (exercise.duration != null) {
        duration += (exercise.duration / 60).floor();
      }
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 550.0),
        child: (level != null)
            ? Text("")
            : Text(
                "$duration min",
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
