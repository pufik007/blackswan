import 'dart:collection';
import 'package:tensorfit/ui/camera_alt/pose_match.dart';
import 'vp_tree_manager.dart';
import 'bbox.dart';

class ExercisesCounter {
  VpTreeManager vpTreeManager;
  double thresholdDistance;
  LinkedHashMap<String, int> counter;

  init(config, exercise) {
    //   var config;
    //   var debug = config['debug'];
    //   var pattern = config['exercises'][exercise]['pattern'];
    //   var threshold_distance =
    //       config['exercises'][exercise]['threshold_distance'];
    //   var threshold_count = config['exercises'][exercise]['threshold_count'];
    //   var vp_tree = BuildVpTree(); // (config, exercise) вызов класса
    //   List counter;
    //   vp_tree.restore(); // вызов метода из класса BuildVpTree
  }

  findMostSimilarMatch(
      List<dynamic> pose, List<dynamic> confidence, Bbox bbox) {
    var nearestImage = vpTreeManager.getNearest(pose, confidence, bbox);
    //   return {'category': nearestImage[0], 'score': nearestImage[1][0]};

    return PoseMatch();
  }

  incrementPoseCounter(PoseMatch) {
    if (PoseMatch.score < thresholdDistance) {
    } else {}

    //   if (match['score'] < threshold_distance) {
    //     if (conter.length == 0) {
    //       counter.add([match['categort'], 1]);
    //     } else if (counter[-1][0] == match['category']) {
    //       counter[-1][1] += 1;
    //     } else {
    //       counter.add([match['category'], 1]);
    //     }
    //   } else {
    //     if (counter.length == 0) {
    //       counter.add(['unknown', 1]);
    //     }
    //     if (counter[-1][0] == 'unknown') {
    //       counter[-1][1] += 1;
    //     } else {
    //       counter.add(['unknown', 1]);
    //     }
    //   }
  }

  countTotalReps(pose, counter, patern) {
    //   var currentPatternIndex = 0;
    //   var countSquat = 0;

    //   for (var i = 0; i < counter; i++) {
    //     if (counter[i] >= threshold_count) {
    //       if (pose == patern[currentPatternIndex]) {
    //         //pass - что равноценну оператору заглушке, не понял в чём смысл.
    //       } else if (currentPatternIndex + 1 < pattern.length &&
    //           pose == pattern[currentPatternIndex + 1]) {
    //         currentPatternIndex += 1;
    //       } else {
    //         currentPatternIndex = 0;
    //       }
    //       if (currentPatternIndex == pattern.length - 1) {
    //         countSquat += 1;
    //         currentPatternIndex = 0;
    //       }
    //     }
    //     return countSquat;
    //   }
  }

  repsCounter(List<dynamic> pose, List<dynamic> confidence, Bbox bbox) {
    var match = findMostSimilarMatch(pose, confidence, bbox);
    incrementPoseCounter(PoseMatch);
    // incrementPoseCount(match);
    // var reps = countTotalReps();
    // return reps();
    return 0;
  }
}
