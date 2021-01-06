import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../data/data.dart';
import './exercise_detection_state.dart';
import './exercise_detection_event.dart';

class ExerciseDetectionBloc extends Bloc<ExerciseDetectionEvent, ExerciseDetectionState> {
  final String exerciseID; 
  List<dynamic> _exerciseDetect;

  ExerciseDetectionBloc(this.exerciseID);
    

  @override
  ExerciseDetectionState get initialState => ExerciseDetectionLoading();

  @override
  Stream<ExerciseDetectionState> mapEventToState(ExerciseDetectionEvent event) async* {
    if (event is LoadExerciseDetection) {
      this._exerciseDetect = await Data.instance.getExerciseDetection(this.exerciseID.toString());
      
      if (_exerciseDetect == null) {
        await new Future.delayed(const Duration(seconds: 5));
        this.add(LoadExerciseDetection());
      } else {
        yield ExerciseDetectionLoaded(_exerciseDetect);
      }
    } 
  }
}
