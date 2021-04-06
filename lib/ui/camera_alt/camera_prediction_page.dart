import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:vptree/space_point.dart';
import 'package:vptree/vptree_factory.dart';
import 'package:vptree/vptree.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'camera.dart';
import 'bndbox.dart';
import '../pages/level_bloc/level_state.dart';
import '../../data/api/entities/exercise_info.dart';
import '../../data/api/entities/level.dart';
import '../pages/level_bloc/level_bloc.dart';
import '../pages/level_bloc/level_event.dart';
import 'vp_tree_manager.dart';
import 'exercises_counter.dart';
import 'pose_space_point.dart';
import 'bbox.dart';
import 'pose_joint_lib.dart';
import './end_of_exercises/end_of_exercises.dart';
import '../../data/api/entities/exercise_detection.dart';

class CameraPredictionPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Level level;
  final List<ExerciseDetection> exerciseDetection;
  const CameraPredictionPage(this.cameras, this.level, this.exerciseDetection);

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
  int _currentExerciseNo = 0;
  var namesExercise;
  ExerciseInfo exerciseInfo;
  ExercisesCounter repsCounter;
  Bbox bbox;
  var repsCount;
  var vpTreeManager = VpTreeManager();
  var modKeypointsList;
  ExerciseDetection exerciseDetection;

  exerciseDetectionChangeTypes(exerciseDetection) {
    var detectionList = exerciseDetection.patternFrames;

    var poseSpacePointA1 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );
    var poseSpacePointA2 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );
    var poseSpacePointA3 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );
    var poseSpacePointA4 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );
    var poseSpacePointA5 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );

    var poseSpacePointB1 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );
    var poseSpacePointB2 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );
    var poseSpacePointB3 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );
    var poseSpacePointB4 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );
    var poseSpacePointB5 = PoseSpacePoint(
      detectionList['A']['11'].pose,
      detectionList['A']['11'].confidence,
      detectionList['A']['11'].bbox,
    );

    var vpTreeA = new VpTreeFactory().build([
      poseSpacePointA1 as SpacePoint,
      poseSpacePointA2 as SpacePoint,
      poseSpacePointA3 as SpacePoint,
      poseSpacePointA4 as SpacePoint,
      poseSpacePointA5 as SpacePoint
    ], 6, (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreeB = new VpTreeFactory().build([
      poseSpacePointB1 as SpacePoint,
      poseSpacePointB2 as SpacePoint,
      poseSpacePointB3 as SpacePoint,
      poseSpacePointB4 as SpacePoint,
      poseSpacePointB5 as SpacePoint
    ], 6, (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });
    var vpTreesPool = Map<String, VpTree>();
    vpTreesPool['A'] = vpTreeA;
    vpTreesPool['B'] = vpTreeB;
    vpTreeManager.put(widget.exerciseDetection[0].exerciseKey, vpTreesPool);
  }

  int poseIndex(String part) {
    var poseIndex = -1;
    switch (part) {
      case "nose":
        {
          poseIndex = 0;
        }
        break;
      case "leftShoulder":
        {
          poseIndex = 1;
        }
        break;
      case "rightShoulder":
        {
          poseIndex = 2;
        }
        break;
      case "leftElbow":
        {
          poseIndex = 3;
        }
        break;
      case "rightElbow":
        {
          poseIndex = 4;
        }
        break;
      case "leftWrist":
        {
          poseIndex = 5;
        }
        break;
      case "rightWrist":
        {
          poseIndex = 6;
        }
        break;
      case "leftHip":
        {
          poseIndex = 7;
        }
        break;
      case "rightHip":
        {
          poseIndex = 8;
        }
        break;
      case "leftKnee":
        {
          poseIndex = 9;
        }
        break;
      case "rightKnee":
        {
          poseIndex = 10;
        }
        break;
      case "leftAnkle":
        {
          poseIndex = 11;
        }
        break;
      case "rightAnkle":
        {
          poseIndex = 12;
        }
        break;
      default:
        {
          poseIndex = -1;
        }
        break;
    }
    return poseIndex;
  }

  List<PoseJointLib> extractPoseSpacePoints(List<dynamic> _recognitions) {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var poseJointLib = List<PoseJointLib>();
    List<List<double>> pose = List<List<double>>();
    List<double> confidence = List<double>();
    if (_recognitions.length > 0) {
      var keypoints = _recognitions[0]["keypoints"];
      if (keypoints != null) {
        modKeypointsList = keypoints.values
            .toList()
            .where((keypoint) =>
                keypoint["part"] != "leftEye" &&
                keypoint["part"] != "rightEye" &&
                keypoint["part"] != "leftEar" &&
                keypoint["part"] != "rightEar")
            .toList();
        modKeypointsList.sort(
            (a, b) => poseIndex(a["part"]).compareTo(poseIndex(b["part"])));

        modKeypointsList.forEach((keypoint) {
          poseJointLib.add(
              PoseJointLib(keypoint["x"], keypoint["y"], keypoint["score"]));
        });
        poseJointLib.forEach((element) {
          pose.add([element.x, element.y]);
          confidence.add(element.score);
        });
        print('pose right here - $pose');
        print(confidence);
        int startTimeReps = new DateTime.now().millisecondsSinceEpoch;
        repsCount = repsCounter.repsCounter(
          pose,
          confidence,
          bbox,
        );
        print('repsCount - $repsCount');
        int endTimeReps = new DateTime.now().millisecondsSinceEpoch;
        print("Detection took Reps ${endTimeReps - startTimeReps}");
      }
    }
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Detection took 2 ${endTime - startTime}");
    return poseJointLib;
  }

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

//   void printWrapped(String text) {
//   final pattern = RegExp('.{3,800}'); // 800 is the size of each chunk
//   pattern.allMatches(text).forEach((match) => print(match.group(0)));
// }

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
      // printWrapped("this is recognations - $_recognitions");
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

  ExerciseInfo extractCurrentExercise(List<ExerciseInfo> exercises) {
    ExerciseInfo exerciseInfo;

    for (int i = 0; i < exercises.length; i++) {
      if (exercises[i].duration != null &&
          exercises[i].duration != 0 &&
          i > _currentExerciseNo) {
        exerciseInfo = exercises[i];
        _currentExerciseNo = i;
        break;
      }
    }

    return exerciseInfo;
  }

  ExerciseDetection extractCurrentExerciseDetection(
      List<ExerciseDetection> exercisesDetection, ExerciseInfo exerciseInfo) {
    exerciseDetection = exercisesDetection.firstWhere(
        (element) => element.id == exerciseInfo.exercise.id, orElse: () {
      return null;
    });

    return exerciseDetection;
  }

  Widget createExerciseTimerOrEndLevel(
      BuildContext context,
      List<ExerciseInfo> exercises,
      List<ExerciseDetection> exercisesDetection) {
    ExerciseInfo exerciseInfo;
    if (_exerciseTimer == null && _counter == 0) {
      exerciseInfo = extractCurrentExercise(exercises);
      if (exerciseInfo != null) {
        exerciseDetection =
            extractCurrentExerciseDetection(exercisesDetection, exerciseInfo);
        repsCounter = ExercisesCounter(
            vpTreeManager,
            exerciseDetection.exerciseKey,
            exerciseDetection.thresholdDistance,
            exerciseDetection.thresholdCount,
            exerciseDetection.pattern.split(" "));
        namesExercise = exerciseInfo.exercise.name;
        _startTimerExercises(exerciseInfo);
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EndOfExercisesPage(level)));
      }
    } else {
      if (namesExercise != null) {
        exerciseDetectionChangeTypes(exerciseDetection);
        extractPoseSpacePoints(_recognitions);
      }
    }

    return Center(
      child: Container(
        padding: EdgeInsets.all(25),
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

  endPageExercisesButton() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EndOfExercisesPage(level)));
      },
      elevation: 0,
      color: Colors.transparent,
      child: Icon(
        Icons.stop_circle_outlined,
        size: 50,
        color: Colors.deepPurple,
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
                    child: Text('$repsCount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: Align(
                        alignment: Alignment.topCenter,
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
                  ),
                  Row(
                    children: [
                      Container(
                          child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            endPageExercisesButton(),
                          ],
                        ),
                      )),
                    ],
                  ),
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
                      createExerciseTimerOrEndLevel(
                          context, state.exercises, widget.exerciseDetection),
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
