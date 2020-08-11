import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/ui/pages/level_bloc/bloc.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';
import 'level_bloc/level_bloc.dart';

class LevelPage extends StatelessWidget {
  final Level level;
  final ImageProvider image;
  final Alignment imageAlign;
  final Color _bgColor = const Color.fromARGB(255, 18, 11, 25);

  const LevelPage(this.level, this.image, this.imageAlign);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this._bgColor,
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
          BlocProvider.of<HomeNavigatorBloc>(context)
              .add(NavigateToCameraPredictionPage(
            level,
          ));
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
                  this._buildExercises(context, state.exercises),
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

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2.5,
          child: Container(
            alignment: this.imageAlign,
            child: AspectRatio(
              aspectRatio: 2,
              child: Transform.scale(
                  scale: 2,
                  child: Transform.translate(
                    offset: Offset(
                        this.imageAlign == Alignment.centerRight
                            ? offset
                            : -offset,
                        offset),
                    child: Image(
                      image: this.image,
                    ),
                  )),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 5,
              child: Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: color),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [this._bgColor, Colors.transparent],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 10,
                      child: Container(
                        padding: EdgeInsets.only(left: 12),
                        alignment: Alignment.centerLeft,
                        child: Text('Workout plan',
                            style: theme.primaryTextTheme.title),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 10,
                      child: Container(
                        padding: EdgeInsets.only(left: 12),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.directions_run, color: color),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('${exercises.length} exercises',
                                  style: theme.primaryTextTheme.subtitle),
                            ),
                            Icon(Icons.alarm, color: color),
                            SizedBox(width: 10),
                            Text('$duration min',
                                style: theme.primaryTextTheme.subtitle),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.chevron_left,
                                      color: Colors.blue),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.chevron_right, color: Colors.blue),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildExercises(BuildContext context, List<ExerciseInfo> exercises) {
    exercises.sort((a, b) => a.position.compareTo(b.position));
    var theme = Theme.of(context);
    var info = MediaQuery.of(context);
    var padding = info.size.width / 25;

    var items = List<Widget>();

    for (final exercise in exercises) {
      var duration;
      if (exercise.duration == null) {
        duration = '${exercise.numberOfReps ?? 0} times';
      } else if (exercise.duration > 60) {
        if (exercise.duration % 60 == 0) {
          duration = '${(exercise.duration / 60).floor()} min';
        } else {
          duration =
              '${(exercise.duration / 60).floor()} min ${exercise.duration % 60} sec';
        }
      } else {
        duration = '${exercise.duration ?? 0} sec';
      }

      var actions = List<Widget>();

      // if (exercise.difficulty != 'easy') {
      //   actions.add(Dismissible(
      //     child: Container(),
      //     key: UniqueKey(),
      //     onDismissed: (direction) {
      //       BlocProvider.of<LevelBloc>(context)
      //           .add(EasierExercise(exercise.id));
      //     },
      //   ));
      // }
      // if (exercise.difficulty != 'hard') {
      //   actions.add(IconSlideAction(
      //     color: Colors.deepOrange[300],
      //     foregroundColor: Colors.white,
      //     icon: Icons.arrow_upward,
      //     onTap: () {
      //       BlocProvider.of<LevelBloc>(context)
      //           .add(HarderExercise(exercise.id));
      //     },
      //   ));
      // }

      items.add(Dismissible(
        background: Container(color: Colors.red),
        secondaryBackground: Container(
          color: Colors.blue,
        ),
        key: UniqueKey(),
        confirmDismiss: (DismissDirection direction) async {
          Future<bool> isDifficultyChangeAllowed;
          if (direction == DismissDirection.startToEnd) {
            isDifficultyChangeAllowed =
                checkIfDifficultyChangeAllowed(exercise.difficulty, "easy");
          } else {
            isDifficultyChangeAllowed =
                checkIfDifficultyChangeAllowed(exercise.difficulty, "hard");
          }
          return isDifficultyChangeAllowed;
        },
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.startToEnd) {
            BlocProvider.of<LevelBloc>(context)
                .add(EasierExercise(exercise.id));
          } else {
            BlocProvider.of<LevelBloc>(context)
                .add(HarderExercise(exercise.id));
          }
        },
        child: Material(
          color: Colors.white,
          child: RawMaterialButton(
            child: Container(
              height: info.size.width / 4,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: padding,
                        right: padding,
                        bottom: padding / 2,
                        top: padding / 2),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      // child: Image(
                      //     image: AssetImage('assets/test.png'),
                      //     fit: BoxFit.cover),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: theme.disabledColor),
                      )),
                      margin: EdgeInsets.only(right: padding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(exercise.exercise.name,
                              style: theme.textTheme.subhead),
                          Text(duration,
                              style: theme.textTheme.subhead
                                  .copyWith(color: theme.disabledColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {},
          ),
        ),
      ));
    }

    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: this._bgColor,
          ),
          child: FractionallySizedBox(
            widthFactor: 0.95,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(padding),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(top: padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> checkIfDifficultyChangeAllowed(
      String difficulty, String boundary) async {
    return difficulty != boundary;
  }
}
