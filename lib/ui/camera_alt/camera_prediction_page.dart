import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'dart:async';
import 'camera.dart';
import 'bndbox.dart';
import '../pages/level_bloc/level_state.dart';
import '../../data/api/entities/exercise_info.dart';
import '../../data/api/entities/level.dart';
import '../pages/level_bloc/level_bloc.dart';
import '../pages/level_bloc/level_event.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/data/data.dart';
import 'package:tensorfit/ui/widgets/map_bloc/bloc.dart' as level;
import 'package:flutter_bloc/flutter_bloc.dart';
import './exercise_widget.dart';

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
  int _counter = 3;
  int _counterExer = 10;
  Timer _timer;
  int _duration = 0;

  final _levelBlock = level.MapBloc();

  _startTimer() {
    _counter = 3;
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  _startTimerExercises() {
    _counterExer = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      setState(() {
        if (_counterExer > 0) {
          _counterExer--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  bool _validateRecognitions(List<dynamic> recognitions) {
    var isValid = false;
    var poseMap = _createPoseMap();
    if (recognitions.length > 0) {
      var keypoints = recognitions[0]["keypoints"];
      if (keypoints != null) {
        keypoints.values.toList().forEach((keypoint) {
          if ((keypoint["x"] > 0) &&
              keypoint["x"] < _imageWidth &&
              keypoint["y"] > 0 &&
              keypoint["y"] < _imageHeight) {
            poseMap[keypoint["part"]] = true;
          }
        });
        var poseMapValues = poseMap.values.toList();
        isValid = true;
        for (var i = 0; i < poseMapValues.length; i++) {
          if (!poseMapValues[i]) {
            isValid = false;
            break;
          }
        }
      }
    }
    return isValid;
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      _counter = 3;
    }
  }

  Map<String, bool> _createPoseMap() {
    return {
      'nose': false,
      'leftEye': false,
      'rightEye': false,
      'leftEar': false,
      'rightEar': false,
      'leftShoulder': false,
      'rightShoulder': false,
      'leftElbow': false,
      'rightElbow': false,
      'leftWrist': false,
      'rightWrist': false,
      'leftHip': false,
      'rightHip': false,
      'leftKnee': false,
      'rightKnee': false,
      'leftAnkle': false,
      'rightAnkle': false,
    };
  }

  dynamic _buildHeader(List<ExerciseInfo> exercises) {
    var duration = 0;
    for (final exercise in exercises) {
      if (exercise.duration != null) {
        duration += (exercise.duration / 60).floor();
      }
    }
    return _duration = duration;
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

    var isHumanPoseValid = _validateRecognitions(recognitions);
    if (isHumanPoseValid) {
      if (_timer == null) {
        _startTimer();
      }
    } else {
      _stopTimer();
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    this._levelBlock.add(level.Load());
  }

  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return BlocProvider(
        create: (context) => this._levelBlock,
        child: Scaffold(
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
                  child: (_counter > 0)
                      ? Text(
                          '$_counter',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 70,
                          ),
                        )
                      : Text("",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 70,
                          ))),
              Center(child: ExerciseLevelCameraPage())
            ],
          ),
        ));
  }

  @override
  void dispose() {
    this._levelBlock.close();
    super.dispose();
  }
}
