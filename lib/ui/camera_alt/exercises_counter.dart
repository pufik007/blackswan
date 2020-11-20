import 'pose_match.dart';
import 'vp_tree_manager.dart';
import 'bbox.dart';
import 'pose_space_point.dart';

class ExercisesCounter {
  VpTreeManager vpTreeManager;
  double thresholdDistance;
  List<MapEntry<String, int>> counter;
  int thresholdCount;
  List<String> pattern;
  String exerciseKey;

  ExercisesCounter(VpTreeManager vpTreeManager, 
                   String exerciseKey,  
                   double thresholdDistance, 
                   int thresholdCount,
                   List<String> pattern) {
    this.vpTreeManager = vpTreeManager;
    this.exerciseKey = exerciseKey;
    this.thresholdDistance = thresholdDistance;
    this.thresholdCount = thresholdCount;
    this.counter = List<MapEntry<String, int>>();
    this.pattern = pattern;
  }

  init(config, exercise) {}

  PoseMatch findMostSimilarMatch(String exerciseKey, 
                                 List<List<double>> pose,
                                 List<double> confidence, 
                                 Bbox bbox) {
    var poseSpacePoint = PoseSpacePoint(pose, confidence, bbox);
    return vpTreeManager.getNearest(exerciseKey, poseSpacePoint);
  }

  incrementPoseCounter(PoseMatch poseMatch) {
    if (poseMatch.score < thresholdDistance) {
      if (counter.length == 0) {
        counter.add(MapEntry<String, int>(poseMatch.category, 1));
      } else if (counter.last.key == poseMatch.category) {
        counter.last = MapEntry(poseMatch.category, counter.last.value + 1);
      } else {
        counter.add(MapEntry<String, int>(poseMatch.category, 1));
      }
    } else {
      if (counter.length == 0) {
        counter.add(MapEntry<String, int>("unknown", 1));
      } else if (counter.last.key == "unknown") {
        counter.last = MapEntry("unknown", counter.last.value + 1);
      } else {
        counter.add(MapEntry<String, int>("unknown", 1));
      }
    }
  }

  int countTotalReps() {
    var currentPatternIndex = 0;
    var countReps = 0;

    print("DistancePose threshouldCount - $thresholdCount");
    print("DistancePose pattern - $pattern");
    counter.forEach((entry) {
      var shouldSkip = false;
      if (entry.value >= thresholdCount) {
        if (entry.key == pattern[currentPatternIndex]) {
          shouldSkip = true;
        } else if (currentPatternIndex + 1 < pattern.length &&
            entry.key == pattern[currentPatternIndex + 1]) {
          currentPatternIndex += 1;
        } else {
          currentPatternIndex = 0;
        }
      }

      print("DistancePose shouldSkip - $shouldSkip");
      print("DistancePose currentPatternIndex - $currentPatternIndex");
      if (!shouldSkip && currentPatternIndex == pattern.length - 1) {
        countReps += 1;
        currentPatternIndex = 0;
      }
    });
    
    return countReps;
  }

  int repsCounter(List<List<double>> pose, List<double> confidence, Bbox bbox) {
    var match = findMostSimilarMatch(this.exerciseKey, pose, confidence, bbox);
    print("DistancePoseMatch - ${match.category} and Score - ${match.score}");
    incrementPoseCounter(match);
    return countTotalReps();
  }
}
