import 'dart:math';
import 'package:ml_linalg/vector.dart';
import './pose_space_point.dart';
import '../../vptree/vptree.dart';
import '../../vptree/priority_queue_item.dart';
import 'pose_match.dart';

class VpTreeManager {
  var exerciseVpTreePoolsMap = Map<String, Map<String, VpTree>>();

  put(String exerciseKey, Map<String, VpTree> vpTreesPool) {
    exerciseVpTreePoolsMap[exerciseKey] = vpTreesPool;
  }

  PoseMatch minItemInMap(Map<String, List<PriorityQueueItem>> map) {
    double minDistance = double.maxFinite;
    String minKey = null;
    map.forEach((key, value) {
      if (value[0].priority < minDistance) {
        minKey = key;
        minDistance = value[0].priority;
      }
    });
    return minKey != null ? PoseMatch(minKey, map[minKey][0].priority) : null;
  }

  PoseMatch getNearest(String exerciseKey, PoseSpacePoint poseSpacePoint) {
    var result = Map<String, List<PriorityQueueItem>>();
    exerciseVpTreePoolsMap[exerciseKey].entries.forEach((exerciseVpTreePool) {
      print("DistancePosePool - ${exerciseVpTreePool.key}");
      result[exerciseVpTreePool.key] =
          exerciseVpTreePool.value.search(poseSpacePoint, 1, double.maxFinite);
      print("DIstancePosePool - ${exerciseVpTreePool.key}, Result - ${result[exerciseVpTreePool.key][0].priority}");
    });

    return minItemInMap(result);
  }

  static double distance(PoseSpacePoint a, PoseSpacePoint b) {
    var aMinValues = List<double>.from([double.maxFinite, double.maxFinite]);
    var aMaxValues = List<double>.from([-double.maxFinite, -double.maxFinite]);
    a.pose.forEach((joint) {
      aMinValues[0] = min(aMinValues[0], joint[0]);
      aMinValues[1] = min(aMinValues[1], joint[1]);
      aMaxValues[0] = max(aMaxValues[0], joint[0]);
      aMaxValues[1] = max(aMaxValues[1], joint[1]);
    });
    var bMinValues = List<double>.from([double.maxFinite, double.maxFinite]);
    var bMaxValues = List<double>.from([-double.maxFinite, -double.maxFinite]);
    b.pose.forEach((joint) {
      bMinValues[0] = min(bMinValues[0], joint[0]);
      bMinValues[1] = min(bMinValues[1], joint[1]);
      bMaxValues[0] = max(bMaxValues[0], joint[0]);
      bMaxValues[1] = max(bMaxValues[1], joint[1]);
    });

    
    var widthPoseA = (aMaxValues[0] - aMinValues[0]);
    var heightPoseA = (aMaxValues[1] - aMinValues[1]);
    var widthPoseB = (bMaxValues[0] - bMinValues[0]);
    var heightPoseB = (bMaxValues[1] - bMinValues[1]);

    var proportionsForWidth = widthPoseB / widthPoseA;
    var proportionsForHeight = heightPoseB / heightPoseA;

    // var shiftForWidth = b.pose[0][0] - a.pose[0][0];
    // var shiftForHeight = b.pose[0][1] - a.pose[0][1];

    // var modPoseA = a.pose.map<List<double>>((joint) {
    //   var point = List<double>.from(joint);
    //   point[0] = (point[0] + shiftForWidth) * proportionsForWidth;
    //   point[1] = (point[1] + shiftForHeight) * proportionsForHeight;
    //   return point;
    // }).toList();
 
    // var modPoseA = a.pose.map<List<double>>((joint) {
    //   var point = List<double>.from(joint);
    //   point[0] = point[0] * proportionsForWidth;
    //   point[1] = point[1] * proportionsForHeight;
    //   return point;
    // }).toList();

    var preModPoseA = a.pose.map<List<double>>((joint) {
      var point = List<double>.from(joint);
      point[0] = point[0] * proportionsForWidth;
      point[1] = point[1] * proportionsForHeight;
      return point;
    }).toList();

    var shiftForWidth = b.pose[0][0] - preModPoseA[0][0];
    var shiftForHeight = b.pose[0][1] - preModPoseA[0][1];

    var modPoseA = a.pose.map<List<double>>((joint) {
      var point = List<double>.from(joint);
      point[0] = point[0] + shiftForWidth;
      point[1] = point[1] + shiftForHeight;
      return point;
    }).toList();
   
    aMinValues[0] = double.maxFinite;
    aMinValues[1] = double.maxFinite;
    aMaxValues[0] = -double.maxFinite;
    aMaxValues[1] = -double.maxFinite;


  modPoseA.forEach((joint) { 
    aMinValues[0] = min(aMinValues[0], joint[0]);
    aMinValues[1] = min(aMinValues[1], joint[1]);
    aMaxValues[0] = max(aMaxValues[0], joint[0]);
    aMaxValues[1] = max(aMaxValues[1], joint[1]);
  });
  
  print("preModPoseA - $preModPoseA");
  print("modPoseA - $modPoseA");

  var pointA = modPoseA.map<List<double>>((joint) {
    var point = List<double>.from(joint);
    point[0] = (point[0] - aMinValues[0]) / (aMaxValues[0] - aMinValues[0]);
    point[1] = (point[1] - aMinValues[1]) / (aMaxValues[1] - aMinValues[1]);
    return point;
  }).toList();

  var pointB = b.pose.map<List<double>>((joint) {
    var point = List<double>.from(joint);
    point[0] = (point[0] - bMinValues[0]) / (bMaxValues[0] - bMinValues[0]);
    point[1] = (point[1] - bMinValues[1]) / (bMaxValues[1] - bMinValues[1]);
    return point;
  }).toList();
  
  
 
  var confidence = List<double>();
  var confidenceSum = .0;
  for (int i = 0; i < modPoseA.length; i++) {
    var minConfidence = min(a.confidence[i], b.confidence[i]);
    confidence.add(minConfidence);
    confidenceSum += minConfidence;
  }
  var dist = .0;
  for (int i = 0; i < pointA.length; i++) {
    dist += Vector.fromList(
      [pointA[i][0] - pointB[i][0], pointA[i][1] - pointB[i][1]]).norm() 
        * confidence[i] / confidenceSum;
  }
  
    print("DistancePoseA - ${modPoseA.toString()}");
    print("DistancePoseB - ${b.pose.toString()}");
    print("DistancePoseResult - ${dist.toString()}");

    return dist;
  }
}
