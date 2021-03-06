import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tensorfit/data/api/entities/exercise_detection.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/data/data.dart';

import 'level_event.dart';
import 'level_state.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final Level level;

  List<ExerciseInfo> _exercises;
  List<ExerciseDetection> _exerciseDetection;

  LevelBloc(this.level);

  @override
  LevelState get initialState => LevelLoading();

  @override
  Stream<LevelState> mapEventToState(LevelEvent event) async* {
    if (event is Load) {
      this._exercises = await Data.instance.getExercises(this.level);
      if (this._exercises == null) {
        await new Future.delayed(const Duration(seconds: 5));
        this.add(Load());
      } else {
        yield LevelLoaded(this.level, this._exercises, this._exerciseDetection);
      }
    } else if (event is LoadDetections) {
      this._exerciseDetection =
          await Data.instance.getExerciseDetection(event.exerciseIds);
      if (this._exerciseDetection == null) {
        await new Future.delayed(const Duration(seconds: 5));
        this.add(LoadDetections(event.exerciseIds));
      } else {
        yield ExerciseDetectionLoaded(this._exerciseDetection, this._exercises);
      }
    } else if (event is HarderExercise) {
      for (int i = 0; i < this._exercises.length; i++) {
        if (this._exercises[i].id == event.exerciseID) {
          var exercise = this._exercises[i];

          var newDifficulty;
          switch (exercise.difficulty) {
            case 'easy':
              newDifficulty = 'normal';
              break;
            case 'normal':
              newDifficulty = 'hard';
              break;
            default:
              return;
          }

          for (var sub in exercise.substitutes) {
            if (sub.difficulty == newDifficulty) {
              var error =
                  await Data.instance.replaceExercise(exercise.id, sub.id);
              if (error == null) {
                this.add(Load());
              }
              return;
            }
          }
        }
      }
    } else if (event is EasierExercise) {
      for (int i = 0; i < this._exercises.length; i++) {
        if (this._exercises[i].id == event.exerciseID) {
          var exercise = this._exercises[i];

          var newDifficulty;
          switch (exercise.difficulty) {
            case 'hard':
              newDifficulty = 'normal';
              break;
            case 'normal':
              newDifficulty = 'easy';
              break;
            default:
              return;
          }

          for (var sub in exercise.substitutes) {
            if (sub.difficulty == newDifficulty) {
              var error =
                  await Data.instance.replaceExercise(exercise.id, sub.id);
              if (error == null) {
                this.add(Load());
              }
              return;
            }
          }
        }
      }
    }
  }
}
