import 'package:tensorfit/vptree/space_point.dart';
import 'package:test/test.dart';
import '../../../lib/ui/camera_alt/exercises_counter.dart';
import '../../../lib/ui/camera_alt/bbox.dart';
import '../../../lib/ui/camera_alt/vp_tree_manager.dart';
import '../../../lib/ui/camera_alt/pose_space_point.dart';
import '../../../lib/vptree/space_point.dart';
import '../../../lib/vptree/vptree_factory.dart';
import '../../../lib/vptree/vptree.dart';

void main() {
  test('Exercises counter should be incremented', () {
    List<List<double>> pose = [
      [0.48171628, 0.21103942],
      [0.53320309, 0.28876346],
      [0.44125796, 0.2916088],
      [0.55812778, 0.41638895],
      [0.41844541, 0.41206645],
      [0.5105514, 0.44128013],
      [0.44240713, 0.43728491],
      [0.52221238, 0.51763942],
      [0.45909978, 0.52392779],
      [0.55264277, 0.66091287],
      [0.42189935, 0.6672397],
      [0.5499118, 0.85397048],
      [0.42549771, 0.86753154]
    ];

    List<double> confidence = [
      0.9806515,
      0.97254556,
      0.9624879,
      0.9721693,
      0.9917129,
      0.8090379,
      0.68297017,
      0.74535465,
      0.5589173,
      0.89043903,
      0.700753,
      0.96876717,
      0.97490084
    ];

    var bbox = Bbox();

    var poseSpacePointA1 = PoseSpacePoint(pose, confidence, bbox);
    var vpTreeA = new VpTreeFactory().build([poseSpacePointA1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var poseSpacePointB1 = PoseSpacePoint(pose, confidence, bbox);
    var vpTreeB = new VpTreeFactory().build([poseSpacePointB1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreesPool = Map<String, Vptree>();
    vpTreesPool['A'] = vpTreeA;
    vpTreesPool['B'] = vpTreeB;

    var vpTreeManager = VpTreeManager();
    vpTreeManager.put("squats", vpTreesPool);
    var counter = ExercisesCounter(vpTreeManager);

    var repsCount = counter.repsCounter(pose, confidence, bbox);

    expect(repsCount, 1);
  });

  test('Exercise - squat frame 11', () {
    var bbox = Bbox();

    List<List<double>> poseFrame11 = [
      [0.48276987, 0.24532699],
      [0.5352102, 0.32444803],
      [0.44239267, 0.32374039],
      [0.55411193, 0.44745994],
      [0.41963252, 0.43874262],
      [0.49881477, 0.44442502],
      [0.44282175, 0.45218044],
      [0.52317954, 0.54018361],
      [0.46018923, 0.54197462],
      [0.55806249, 0.66565311],
      [0.41409427, 0.66829994],
      [0.55565482, 0.85563934],
      [0.42921004, 0.86415349]
    ];

    List<double> confidenceFrame11 = [
      0.98272693,
      0.97846264,
      0.96479964,
      0.97540236,
      0.9905088,
      0.88773525,
      0.69341093,
      0.86136097,
      0.6436863,
      0.79637814,
      0.8750835,
      0.96384424,
      0.9729593
    ];

    // Bbox bboxFrame11 = {
    //   double minX = 0.4140942689298404,
    //   double maxX = 0.5580624861345514,
    //   double minY = 0.24532699099220184,
    //   double maxY = 0.8641534921542162,
    //   double B = 0.0841,
    //   double A = 0.094
    // };

    var poseSpacePointA1 = PoseSpacePoint(poseFrame11, confidenceFrame11, bbox);
    var vpTreeA = new VpTreeFactory().build([poseSpacePointA1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var poseSpacePointB1 = PoseSpacePoint(poseFrame11, confidenceFrame11, bbox);
    var vpTreeB = new VpTreeFactory().build([poseSpacePointB1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreesPool = Map<String, Vptree>();
    vpTreesPool['A'] = vpTreeA;
    vpTreesPool['B'] = vpTreeB;

    var vpTreeManager = VpTreeManager();
    vpTreeManager.put("squats", vpTreesPool);
    var counter = ExercisesCounter(vpTreeManager);

    var repsCount = counter.repsCounter(poseFrame11, confidenceFrame11, bbox);

    expect(repsCount, 1);
  });
  test('Exercise - squat frame 95', () {
    var bbox = Bbox();

    List<List<double>> poseFrame95 = [
      [0.47735545, 0.21991342],
      [0.52761644, 0.31026536],
      [0.43768633, 0.31792152],
      [0.55471297, 0.43027506],
      [0.41224952, 0.43512231],
      [0.52090816, 0.46789839],
      [0.44167347, 0.4701146],
      [0.51709686, 0.52946899],
      [0.46025279, 0.54084057],
      [0.55378473, 0.66371344],
      [0.41461209, 0.67479406],
      [0.5535021, 0.84852688],
      [0.4268739, 0.85906824],
    ];

    List<double> confidenceFrame95 = [
      0.6837828,
      0.63495636,
      0.7928042,
      0.8886586,
      0.93190944,
      0.8780221,
      0.863783,
      0.7241218,
      0.47972775,
      0.94972324,
      0.8833721,
      0.9683579,
      0.9658314
    ];

    // Bbox bboxFrame95 = {
    // double minX = 0.41224952244922364,
    // double maxX = 0.5547129704306427,
    // double minY = 0.21991342419249593,
    // double maxY = 0.8590682357117567
    // double B = 0.0869,
    // double A = 0.0897
    // };

    var poseSpacePointA1 = PoseSpacePoint(poseFrame95, confidenceFrame95, bbox);
    var vpTreeA = new VpTreeFactory().build([poseSpacePointA1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var poseSpacePointB1 = PoseSpacePoint(poseFrame95, confidenceFrame95, bbox);
    var vpTreeB = new VpTreeFactory().build([poseSpacePointB1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreesPool = Map<String, Vptree>();
    vpTreesPool['A'] = vpTreeA;
    vpTreesPool['B'] = vpTreeB;

    var vpTreeManager = VpTreeManager();
    vpTreeManager.put("squats", vpTreesPool);
    var counter = ExercisesCounter(vpTreeManager);

    var repsCount = counter.repsCounter(poseFrame95, confidenceFrame95, bbox);

    expect(repsCount, 1);
  });
  test('Exercise - squat frame 170', () {
    var bbox = Bbox();

    List<List<double>> poseFrame170 = [
      [0.48525681, 0.13891301],
      [0.52982562, 0.23649789],
      [0.43624363, 0.23896294],
      [0.55283312, 0.36892618],
      [0.42335854, 0.36783373],
      [0.56006985, 0.47347818],
      [0.41302758, 0.48996974],
      [0.51401244, 0.48563478],
      [0.45960464, 0.48840258],
      [0.53232628, 0.68167508],
      [0.44392274, 0.67766123],
      [0.549463, 0.85301501],
      [0.43044082, 0.85274817],
    ];

    List<double> confidenceFrame170 = [
      0.9664129,
      0.93960476,
      0.96746767,
      0.9877177,
      0.99110067,
      0.9760705,
      0.9868574,
      0.51643217,
      0.75014174,
      0.9251652,
      0.773596,
      0.9649241,
      0.9789567
    ];

    // Bbox bboxFrame170 = {
    //   double minX = 0.41302757569239157,
    //   double maxX = 0.56006985084616,
    //   double minY = 0.1389130114641969,
    //   double maxY = 0.8530150114176054,
    //   double B =  0.1043,
    //   double A = 0.013
    // };

    var poseSpacePointA1 =
        PoseSpacePoint(poseFrame170, confidenceFrame170, bbox);
    var vpTreeA = new VpTreeFactory().build([poseSpacePointA1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var poseSpacePointB1 =
        PoseSpacePoint(poseFrame170, confidenceFrame170, bbox);
    var vpTreeB = new VpTreeFactory().build([poseSpacePointB1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreesPool = Map<String, Vptree>();
    vpTreesPool['A'] = vpTreeA;
    vpTreesPool['B'] = vpTreeB;

    var vpTreeManager = VpTreeManager();
    vpTreeManager.put("squats", vpTreesPool);
    var counter = ExercisesCounter(vpTreeManager);

    var repsCount = counter.repsCounter(poseFrame170, confidenceFrame170, bbox);

    expect(repsCount, 1);
  });
  test('Exercise - squat frame 229', () {
    var bbox = Bbox();

    List<List<double>> poseFrame229 = [
      [0.4849827, 0.13518944],
      [0.52957043, 0.23551272],
      [0.43629903, 0.23665156],
      [0.55365921, 0.3598517],
      [0.4201546, 0.36141527],
      [0.54876766, 0.46957914],
      [0.41618875, 0.48614789],
      [0.51251985, 0.47839735],
      [0.45824913, 0.48087216],
      [0.53100327, 0.67697645],
      [0.44258073, 0.67570547],
      [0.54759087, 0.85232958],
      [0.43067834, 0.84970056],
    ];

    List<double> confidenceFrame229 = [
      0.9698789,
      0.94509053,
      0.95846957,
      0.97898877,
      0.99183404,
      0.98612595,
      0.9932872,
      0.59979063,
      0.6619183,
      0.87146986,
      0.6894817,
      0.96648484,
      0.9803678
    ];

    // Bbox bboxFrame229 = {
    //   double minX = 0.4161887450086017,
    //   double maxX = 0.553659208829746,
    //   double minY = 0.1351894437733983,
    //   double maxY = 0.8523295817498892,
    //   double B =  0.1153,
    //   double A = 0.0186
    // };

    var poseSpacePointA1 =
        PoseSpacePoint(poseFrame229, confidenceFrame229, bbox);
    var vpTreeA = new VpTreeFactory().build([poseSpacePointA1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var poseSpacePointB1 =
        PoseSpacePoint(poseFrame229, confidenceFrame229, bbox);
    var vpTreeB = new VpTreeFactory().build([poseSpacePointB1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreesPool = Map<String, Vptree>();
    vpTreesPool['A'] = vpTreeA;
    vpTreesPool['B'] = vpTreeB;

    var vpTreeManager = VpTreeManager();
    vpTreeManager.put("squats", vpTreesPool);
    var counter = ExercisesCounter(vpTreeManager);

    var repsCount = counter.repsCounter(poseFrame229, confidenceFrame229, bbox);

    expect(repsCount, 1);
  });

  test('Exercise - squat frame 315', () {
    var bbox = Bbox();

    List<List<double>> poseFrame315 = [
      [0.48331421, 0.13828378],
      [0.52766642, 0.23245416],
      [0.4362475, 0.24143817],
      [0.55251573, 0.36343225],
      [0.42181928, 0.36992647],
      [0.55279824, 0.46626154],
      [0.41369668, 0.49202275],
      [0.51762381, 0.48320199],
      [0.45713888, 0.48433625],
      [0.5363876, 0.67610669],
      [0.44145466, 0.67529223],
      [0.55076956, 0.85360174],
      [0.43151344, 0.85188724],
    ];

    List<double> confidenceFrame315 = [
      0.979141,
      0.9347953,
      0.97175854,
      0.98160845,
      0.99325,
      0.9770453,
      0.991416,
      0.7236175,
      0.8617343,
      0.82172453,
      0.6411452,
      0.9641464,
      0.9740045
    ];

    // Bbox bboxFrame315 = {
    //   double minX = 0.4136966750474474,
    //   double maxX = 0.5527982402144186,
    //   double minY = 0.1382837775738056,
    //   double maxY = 0.8536017378131122,
    //   double B =  0.1139,
    //   double A = 0.0155
    // };

    var poseSpacePointA1 =
        PoseSpacePoint(poseFrame315, confidenceFrame315, bbox);
    var vpTreeA = new VpTreeFactory().build([poseSpacePointA1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var poseSpacePointB1 =
        PoseSpacePoint(poseFrame315, confidenceFrame315, bbox);
    var vpTreeB = new VpTreeFactory().build([poseSpacePointB1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreesPool = Map<String, Vptree>();
    vpTreesPool['A'] = vpTreeA;
    vpTreesPool['B'] = vpTreeB;

    var vpTreeManager = VpTreeManager();
    vpTreeManager.put("squats", vpTreesPool);
    var counter = ExercisesCounter(vpTreeManager);

    var repsCount = counter.repsCounter(poseFrame315, confidenceFrame315, bbox);

    expect(repsCount, 1);
  });
}

//flutter test test\ui\camera_alt\exercises_counter_test.dart
