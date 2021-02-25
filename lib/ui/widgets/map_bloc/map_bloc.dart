import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tensorfit/data/data.dart';

import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  @override
  MapState get initialState => MapInit();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is Load) {
      if (this.state is MapInit) {
        yield MapLoading();

        var levels = await Data.instance.getLevels();
        var journey = await Data.instance.getJourney(false);
        var userEmail = Data.instance.getUserEmail();

        if (levels == null || journey == null) {
          await new Future.delayed(const Duration(seconds: 5));
          this.add(Load());
        } else {
          yield MapLoaded(levels, journey.currentLevelID, userEmail);
        }
      }
    }
  }
}
