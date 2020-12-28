import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tensorfit/data/api/entities/exerciseDetection.dart';
import 'package:tensorfit/data/data.dart';

import '../../pages/level_bloc/level_event.dart';
import './exercise_detection_state.dart';

class ExerciseDetectionBloc extends Bloc<LevelEvent, ExerciseDetectionState> {
  final LevelEvent exerciseID; 
  List<dynamic> _exerciseDetect;

  ExerciseDetectionBloc(this.exerciseID);
    

  @override
  ExerciseDetectionState get initialState => ExerciseDetectionLoading();

  @override
  Stream<ExerciseDetectionState> mapEventToState(LevelEvent event) async* {
    if (event is Load) {
      this._exerciseDetect = await Data.instance.getExerciseDetection(this.exerciseID.toString());
      
      if (_exerciseDetect == null) {
        await new Future.delayed(const Duration(seconds: 5));
        this.add(Load());
      } else {
        yield ExerciseDetectionLoaded(_exerciseDetect);
      }
    } 
  }
}
