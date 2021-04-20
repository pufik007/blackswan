import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class PageThree extends StatefulWidget {
  final double currentPage;
  PageThree(this.currentPage);
  @override
  _PageThreeState createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/journey.png'), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Our built-in fitness generator makes ',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'your personal training progarmm',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ]),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20.0, top: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.deepPurple)),
              padding: EdgeInsets.symmetric(
                  vertical: widthBg * 0.05, horizontal: heightBg * 0.15),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => App()));
              },
              color: Colors.deepPurple,
              child: Text('Get started',
                  style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          ),
          DotsIndicator(
            dotsCount: 3,
            decorator: DotsDecorator(activeColor: Colors.white),
            position: widget.currentPage,
          ),
          SizedBox(
            height: 52,
          )
        ],
      ),
    );
  }
}
