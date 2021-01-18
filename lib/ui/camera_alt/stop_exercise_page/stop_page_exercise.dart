import 'dart:ui';
import 'package:flutter/material.dart';
import 'info_model.dart';
import 'info_list.dart';

class StopPageExercise extends StatefulWidget {
  @override
  _FivePageState createState() => _FivePageState();
}

class _FivePageState extends State<StopPageExercise> {
  final List<InfoModel> _info = [
    InfoModel(
        id: 'exe1',
        title: 'Наклон спины1',
        subTitle:
            'Перенесите опору на темную сторону силы, колени для слабаков1',
        mistakes: '5'),
    InfoModel(
        id: 'exe2',
        title: 'Наклон спины2',
        subTitle:
            'Перенесите опору на темную сторону силы, колени для слабаков2',
        mistakes: '6'),
    InfoModel(
        id: 'exe3',
        title: 'Наклон спины3',
        subTitle:
            'Перенесите опору на темную сторону силы, колени для слабаков3',
        mistakes: '0'),
    InfoModel(
        id: 'exe4',
        title: 'Наклон спины4',
        subTitle:
            'Перенесите опору на темную сторону силы, колени для слабаков4',
        mistakes: '7'),
    InfoModel(
        id: 'exe5',
        title: 'Наклон спины5',
        subTitle:
            'Перенесите опору на темную сторону силы, колени для слабаков5',
        mistakes: '0'),
    InfoModel(
        id: 'exe6',
        title: 'Наклон спины6',
        subTitle:
            'Перенесите123 опору на темную сторону силы, колени для слабаков5',
        mistakes: '6'),
  ];

  @override
  Widget build(BuildContext context) {
    var heightBg = MediaQuery.of(context).size.height;
    var widthBg = MediaQuery.of(context).size.width;

    if (heightBg != null && widthBg != null) {
      if (heightBg >= 800) {
        heightBg = MediaQuery.of(context).size.height;
      } else {
        heightBg = MediaQuery.of(context).size.height * 1.1;
      }
      if (widthBg >= 380) {
        widthBg = MediaQuery.of(context).size.width;
      } else {
        widthBg = MediaQuery.of(context).size.width * 1.1;
      }
    }
    return Scaffold(
          body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/journey.png'), fit: BoxFit.cover),
            ),
          ),
          Container(
              width: widthBg,
              color: Colors.deepPurple[900],
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 220, bottom: 20, top: 10),
                      child: Text(
                        'Анализ ошибок',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        height: heightBg * 0.6,
                        width: widthBg * 0.9,
                        child: InfoList(_info)),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                          right: heightBg * 0.18,
                          left: heightBg * 0.18,
                          top: 20,
                          bottom: 20),
                      onPressed: () {},
                      child: Text(
                        'Завершить',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ])),
        ],
      ),
    );
  }
}
