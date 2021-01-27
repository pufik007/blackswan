import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../main.dart';

class PageTwo extends StatefulWidget {
  final double currentPage;
  PageTwo(this.currentPage);
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);

        setState(() {});
      });
  }

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
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xffb55e28),
          accentColor: Color(0xffffd544),
        ),
        home: SafeArea(
            child: Scaffold(
                body: Stack(children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size?.width ?? 0,
                height: _controller.value.size?.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Text(
                          'Tracks any exercise',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Our cutting edge AI technology knows',
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          'you better than real coach',
                          style: TextStyle(fontSize: 17),
                        )
                      ]),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.deepPurple)),
                    padding: EdgeInsets.symmetric(
                        vertical: widthBg * 0.05, horizontal: heightBg * 0.15),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => App()));
                      setState(() {
                        _controller.setVolume(0);
                      });
                    },
                    color: Colors.deepPurple,
                    child: Text('Get started',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 52.0),
                  child: DotsIndicator(
                    dotsCount: 6,
                    decorator: DotsDecorator(activeColor: Colors.black),
                    position: widget.currentPage,
                  ),
                ),
              ],
            ),
          )
        ]))));
  }
}
