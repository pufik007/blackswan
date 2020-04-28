import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/data/data.dart';

import 'level_event.dart';
import 'level_state.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final Level level;

  LevelBloc(this.level);

  @override
  LevelState get initialState => LevelLoading();

  @override
  Stream<LevelState> mapEventToState(LevelEvent event) async* {
    if (event is Load) {
      var exercises = await Data.instance.getExercises(this.level);

      if (exercises == null) {
        await new Future.delayed(const Duration(seconds: 5));
        this.add(Load());
      } else {
        yield LevelLoaded(this.level, exercises);
      }
    }
  }
}
