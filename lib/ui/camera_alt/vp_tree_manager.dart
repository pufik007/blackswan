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
      result[exerciseVpTreePool.key] =
          exerciseVpTreePool.value.search(poseSpacePoint, 1, double.maxFinite);
    });

    return minItemInMap(result);
  }

  static double distance(PoseSpacePoint a, PoseSpacePoint b) {
    var aMinValues = List<double>.from([double.maxFinite, double.maxFinite]); // [0]:1.7976931348623157e+308 [1]:1.7976931348623157e+308
    var aMaxValues = List<double>.from([-double.maxFinite, -double.maxFinite]); // [0]:-1.7976931348623157e+308 [1]:-1.7976931348623157e+308
    a.pose.forEach((joint) {
      aMinValues[0] = min(aMinValues[0], joint[0]); // [0]:0.48276987 [1]:1.7976931348623157e+308
      aMinValues[1] = min(aMinValues[1], joint[1]); // [0]:0.48276987 [1]:0.24532699
      aMaxValues[0] = max(aMaxValues[0], joint[0]); // [0]:0.48276987 [1]:0.24532699
      aMaxValues[1] = max(aMaxValues[1], joint[1]); // [0]:0.48276987 [1]:0.24532699
    });
    var pointA = a.pose.map<List<double>>((joint) { // [0]:0.48276987 [1]:0.24532699
      var point = List<double>.from(joint); // [0]:0.48276987 [1]:0.24532699
      point[0] = (point[0] - aMinValues[0]) / (aMaxValues[0] - aMinValues[0]); // {(0.48276987 - 0.42921004) = 0.05355983 / (1.7976931348623157 - 0.42921004) = 1.36848309486} = 0.0391381013
      point[1] = (point[1] - aMinValues[1]) / (aMaxValues[1] - aMinValues[1]); // {(0.24532699 - 0.86415349) = -0.6188265 / (1.7976931348623157 - 0.86415349) = 0.93353964486} = -0.6628818641
      return point;
    }).toList();

    var bMinValues = List<double>.from([double.maxFinite, double.maxFinite]); // [0]:1.7976931348623157e+308 [1]:1.7976931348623157e+308
    var bMaxValues = List<double>.from([-double.maxFinite, -double.maxFinite]); // [0]:-1.7976931348623157e+308 [1]:-1.7976931348623157e+308
    b.pose.forEach((joint) { // [0]:0.48276987 [1]:0.24532699
      bMinValues[0] = min(bMinValues[0], joint[0]); // [0]:1.7976931348623157e+308 [0]:0.48276987
      bMinValues[1] = min(bMinValues[1], joint[1]); // [1]:1.7976931348623157e+308 [1]:0.24532699
      bMaxValues[0] = max(bMaxValues[0], joint[0]); // [0]:-1.7976931348623157e+308 [0]:0.48276987
      bMaxValues[1] = max(bMaxValues[1], joint[1]); // [1]:-1.7976931348623157e+308 [1]:0.24532699
    });
    var pointB = b.pose.map<List<double>>((joint) { // [0]:0.48276987 [1]:0.24532699
      var point = List<double>.from(joint); // [0]:0.48276987 [1]:0.24532699
      point[0] = (point[0] - bMinValues[0]) / (bMaxValues[0] - bMinValues[0]); 
             // {(0.48276987 - 0.41409427) = 0.0686756 / (0.55806249 - 0.41409427) = 0.14396822} = 0.47701916436
      point[1] = (point[1] - bMinValues[1]) / (bMaxValues[1] - bMinValues[1]); 
             // {(0.24532699 - 0.24532699) = 0 / (0.86415349 - 0.24532699) = 0.6188265} = 0
      return point; // [0]:0.4770191643683586 [1]:0.0
    }).toList();

    var confidence = List<double>();
    var confidenceSum = .0;
    for (int i = 0; i < a.pose.length; i++) {
      var minConfidence = min(a.confidence[i], b.confidence[i]);
      confidence.add(minConfidence);
      confidenceSum += minConfidence;
    }
    var dist = .0;
    for (int i = 0; i < pointA.length; i++) {
      dist += Vector.fromList(
                  [pointA[i][0] - pointB[i][0], pointA[i][1] - pointB[i][1]])
              .norm() *
          confidence[i] /
          confidenceSum;
    }

    return dist;
  }
}
