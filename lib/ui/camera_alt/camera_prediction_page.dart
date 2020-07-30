import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'dart:async';
import 'camera.dart';
import 'bndbox.dart';

class CameraPredictionPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraPredictionPage(this.cameras);

  @override
  _CameraPredictionPageState createState() => new _CameraPredictionPageState();
}

class _CameraPredictionPageState extends State<CameraPredictionPage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int _counter = 10;
  Timer _timer;

  _startTimer() {
    _counter = 10;
    _timer = Timer.periodic(Duration(seconds: 10), (_timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void handleTimeout() {
    // callback function
  }

  @override
  void initState() {
    super.initState();
  }

  var res = Tflite.loadModel(
      model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");

  onSelect(model) {
    setState(() {});
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });

    // var _createPoseMap = [
    //   recognitions.keypoints.nose,
    //   recognitions.keypoints.leftEye,
    //   recognitions.keypoints.rightEye,
    //   recognitions.keypoints.leftEar,
    //   recognitions.keypoints.rightEar,
    //   recognitions.keypoints.leftShoulder,
    //   recognitions.keypoints.rightShoulder,
    //   recognitions.keypoints.leftElbow,
    //   recognitions.keypoints.rightElbow,
    //   recognitions.keypoints.leftWrist,
    //   recognitions.keypoints.rightWrist,
    //   recognitions.keypoints.leftHip,
    //   recognitions.keypoints.rightHip,
    //   recognitions.keypoints.leftKnee,
    //   recognitions.keypoints.rightKnee,
    //   recognitions.keypoints.leftAnkle,
    //   recognitions.keypoints.rightAnkle,
    // ];

    // var isHumanPoseValid = _validateRecognitions(_recognitions);

    // Map<String, bool> _createPoseMap = {
    //   'nose': false,
    //   'leftEye': false,
    //   'rightEye': false,
    //   'leftEar': false,
    //   'rightEar': false,
    //   'leftShoulder': false,
    //   'rightShoulder': false,
    //   'leftElbow': false,
    //   'rightElbow': false,
    //   'leftWrist': false,
    //   'rightWrist': false,
    //   'leftHip': false,
    //   'rightHip': false,
    //   'leftKnee': false,
    //   'rightKnee': false,
    //   'leftAnkle': false,
    //   'rightAnkle': false,
    // };

    for (var i = 0; i < recognitions["keypoints"].value.length; i++) {
      if (recognitions[i] != null) {
        _startTimer();
      }
    }
    // var list = recognitions["keypoints"].value;
    // print(list);
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Camera(
            widget.cameras,
            setRecognitions,
          ),
          BndBox(
            _recognitions == null ? [] : _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
          ),
          Center(
            child: Text(
              '$_counter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 70,
              ),
            ),
          ),
          Center(
            child: (_counter > 0)
                ? Text("")
                : Text(
                    "DONE!",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
