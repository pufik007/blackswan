import 'dart:collection';
import 'package:tensorfit/ui/camera_alt/pose_match.dart';
import 'vp_tree_manager.dart';
import 'bbox.dart';

class ExercisesCounter {
  VpTreeManager vpTreeManager;
  double thresholdDistance;
  LinkedHashMap<String, int> counter;
  int thresholdCount;
  List<String> pattern;

  init(config, exercise) {}

  findMostSimilarMatch(
      List<dynamic> pose, List<dynamic> confidence, Bbox bbox) {
    var nearestImage = vpTreeManager.getNearest(pose, confidence, bbox);

    return PoseMatch();
  }

  incrementPoseCounter(PoseMatch poseMatch) {
    if (poseMatch.score < thresholdDistance) {
      if (counter.entries != null) {
        counter[poseMatch.category] = 1;
      } else if (counter.entries.last.key == "unknown") {
        counter[counter.entries.last.key] += 1;
      } else {
        counter[poseMatch.category] = 1;
      }
    } else {
      if (counter.entries.last.key == "unknown") {
        counter["unknown"] = 1;
      } else if (counter.entries.last.key == "unknown") {
        counter[counter.entries.last.key] += 1;
      } else {
        counter["unknown"] = 1;
      }
    }
  }

  countTotalReps() {
    var currentPatternIndex = 0;
    var countReps = 0;

    counter.forEach((pose, count) {
      var shouldSkip = false;
      if (count < thresholdCount) {
        if (pose == pattern[currentPatternIndex]) {
          shouldSkip = true;
        } else if (currentPatternIndex + 1 < pattern.length &&
            pose == pattern[currentPatternIndex + 1]) {
          currentPatternIndex += 1;
        } else {
          currentPatternIndex = 0;
        }
      }
      if (!shouldSkip && currentPatternIndex == pattern.length - 1) {
        countReps += 1;
        currentPatternIndex = 0;
      }
    });
  }

  repsCounter(List<dynamic> pose, List<dynamic> confidence, Bbox bbox) {
    var match = findMostSimilarMatch(pose, confidence, bbox);
    incrementPoseCounter(match);
    return countTotalReps();
  }
}
