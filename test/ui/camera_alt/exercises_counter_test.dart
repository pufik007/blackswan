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

    Bbox bboxFrame11;
    // = {
    //   // double minX = 0.4140942689298404,
    //   // double maxX = 0.5580624861345514,
    //   // double minY = 0.24532699099220184,
    //   // double maxY = 0.8641534921542162,
    //   // double B = 0.0841,
    //   // double A = 0.094
    // };

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

    Bbox bboxFrame95;
    // = {
    //   // double minX = 0.41224952244922364,
    //   // double maxX = 0.5547129704306427,
    //   // double minY = 0.21991342419249593,
    //   // double maxY = 0.8590682357117567
    //   // double B = 0.0869,
    //   // double A = 0.0897
    // };

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

    Bbox bboxFrame170;
    // = {
    //   // double minX = 0.41302757569239157,
    //   // double maxX = 0.56006985084616,
    //   // double minY = 0.1389130114641969,
    //   // double maxY = 0.8530150114176054,
    //   // double B =  0.1043,
    //   // double A = 0.013
    // };

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

    Bbox bboxFrame229;
    // = {
    //   // double minX = 0.4161887450086017,
    //   // double maxX = 0.553659208829746,
    //   // double minY = 0.1351894437733983,
    //   // double maxY = 0.8523295817498892,
    //   // double B =  0.1153,
    //   // double A = 0.0186
    // };

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

    Bbox bboxFrame315;
    // = {
    //   // double minX = 0.4136966750474474,
    //   // double maxX = 0.5527982402144186,
    //   // double minY = 0.1382837775738056,
    //   // double maxY = 0.8536017378131122,
    //   // double B =  0.1139,
    //   // double A = 0.0155
    // };

    List<List<double>> poseFrame60 = [
      [0.48637921, 0.14018523],
      [0.52929849, 0.23740194],
      [0.43736516, 0.23923799],
      [0.55530326, 0.36467979],
      [0.4212977, 0.36569696],
      [0.55557462, 0.47298467],
      [0.41445126, 0.48134233],
      [0.51971995, 0.4868716],
      [0.45904935, 0.48604426],
      [0.53289179, 0.67773646],
      [0.44609149, 0.67674144],
      [0.54962628, 0.85452139],
      [0.43296544, 0.84936727],
    ];

    List<double> confidenceFrame60 = [
      0.9742645,
      0.94014895,
      0.96332496,
      0.9872289,
      0.9910147,
      0.9807511,
      0.99348044,
      0.7137668,
      0.8746903,
      0.90523875,
      0.77232265,
      0.95559514,
      0.9730654
    ];

    Bbox bboxFrame60;
    // = {
    //   // double minX = 0.4144512572298687,
    //   // double maxX = 0.5555746228955267,
    //   // double minY = 0.14018522751939136,
    //   // double maxY = 0.8545213891231742,
    //   // double B =  0.1178,
    //   // double A = 0.0098
    // };

    List<List<double>> poseFrame141 = [
      [0.48085226, 0.4130615],
      [0.52890367, 0.4878177],
      [0.44845411, 0.4935379],
      [0.55543354, 0.61195257],
      [0.43249505, 0.61774057],
      [0.51246979, 0.55741946],
      [0.4555626, 0.56799551],
      [0.51849075, 0.68678309],
      [0.45746271, 0.68152645],
      [0.57420652, 0.69250102],
      [0.40242521, 0.69245907],
      [0.55015096, 0.8697413],
      [0.43158339, 0.87152759],
    ];

    List<double> confidenceFrame141 = [
      0.98357224,
      0.97605664,
      0.9436015,
      0.6688868,
      0.90635777,
      0.51771814,
      0.93548435,
      0.83295417,
      0.70753646,
      0.980126,
      0.9922057,
      0.63896567,
      0.97232246
    ];

    Bbox bboxFrame141;
    // = {
    //   // double minX = 0.4024252097433439,
    //   // double maxX = 0.574206522832526,
    //   // double minY = 0.41306150432492617,
    //   // double maxY = 0.8715275873760708,
    //   // double B =  0.0272,
    //   // double A = 0.1539
    // };

    List<List<double>> poseFrame203 = [
      [0.48470211, 0.40275327],
      [0.52880732, 0.47167929],
      [0.44969307, 0.47893598],
      [0.54505174, 0.57472245],
      [0.43282475, 0.60519288],
      [0.51953653, 0.53945151],
      [0.45264362, 0.5454135],
      [0.52284617, 0.67646407],
      [0.46128611, 0.67097897],
      [0.57510465, 0.69411679],
      [0.40543611, 0.69772613],
      [0.55015992, 0.8700967],
      [0.43282841, 0.86725163],
    ];

    List<double> confidenceFrame203 = [
      0.96905243,
      0.96731496,
      0.913831,
      0.58959377,
      0.74599516,
      0.50397813,
      0.90607196,
      0.8543019,
      0.47949952,
      0.9924979,
      0.99600476,
      0.96930283,
      0.9694973
    ];

    Bbox bboxFrame203;
    // = {
    //   // double minX = 0.40543611493584136,
    //   // double maxX = 0.5751046536881932,
    //   // double minY = 0.4027532690415697,
    //   // double maxY = 0.8700966988744343,
    //   // double B =  0.0349,
    //   // double 0.1443
    // };

    List<List<double>> poseFrame275 = [
      [0.48584993, 0.41407883],
      [0.53044263, 0.48736024],
      [0.45057217, 0.49450045],
      [0.55976816, 0.59039822],
      [0.42436055, 0.57834284],
      [0.50252032, 0.52179769],
      [0.46064625, 0.52771818],
      [0.51711879, 0.68930564],
      [0.457467, 0.66391571],
      [0.57835189, 0.69745629],
      [0.40699007, 0.69742578],
      [0.5494047, 0.86434395],
      [0.42865584, 0.85921114],
    ];

    List<double> confidenceFrame275 = [
      0.9431748,
      0.9553233,
      0.94283825,
      0.7937627,
      0.89439243,
      0.40633988,
      0.52315766,
      0.41432583,
      0.7794298,
      0.9733345,
      0.99401635,
      0.6120122,
      0.93863595
    ];

    Bbox bboxFrame275;
    // = {
    //   // double minX = 0.4069900666981919,
    //   // double maxX = 0.5783518859804982,
    //   // double minY = 0.4140788272002101,
    //   // double maxY = 0.8643439496348373,
    //   // double B =  0.0331,
    //   // double A = 0.1353
    // };

    List<List<double>> poseFrame345 = [
      [0.47990693, 0.29491205],
      [0.52772649, 0.38901567],
      [0.44364507, 0.40340022],
      [0.54591862, 0.48587502],
      [0.42527147, 0.50195173],
      [0.52395735, 0.47475867],
      [0.44503347, 0.48056429],
      [0.51905429, 0.58690336],
      [0.45554231, 0.5946994],
      [0.5673097, 0.68424965],
      [0.40869111, 0.6842224],
      [0.55106815, 0.8623355],
      [0.42767288, 0.86281865],
    ];

    List<double> confidenceFrame345 = [
      0.6284384,
      0.7448628,
      0.9017513,
      0.76720333,
      0.83734244,
      0.49253622,
      0.744395,
      0.8391936,
      0.85334694,
      0.9803343,
      0.98405254,
      0.8958212,
      0.9712334
    ];

    Bbox bboxFrame345;
    // = {
    //   // double minX = 0.40869110773808437,
    //   // double maxX = 0.5673097045042728,
    //   // double minY = 0.2949120450118515,
    //   // double maxY = 0.8628186546302868,
    //   // double B =  0.0454,
    //   // double A = 0.1079
    // };

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

    var vpTreeManager = VpTreeManager();
    var thresholdDistance = 0.1;
    var thresholdCount = 5;
    String exerciseKey = "E1";
    List<String> pattern = ["A", "B", "A"];

    vpTreeManager.put(exerciseKey, vpTreesPool);
    var counter = ExercisesCounter(vpTreeManager, 
                   exerciseKey,  
                   thresholdDistance, 
                   thresholdCount,
                   pattern);

    counter.repsCounter(poseFrame11, confidenceFrame11, bboxFrame11);
    counter.repsCounter(poseFrame60, confidenceFrame60, bboxFrame60);
    var repsCount =
        counter.repsCounter(poseFrame11, confidenceFrame11, bboxFrame11);

    expect(repsCount, 1);
  });
}

//flutter test test\ui\camera_alt\exercises_counter_test.dart
