import './bbox.dart';
import './pose_space_point.dart';

class VpTreeManager {
  minItemInMap(Map<String, dynamic> map) {
    var minValue = double.infinity;
    var minKey = null;

    map.forEach((key, value) {
      if (value < minValue) {
        minKey = key;
        minValue = value;
      }
      return map[minKey];
    });
  }

  getNearest(List<dynamic> pose, List<dynamic> confidence, Bbox bbox) {
    var result = Map<dynamic, dynamic>();
    trees.forEach((tree) {
      result[tree.key] = tree.getNearestNeighbour(pose, confidence, bbox);
    });

    return minItemInMap(result);
  }

  distance(PoseSpacePoint a, PoseSpacePoint b) {
    List<dynamic> confidence;
    var dist;
    var pointA = (a[0] - a[0].min()) / (a[0].max() - a[0].min());
    var pointB = (b[0] - b[0].min()) / (b[0].max() - b[0].min());

    if (a[0].min([x, y]) && b[0].min([x, y]) == a[1][0] && b[1][0]) {
      return confidence = a[0] + b[0];
    }
    dist.sum((pointA + pointB * a[1][0] + b[1][0]) / confidence);

    return dist;
  }
}
