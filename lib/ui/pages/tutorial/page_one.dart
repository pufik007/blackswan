import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../main.dart';

class PageOne extends StatefulWidget {
  final double currentPage;
  PageOne(this.currentPage);
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.network('https://tensorfit.com/video/demo.mp4')
          ..initialize().then((_) {
            _controller.play();
            _controller.setLooping(true);
            _controller.setVolume(0.5);
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
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
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
                      padding: EdgeInsets.only(
                          bottom: 10,
                          left: widthBg * 0.1,
                          right: widthBg * 0.1),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white)),
                        padding:
                            EdgeInsets.symmetric(vertical: widthBg * 0.045),
                        onPressed: () {
                          Navigator.push<_PlayerVideoAndPopPage>(
                            context,
                            MaterialPageRoute<_PlayerVideoAndPopPage>(
                              builder: (BuildContext context) =>
                                  _PlayerVideoAndPopPage(),
                            ),
                          );
                        },
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 20,
                              ),
                            ),
                            Text('See it in action',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.deepPurple)),
                      padding: EdgeInsets.symmetric(
                          vertical: widthBg * 0.05,
                          horizontal: heightBg * 0.15),
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
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: DotsIndicator(
                        dotsCount: 6,
                        decorator: DotsDecorator(activeColor: Colors.white),
                        position: widget.currentPage,
                      ),
                    ),
                    RaisedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/create_account');
                        },
                        color: Colors.transparent,
                        elevation: 0,
                        child: Text('Returning user? Log in',
                            style: TextStyle(color: Colors.white))),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class _PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage> {
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.network('https://tensorfit.com/video/demo.mp4');
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}
