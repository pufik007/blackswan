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
import 'vp_tree_manager.dart';
import 'exercises_counter.dart';
import 'pose_space_point.dart';
import 'bbox.dart';
import 'pose_joint_lib.dart';
import 'package:vptree/space_point.dart';
import 'package:vptree/vptree_factory.dart';
import 'package:vptree/vptree.dart';
import 'stop_exercise_page/stop_page_exercise.dart';
import './end_of_exercises/end_of_exercises.dart';

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
  int _currentExerciseNo = 0;
  var namesExercise;

  ExerciseInfo exerciseInfo;
  ExercisesCounter repsCounter;
  Bbox bbox;
  var repsCount;
  var vpTreeManager = VpTreeManager();
  var thresholdDistance = 0.1;
  var thresholdCount = 2;
  String exerciseKey = "E4";
  List<String> pattern = ["A", "B", "A"];
  var modKeypointsList;

  @override
  void initState() {
    super.initState();
    List<List<double>> poseFrame11 = [
      [0.50261167, 0.17781262],
      [0.54448713, 0.26657622],
      [0.45788069, 0.27027162],
      [0.56847919, 0.39479852],
      [0.44031804, 0.40230093],
      [0.57425092, 0.50705058],
      [0.4285005, 0.51567255],
      [0.53869713, 0.50363802],
      [0.47689618, 0.49986377],
      [0.56800093, 0.68692511],
      [0.43614056, 0.68440039],
      [0.60527734, 0.85456382],
      [0.39899509, 0.85112635],
    ];

    List<double> confidenceFrame11 = [
      0.9794928,
      0.93279433,
      0.9690676,
      0.9887417,
      0.99101925,
      0.98636574,
      0.99527556,
      0.8093129,
      0.7232927,
      0.8077792,
      0.7550431,
      0.95106244,
      0.9338022,
    ];

    Bbox bboxFrame11;
//     minX:0.3989950934384313,
//     maxX:0.6052773421405668,
//     minY:0.1778126212049596,
//     maxY:0.8545638183270128]
// ['A', 0.0077], ['B', 0.1793]

    List<List<double>> poseFrame95 = [
      [0.4964873, 0.17204851],
      [0.54768896, 0.26494934],
      [0.45635351, 0.26766852],
      [0.56931485, 0.381481],
      [0.43035201, 0.38978373],
      [0.5361638, 0.39625406],
      [0.47782997, 0.39382447],
      [0.52983015, 0.50200241],
      [0.4730737, 0.50516089],
      [0.56961043, 0.68118547],
      [0.43565889, 0.68461009],
      [0.60555248, 0.84865455],
      [0.40005543, 0.85382043],
    ];

    List<double> confidenceFrame95 = [
      0.96396995,
      0.96769106,
      0.9429091,
      0.9283931,
      0.988637,
      0.6228234,
      0.8547984,
      0.6723638,
      0.61448705,
      0.6613258,
      0.7037962,
      0.9622842,
      0.9512991,
    ];

    Bbox bboxFrame95;
    // [minX:0.4000554328537016,
    // maxX:0.6055524767428797,
    // minY:0.1720485052667738,
    // maxY:0.853820433541558]
    // ['A', 0.0195], ['B', 0.172]

    List<List<double>> poseFrame170 = [
      [0.49973265, 0.17578925],
      [0.55306784, 0.26392547],
      [0.46170777, 0.26561216],
      [0.56908341, 0.38572303],
      [0.43468116, 0.3929124],
      [0.51786145, 0.37478739],
      [0.48319767, 0.38181636],
      [0.53843634, 0.50796183],
      [0.4759969, 0.50745132],
      [0.57239981, 0.68306044],
      [0.43697407, 0.68323874],
      [0.61132269, 0.85178075],
      [0.39962607, 0.8518785],
    ];

    List<double> confidenceFrame170 = [
      0.9703858,
      0.96968687,
      0.92934656,
      0.94030136,
      0.9892911,
      0.7102537,
      0.7143925,
      0.7173548,
      0.5988513,
      0.8077702,
      0.7142669,
      0.9554735,
      0.9452649,
    ];

    Bbox bboxFrame170;
    // [minX:0.3996260737958407,
    // maxX:0.6113226922105481,
    // minY:0.17578924867110862,
    // maxY:0.8518784997919023]
    // ['A', 0.0302], ['B', 0.1769]

    List<List<double>> poseFrame229 = [
      [0.50157966, 0.17380018],
      [0.54952548, 0.26748718],
      [0.4545831, 0.26584801],
      [0.56982619, 0.38371105],
      [0.43116335, 0.39162474],
      [0.53701233, 0.38428373],
      [0.48179234, 0.37995642],
      [0.53172139, 0.50865432],
      [0.46931003, 0.50602661],
      [0.568609, 0.68141053],
      [0.42934638, 0.68147804],
      [0.60167736, 0.84821702],
      [0.39230949, 0.85302015],
    ];

    List<double> confidenceFrame229 = [
      0.9561242,
      0.97876245,
      0.8972909,
      0.933436,
      0.9928097,
      0.87236273,
      0.9269656,
      0.746617,
      0.6382679,
      0.61791223,
      0.6398385,
      0.9588333,
      0.93941593
    ];

    Bbox bboxFrame229;
    // [minX:0.39230949057563025,
    // maxX:0.6016773634200072,
    // minY:0.17380017570924347,
    // maxY:0.8530201459161983]
    // ['A', 0.0179], ['B', 0.1592]

    List<List<double>> poseFrame315 = [
      [0.50742113, 0.17842311],
      [0.55253089, 0.26954066],
      [0.45953779, 0.27313234],
      [0.5704226, 0.38279332],
      [0.43492867, 0.39469667],
      [0.54016575, 0.3837039],
      [0.48579191, 0.37622406],
      [0.53559701, 0.51193241],
      [0.47333498, 0.5071807],
      [0.57317696, 0.68551091],
      [0.43226303, 0.68453003],
      [0.60706152, 0.8504805],
      [0.3924684, 0.85143951],
    ];

    List<double> confidenceFrame315 = [
      0.9656776,
      0.9779288,
      0.8830657,
      0.9456873,
      0.99371964,
      0.5493049,
      0.91161704,
      0.8753548,
      0.87622714,
      0.6422084,
      0.7421854,
      0.9539162,
      0.9564876,
    ];

    Bbox bboxFrame315;
    // [minX:0.39246840157546564,
    //  maxX:0.6070615150966185,
    //  minY:0.17842311437254266,
    //  maxY:0.8514395110026189]
    // ['A', 0.0158], ['B', 0.1581]

    List<List<double>> poseFrame60 = [
      [0.56114757, 0.44732747],
      [0.61416663, 0.50598128],
      [0.54355718, 0.50769908],
      [0.63014303, 0.59083319],
      [0.50872529, 0.59957026],
      [0.57787204, 0.53580023],
      [0.53090567, 0.54332062],
      [0.61331551, 0.64590156],
      [0.55540952, 0.64410562],
      [0.63302653, 0.66362872],
      [0.47602772, 0.76035405],
      [0.61316193, 0.85730393],
      [0.4049056, 0.85266157],
    ];

    List<double> confidenceFrame60 = [
      0.94974077,
      0.75346047,
      0.37347496,
      0.75020194,
      0.78102636,
      0.63613975,
      0.55980873,
      0.571995,
      0.62715346,
      0.94538337,
      0.47356325,
      0.9118057,
      0.6142942,
    ];

    Bbox bboxFrame60;
    // [minX:0.4049055999101442,
    // maxX:0.6330265334630408,
    // minY:0.44732747020650454,
    // maxY:0.8573039300707364]
    // ['A', 0.1718], ['B', 0.0299]

    List<List<double>> poseFrame141 = [
      [0.44228855, 0.36017858],
      [0.47653816, 0.4509699],
      [0.40045223, 0.45032232],
      [0.51544016, 0.50704828],
      [0.37516332, 0.53945168],
      [0.48110888, 0.48425548],
      [0.42204883, 0.49992607],
      [0.45203222, 0.61255299],
      [0.40289518, 0.61815813],
      [0.52458546, 0.73324288],
      [0.38369591, 0.70325183],
      [0.60604034, 0.84735991],
      [0.39269409, 0.85817844],
    ];

    List<double> confidenceFrame141 = [
      0.5883138,
      0.3513109,
      0.5431219,
      0.41743213,
      0.9590537,
      0.7916049,
      0.79902965,
      0.9568094,
      0.95051616,
      0.5290265,
      0.7040536,
      0.8309616,
      0.95780706,
    ];

    Bbox bboxFrame141;
    // [minX:0.37516332058535984,
    // maxX:0.6060403361580293,
    // minY:0.36017858472873093,
    //  maxY:0.8581784377923872]
    // ['A', 0.1671], ['B', 0.0298]

    List<List<double>> poseFrame203 = [
      [0.54671031, 0.43095664],
      [0.61259222, 0.48957557],
      [0.52335405, 0.50238812],
      [0.62505982, 0.57956264],
      [0.48800653, 0.62509497],
      [0.55411714, 0.52639719],
      [0.51170626, 0.55619042],
      [0.59992234, 0.64801869],
      [0.54742229, 0.63759166],
      [0.63097447, 0.65407935],
      [0.4772403, 0.75773358],
      [0.61647957, 0.85676771],
      [0.39845874, 0.85368477],
    ];

    List<double> confidenceFrame203 = [
      0.9734192,
      0.5636744,
      0.8474413,
      0.71000624,
      0.7231922,
      0.38192713,
      0.5702665,
      0.53189844,
      0.7094432,
      0.8438088,
      0.6719634,
      0.9120772,
      0.72400856,
    ];

    Bbox bboxFrame203;
    // bbox[minX:0.3984587365428369,
    // maxX:0.6309744651851349,
    // minY:0.4309566400991595,
    // maxY:0.8567677112195753]
    // ['A', 0.1538], ['B', 0.0233]

    List<List<double>> poseFrame275 = [
      [0.44343899, 0.43418726],
      [0.46165015, 0.50184273],
      [0.38832614, 0.49610395],
      [0.515563, 0.58143295],
      [0.37598851, 0.58183972],
      [0.48234436, 0.54378132],
      [0.42147498, 0.54451202],
      [0.44578555, 0.64727573],
      [0.38469154, 0.65003314],
      [0.49860515, 0.71558219],
      [0.38292413, 0.66992068],
      [0.59779506, 0.85223706],
      [0.38965672, 0.86273743],
    ];

    List<double> confidenceFrame275 = [
      0.73836154,
      0.43087938,
      0.55755246,
      0.6539854,
      0.7807947,
      0.50911707,
      0.43380436,
      0.7798876,
      0.73638797,
      0.4759943,
      0.60495764,
      0.7376329,
      0.98466694,
    ];

    Bbox bboxFrame275;
    // [minX:0.3759885058882835,
    //  maxX:0.5977950618601192,
    //  minY:0.4341872594625381,
    //  maxY:0.8627374302545566]
    // ['A', 0.1867], ['B', 0.0539]

    List<List<double>> poseFrame345 = [
      [0.53717572, 0.44820903],
      [0.60410637, 0.50552497],
      [0.51655945, 0.50914497],
      [0.61300785, 0.58865631],
      [0.47879673, 0.60850507],
      [0.51417884, 0.53858469],
      [0.50636689, 0.55552608],
      [0.60842254, 0.64655562],
      [0.55160083, 0.64805276],
      [0.62447278, 0.66049976],
      [0.5021236, 0.72269356],
      [0.61231923, 0.85698491],
      [0.39967665, 0.85271422],
    ];

    List<double> confidenceFrame345 = [
      0.9355149,
      0.3789106,
      0.9041057,
      0.4470042,
      0.7648787,
      0.2714279,
      0.33380657,
      0.9085083,
      0.72320324,
      0.5817187,
      0.46321744,
      0.87612385,
      0.4247673,
    ];

    Bbox bboxFrame345;
    // [minX:0.3996766531190231,
    // maxX:0.6244727772056676,
    // minY:0.44820902725013606,
    // maxY:0.8569849136024282]
    // ['A', 0.175], ['B', 0.0441]

    var poseSpacePointA1 =
        PoseSpacePoint(poseFrame11, confidenceFrame11, bboxFrame11);
    var poseSpacePointA2 =
        PoseSpacePoint(poseFrame95, confidenceFrame95, bboxFrame95);
    var poseSpacePointA3 =
        PoseSpacePoint(poseFrame170, confidenceFrame170, bboxFrame170);
    var poseSpacePointA4 =
        PoseSpacePoint(poseFrame229, confidenceFrame229, bboxFrame229);
    var poseSpacePointA5 =
        PoseSpacePoint(poseFrame315, confidenceFrame315, bboxFrame315);

    var poseSpacePointB1 =
        PoseSpacePoint(poseFrame60, confidenceFrame60, bboxFrame60);
    var poseSpacePointB2 =
        PoseSpacePoint(poseFrame141, confidenceFrame141, bboxFrame141);
    var poseSpacePointB3 =
        PoseSpacePoint(poseFrame203, confidenceFrame203, bboxFrame203);
    var poseSpacePointB4 =
        PoseSpacePoint(poseFrame275, confidenceFrame275, bboxFrame275);
    var poseSpacePointB5 =
        PoseSpacePoint(poseFrame345, confidenceFrame345, bboxFrame345);

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
    vpTreeManager.put(exerciseKey, vpTreesPool);
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
        repsCount = repsCounter.repsCounter(pose, confidence, bbox);
        print('repsCount - $repsCount');
      }
    }
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

  Widget createExerciseTimerOrEndLevel(
      BuildContext context, List<ExerciseInfo> exercises) {
    ExerciseInfo exerciseInfo;
    if (_exerciseTimer == null && _counter == 0) {
      repsCounter = ExercisesCounter(vpTreeManager, exerciseKey,
          thresholdDistance, thresholdCount, pattern);
      exerciseInfo = extractCurrentExercise(exercises);
      if (exerciseInfo != null) {
        namesExercise = exerciseInfo.exercise.name;
        _startTimerExercises(exerciseInfo);
      } else {
        Navigator.pop(context);
      }
    } else {
      if (namesExercise == 'Отжимания с колен') {
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

  endButton() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => StopPageExercise()));
      },
      elevation: 0,
      color: Colors.transparent,
      child: Icon(
        Icons.stop_circle_outlined,
        size: 50,
        color: Colors.purple,
      ),
    );
  }

  endPageExercisesButton() {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EndOfExercisesPage()));
      },
      elevation: 0,
      color: Colors.transparent,
      child: Icon(
        Icons.stop,
        size: 50,
        color: Colors.red,
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
                            Row(
                              children: [
                                Text(
                                  'This is Stop page - ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                endButton(),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'This is End of exrcises page - ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                endPageExercisesButton(),
                              ],
                            )
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
                      createExerciseTimerOrEndLevel(context, state.exercises),
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
