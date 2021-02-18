import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import './mistackes_model.dart';
import './miss_list.dart';

class CheckMyTraining extends StatefulWidget {
  @override
  _SixPageState createState() => _SixPageState();
}

class _SixPageState extends State<CheckMyTraining> {
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
  void deactivate() {
    _controller.setVolume(0.0);
    super.deactivate();
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

    final List<MistackesModel> _misArray = [
      MistackesModel(
        id: 'miss1',
        titleMis: 'Do not lower your feet to the floor.',
      ),
      MistackesModel(
        id: 'miss2',
        titleMis: 'Do no lift the body too high',
      ),
      MistackesModel(
        id: 'miss3',
        titleMis: 'miss No 3',
      ),
      MistackesModel(
        id: 'miss4',
        titleMis: 'miss No 4',
      ),
    ];

    return Scaffold(
      body: ListView(children: <Widget>[
        Container(
          color: Colors.black,
          child: Column(children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  width: 200,
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/tensor-logo.png'),
                        fit: BoxFit.contain),
                  ),
                )
              ],
            ),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: VideoPlayer(_controller),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              ClosedCaption(
                                  text: _controller.value.caption.text),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text(
                            'ABDOMINAL',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 18),
                          ),
                        ),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          padding: EdgeInsets.all(20),
                          colors: VideoProgressColors(
                              backgroundColor: Colors.black87,
                              bufferedColor: Colors.grey[700],
                              playedColor: Colors.purple),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: _ControlsOverlay(controller: _controller)),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'You have ${_misArray.length} mistakes',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Container(
                              width: widthBg, child: MissList(_misArray)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);
  final VideoPlayerController controller;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay> {
  Icon iconPP = Icon(Icons.pause_circle_outline, size: 30);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
            duration: Duration(milliseconds: 50),
            reverseDuration: Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 5),
                    Icon(Icons.skip_previous, color: Colors.white),
                    IconButton(
                      icon: iconPP,
                      color: Colors.white,
                      onPressed: () {
                        if (widget.controller.value.isPlaying) {
                          widget.controller.pause();
                          setState(() {
                            iconPP = Icon(Icons.play_circle_outline, size: 30);
                          });
                        } else {
                          widget.controller.play();
                          setState(() {
                            iconPP = Icon(Icons.pause_circle_outline, size: 30);
                          });
                        }
                      },
                    ),
                    Icon(Icons.skip_next, color: Colors.white),
                    SizedBox(width: 5),
                  ]),
            )),
      ],
    );
  }
}
