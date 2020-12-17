import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';


class TwoPage extends StatefulWidget {
  final double currentPage;
  TwoPage(this.currentPage);
  @override
  _TwoPageState createState() => _TwoPageState();
}

class _TwoPageState extends State<TwoPage> {
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
                    padding: EdgeInsets.only(
                        bottom: 21, top: 21, right: 122, left: 122),
                    onPressed:  () {
                      BlocProvider.of<LoginNavigatorBloc>(context)
                        .add(NavigateToCreateAccount());
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
