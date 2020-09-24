import './bbox.dart';
import './vp_tree.dart';

class VpTreeManager {
  List<VpTree> trees;

  VpTreeManager(List<VpTree> trees) {
    this.trees = trees;
  }

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
}
