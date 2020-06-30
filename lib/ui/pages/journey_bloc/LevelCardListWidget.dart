import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';
import 'package:tensorfit/ui/pages/level_bloc/bloc.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';

import '../../widgets/map_bloc/bloc.dart';

class LevelCardListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      bloc: BlocProvider.of<MapBloc>(context),
      builder: (context, state) {
        if (state is MapInit || state is MapLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is MapLoaded) {
          return this._getLevelCardList(state.levels, state.selectedLevelID);
        }

        return null;
      },
    );
  }

  Widget _getLevelCardList(List<Level> levels, int selectedLevelID) {
    var size = 30.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          reverse: true,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size,
              ),
              this._getLevels(
                  context, constraints.maxWidth, levels, selectedLevelID),
              SizedBox(
                height: size * 2 + 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getLevels(
      context, double width, List<Level> levels, int selectedLevelID) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(8.5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //       builder: (context) => ItemPage(productId: product.id)),
              // );
            },
            child: Row(
              children: <Widget>[
                Container(
                  height: 0,
                ),
                Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    color: Colors.red,
                    width: 220,
                    height: 50,
                    child: Text(
                      'title',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    )),
              ],
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            color: Colors.red,
            height: 60,
            child: Text(
              'exercises',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Text(
              'level',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              'description',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          AspectRatio(
            aspectRatio: 8.5,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                child: Row(children: <Widget>[
                  Icon(Icons.alarm, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    'time',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )
                ])),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
            child: AspectRatio(
              aspectRatio: 5.1,
              child: SvgPicture.asset(
                'assets/map/stars/stars_0.svg',
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
