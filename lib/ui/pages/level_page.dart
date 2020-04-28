import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/ui/pages/level_bloc/bloc.dart';
import 'package:tensorfit/ui/widgets/login_adapt.dart';

import 'level_bloc/level_bloc.dart';

class LevelPage extends StatelessWidget {
  final Level level;

  const LevelPage(this.level);

  @override
  Widget build(BuildContext context) {
    return LoginAdapt(
      child: this._buildBody(context),
      minAspectRatio: 0.7,
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => LevelBloc(this.level)..add(Load()),
      child: BlocBuilder<LevelBloc, LevelState>(
        //bloc: BlocProvider.of<MapBloc>(context),
        builder: (context, state) {
          if (state is LevelLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is LevelLoaded) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Level ${state.level.number}'),
                      Text('Diamonds: ${state.level.diamondsReward}'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.exercises.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.exercises[index].exercise.name),
                        subtitle: Text(state.exercises[index].exercise.description),
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return null;
        },
      ),
    );
  }
}
