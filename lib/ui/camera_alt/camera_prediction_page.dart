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
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraPredictionPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Level level;
  const CameraPredictionPage(this.cameras, this.level);

  _CameraPredictionPageState createState() => new _CameraPredictionPageState();
}

class _CameraPredictionPageState extends State<CameraPredictionPage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int _counter = 3;
  int _counterExercise;
  Timer _timer;
  Timer _exerciseTimer;
  Level level;
  int curentExercusesNo = 0;
  var namesExercise;

  _startTimerCountdown() {
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

  _startTimerExercises(exerciseInfo) {
    if (exerciseInfo.duration != null && exerciseInfo.duration != 0) {
      _counterExercise = exerciseInfo.duration;
    } else {
      if (exerciseInfo.numberOfReps != null && exerciseInfo.numberOfReps != 0) {
        _counterExercise = exerciseInfo.numberOfReps * 5;
      } else {
        _counterExercise = 12;
      }
    }
    _exerciseTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counterExercise > 0) {
          _counterExercise--;
        } else {
          _stopTimerExercise();
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

  void _stopTimerExercise() {
    if (_exerciseTimer != null) {
      _exerciseTimer.cancel();
      _exerciseTimer = null;
    }
  }

  void _stopTimerCountdown() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      _counterExercise = 3;
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
        _startTimerCountdown();
      }
    } else {
      _stopTimerCountdown();
    }
  }

  ExerciseInfo _currentExercises(List<ExerciseInfo> exercises) {
    ExerciseInfo exerciseInfo;
    for (int i = 0; i < exercises.length; i++) {
      if (exercises[i].duration != null &&
          exercises[i].duration != 0 &&
          i > curentExercusesNo) {
        exerciseInfo = exercises[i];
        curentExercusesNo = i;
        break;
      }
    }
    return exerciseInfo;
  }

  Widget _exerciseTimerStartup(
      BuildContext context, List<ExerciseInfo> exercises) {
    ExerciseInfo exerciseInfo;
    if (_exerciseTimer == null && _counter == 0) {
      exerciseInfo = _currentExercises(exercises);
      if (exerciseInfo != null) {
        namesExercise = exerciseInfo.exercise.name;
        _startTimerExercises(exerciseInfo);
      } else {
        Navigator.pop(context);
      }
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 420.0),
        child: (_counter > 0)
            ? Text(
                "",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              )
            : Text(
                "$_counterExercise sec",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                ),
              ),
      ),
    );
  }

  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return BlocProvider(
        create: (context) => LevelBloc(widget.level)..add(Load()),
        child: BlocBuilder<LevelBloc, LevelState>(builder: (context, state) {
          if (state is LevelLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is LevelLoaded) {
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
                                fontSize: 40,
                              ))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: (_counterExercise != null)
                          ? Text('$namesExercise',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 30))
                          : Text("")),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _exerciseTimerStartup(context, state.exercises),
                    ],
                  ),
                ],
              ),
            );
          }
          return null;
        }));
  }
}
