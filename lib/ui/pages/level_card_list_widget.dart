import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import '../../ui/widgets/map_bloc/bloc.dart';
import '../../data/navigator_bloc/navigator_event.dart';
import '../../data/navigator_bloc/navigator_bloc.dart';
import 'motivational_quotes.dart';

class LevelCardListWidget extends StatelessWidget {
  final Level level;
  final DateTime date;
  final ImageProvider image;
  final Alignment imageAlign;
  final String userEmail;
  final List<Image> imgChoose;

  const LevelCardListWidget(this.level, this.date, this.image, this.imageAlign,
      this.userEmail, this.imgChoose);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      bloc: BlocProvider.of<MapBloc>(context),
      builder: (context, state) {
        if (state is MapInit || state is MapLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is MapLoaded) {
          return this._getLevelCardList(state.levels, state.selectedLevelID,
              date, level, state.userEmail, imgChoose, quotesList);
        }

        return null;
      },
    );
  }

  Widget _getLevelCardList(
    List<Level> levels,
    int selectedLevelID,
    DateTime date,
    Level level,
    user,
    List<Image> imgChoose,
    List<MotivationalQuotes> quotesList,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              this._getLevels(context, constraints.maxWidth, levels,
                  selectedLevelID, date, imgChoose, quotesList),
            ],
          ),
        );
      },
    );
  }

  Widget _getLevels(
    context,
    double width,
    List<Level> levels,
    int selectedLevelID,
    DateTime date,
    List<Image> imgChoose,
    List<MotivationalQuotes> quotesList,
  ) {
    date = DateTime.now();
    var items = List<Widget>();
    var houseCount = levels.length;
    for (int i = 0; i < houseCount; i++) {
      var level = levels[i];
      var correctImg = imgChoose[i];
      var correctQuote = quotesList[i];
      items.add(this._getLevel(
          level, level.id == selectedLevelID, date, correctImg, correctQuote));
      date = date.add(Duration(days: 1));
    }
    return Column(
      children: items,
    );
  }

  Widget _getLevel(Level level, bool isSelected, DateTime date, Image imgChoose,
      MotivationalQuotes correctQuote) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      height: 280,
      width: double.infinity,
      child: LevelCard(
        date: date,
        level: level,
        isSelected: isSelected,
        imgChoose: imgChoose,
        correctQuote: correctQuote,
      ),
    );
  }
}

Widget title(level) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      ),
      color: Colors.deepPurple,
    ),
    padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
    height: 40,
    child: Align(
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(
          text: 'Level ${level.number}',
          style: TextStyle(color: Colors.white, fontSize: 25),
          children: <TextSpan>[],
        ),
      ),
    ),
  );
}

Widget subTitle(motivationText) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    color: Colors.deepPurple,
    child: Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          text: '$motivationText',
          style: TextStyle(color: Colors.white, fontSize: 13),
          children: <TextSpan>[],
        ),
      ),
    ),
  );
}

Widget firstLevel(level) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          text: 'Level ${level.number}',
          style: TextStyle(color: Colors.black, fontSize: 13),
          children: <TextSpan>[],
        ),
      ),
    ),
  );
}

Widget firstExercises(exerciseVariantsCount) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          text: "Exercises - $exerciseVariantsCount",
          style: TextStyle(color: Colors.black, fontSize: 13),
          children: <TextSpan>[],
        ),
      ),
    ),
  );
}

Widget firstDuration(totalDuration) {
  var duration = totalDuration / 60;
  return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(children: <Widget>[
        Icon(
          Icons.access_time,
          color: Colors.black,
          size: 15,
        ),
        SizedBox(width: 10),
        Text(
          '${duration.round()} min',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ]));
}

Widget chooseQuote(correctQuote) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          correctQuote.quote,
          style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
        ),
        SizedBox(width: 10),
        Text(
          correctQuote.source,
          style: TextStyle(fontSize: 12),
        )
      ],
    ),
  );
}

class LevelCard extends StatelessWidget {
  final Level level;
  final bool isSelected;
  final String motivationText;
  final DateTime date;
  final ImageProvider image;
  final Alignment imageAlign;
  final Image imgChoose;
  final MotivationalQuotes correctQuote;

  const LevelCard({
    Key key,
    this.level,
    this.isSelected,
    this.motivationText,
    this.date,
    this.image,
    this.imageAlign,
    this.imgChoose,
    this.correctQuote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          BlocProvider.of<HomeNavigatorBloc>(context).add(NavigateToLevel(
              level,
              Image.asset('assets/map/levels/left/1.png').image,
              Alignment.centerLeft));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black12,
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          height: 520,
          width: 220,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Stack(children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 0, top: 0),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                title(level),
                                subTitle(level.motivationText),
                                firstLevel(level),
                                firstExercises(level.exerciseVariantsCount),
                                firstDuration(level.totalDuration),
                                chooseQuote(correctQuote),
                              ],
                            )
                          ],
                        ))
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
