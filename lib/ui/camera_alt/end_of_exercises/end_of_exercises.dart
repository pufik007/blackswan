import 'package:flutter/material.dart';

import '../../../data/api/entities/level.dart';
import '../../../ui/pages/level_page.dart';

class EndOfExercisesPage extends StatelessWidget {
  final Level level;

  EndOfExercisesPage(this.level);

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
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: widthBg * 0.9,
              height: heightBg * 0.77,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/backgroundEndOfExercises.png'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: heightBg * 0.1,
                  ),
                  Text(
                    'Well done!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: heightBg * 0.04,
                  ),
                  Text(
                    'YOUR RESULT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: heightBg * 0.04,
                  ),
                  Text(
                    '6',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: heightBg * 0.04,
                  ),
                  Text(
                    'EXERCISES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: heightBg * 0.04,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 12),
                    width: widthBg * 0.75,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[700],
                    ),
                    child: Text(
                      '1 m : 50 sec',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: heightBg * 0.02,
                  ),
                  // Container(
                  //   width: widthBg * 0.75,
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       top: BorderSide(width: 3.0, color: Colors.white),
                  //       left: BorderSide(width: 3.0, color: Colors.white),
                  //       right: BorderSide(width: 3.0, color: Colors.white),
                  //       bottom: BorderSide(width: 3.0, color: Colors.white),
                  //     ),
                  //     borderRadius: BorderRadius.circular(5),
                  //   ),
                  // child: RaisedButton(
                  //     color: Colors.transparent,
                  //     elevation: 0,
                  //     onPressed: () {},
                  //     child: RaisedButton(
                  //       onPressed: () {
                  //         Navigator.of(context).push(MaterialPageRoute(
                  //             builder: (context) => CheckMyTraining()));
                  //       },
                  //       child: Text(
                  //         'CHECK MY TRAINING BY COACH',
                  //         style: TextStyle(color: Colors.white, fontSize: 15),
                  //       ),
                  //       color: Colors.transparent,
                  //       elevation: 0,
                  //     )),
                  // ),
                  // SizedBox(
                  //   height: heightBg * 0.02,
                  // ),
                  // Container(
                  //   width: widthBg * 0.75,
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       top: BorderSide(width: 3.0, color: Colors.white),
                  //       left: BorderSide(width: 3.0, color: Colors.white),
                  //       right: BorderSide(width: 3.0, color: Colors.white),
                  //       bottom: BorderSide(width: 3.0, color: Colors.white),
                  //     ),
                  //     borderRadius: BorderRadius.circular(5),
                  //   ),
                  //   child: RaisedButton(
                  //     color: Colors.transparent,
                  //     elevation: 0,
                  //     onPressed: () {},
                  //     child: Text(
                  //       'SHARE MY RESULT',
                  //       style: TextStyle(color: Colors.white, fontSize: 15),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: heightBg * 0.03,
            ),
            Container(
              width: widthBg * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.purple[800],
                onPressed: () {},
                child: Container(
                    child: RaisedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LevelPage(
                            level,
                            Image.asset('assets/map/levels/left/1.png').image,
                            Alignment.centerLeft),
                      ),
                    );
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
