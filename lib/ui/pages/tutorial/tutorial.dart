import 'package:flutter/material.dart';
import '../../../main.dart';

class Tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: PageOne(),
        ),
      ),
    );
  }
}

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
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
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/tutorPageBackgr.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.deepPurple)),
                    padding: EdgeInsets.symmetric(
                        vertical: widthBg * 0.05, horizontal: heightBg * 0.15),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => App()));
                    },
                    color: Colors.deepPurple,
                    child: Text('Get started',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
