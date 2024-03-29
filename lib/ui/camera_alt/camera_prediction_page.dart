import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
// import 'dart:math' as math;
import 'dart:async';
import 'package:vptree/space_point.dart';
import 'package:vptree/vptree_factory.dart';
import 'package:vptree/vptree.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'camera.dart';
// import 'bndbox.dart';
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

    List<SpacePoint> poseSpacePointA = [];
    List<SpacePoint> poseSpacePointB = [];

    for (var i in detectionList['A'].values) {
      poseSpacePointA.add(PoseSpacePoint(
        i.pose,
        i.confidence,
        i.bbox,
      ));
    }

    for (var i in detectionList['B'].values) {
      poseSpacePointB.add(PoseSpacePoint(
        i.pose,
        i.confidence,
        i.bbox,
      ));
    }

    var vpTreeA = new VpTreeFactory().build(poseSpacePointA, 6,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreeB = new VpTreeFactory().build(poseSpacePointB, 6,
        (spacePointA, spacePointB) {
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
    exerciseDetection = exercisesDetection
        .firstWhere((element) => element.exerciseId == exerciseInfo.exercise.id,
            orElse: () {
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
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EndOfExercisesPage(widget.level)));
        });
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
                _counterExercise != null ? "$_counterExercise sec" : "",
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
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EndOfExercisesPage(widget.level)));
        });
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
    // Size screen = MediaQuery.of(context).size;
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
                  // BndBox(
                  //   _recognitions == null ? [] : _recognitions,
                  //   math.max(_imageHeight, _imageWidth),
                  //   math.min(_imageHeight, _imageWidth),
                  //   screen.height,
                  //   screen.width,
                  // ),
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
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: endPageExercisesButton(),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: (_counterExercise != null)
                          ? Text(namesExercise != null ? '$namesExercise' : '',
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      width: 150,
                      height: 100,
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4)),
                        color: Color.fromRGBO(114, 114, 114, 40),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Icon(
                              Icons.brightness_1_rounded,
                              size: 30,
                              color: _counter >= 3 ? Colors.red : Colors.green,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    repsCount != null ? '$repsCount' : '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                                  )),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(4)),
                                    color: Colors.deepPurple),
                                child: Text(
                                  'BETA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return null;
        }));
  }
}
