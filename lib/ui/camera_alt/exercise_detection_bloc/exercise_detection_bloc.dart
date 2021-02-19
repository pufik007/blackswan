import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../data/data.dart';
import './exercise_detection_state.dart';
import './exercise_detection_event.dart';
import '../../../data/api/entities/exercise_info.dart';

class ExerciseDetectionBloc
    extends Bloc<ExerciseDetectionEvent, ExerciseDetectionState> {
  final List<String> exerciseID;
  List<dynamic> _exerciseDetect;
  List<ExerciseInfo> exercises;

  ExerciseDetectionBloc(this.exerciseID);

  @override
  ExerciseDetectionState get initialState => ExerciseDetectionLoading();

  @override
  Stream<ExerciseDetectionState> mapEventToState(
      ExerciseDetectionEvent event) async* {
    if (event is LoadExerciseDetection) {
      this._exerciseDetect =
          await Data.instance.getExerciseDetection(this.exerciseID);

      if (_exerciseDetect == null) {
        await new Future.delayed(const Duration(seconds: 5));
        this.add(LoadExerciseDetection());
      } else {
        yield ExerciseDetectionLoad(_exerciseDetect, exercises);
      }
    }
  }
}
