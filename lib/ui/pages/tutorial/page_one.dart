import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';
import 'video_page.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



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

            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
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
                      padding:
                          EdgeInsets.only(bottom: 15.0, right: 30, left: 30),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.white)),
                        padding: EdgeInsets.only(
                            bottom: 21, top: 21),
                        onPressed: () {
                          Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) =>
                              VideoPage()
                            ),
                          );
                        },
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 2.0),
                              child: Icon(
                                Icons.play_circle_outline,
                                size: 20,
                              ),
                            ),
                            Text('See it in action',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.deepPurple)),
                      padding: EdgeInsets.only(
                          bottom: 21, top: 21, right: 122, left: 122),
                      onPressed: () {
                        BlocProvider.of<LoginNavigatorBloc>(context)
                          .add(NavigateToCreateAccount());
                      },
                      color: Colors.deepPurple,
                      child: Text('Get started',
                          style:
                              TextStyle(fontSize: 17, color: Colors.white)),
                    ),
                    SizedBox(height: 10,),
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
                          BlocProvider.of<LoginNavigatorBloc>(context)
                            .add(NavigateToCreateAccount());
                       },
                        color: Colors.transparent,
                        elevation: 0,
                        child: Text('Returning user? Log in',
                            style: TextStyle(color: Colors.white))
                      ),
                      SizedBox(height: 32,),
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
