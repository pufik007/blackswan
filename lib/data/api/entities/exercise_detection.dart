import '../../../ui/camera_alt/pose_space_point.dart';

class ExerciseDetection {
  final int id;
  final int exerciseId;
  final String exerciseKey;
  final String pattern;
  final Map<String, Map<String, PoseSpacePoint>> patternFrames;
  final int thresholdCount;
  final double thresholdDistance;

  ExerciseDetection({
    this.id,
    this.exerciseId,
    this.exerciseKey,
    this.pattern,
    this.patternFrames,
    this.thresholdCount,
    this.thresholdDistance,
  });

  static fromJsonArray(List<dynamic> jsonArray) {
    List<ExerciseDetection> res;

    if (jsonArray == null) {
      return res;
    }

    res = [];
    for (var json in jsonArray) {
      res.add(ExerciseDetection.fromJson(json));
    }

    return res;
  }

  factory ExerciseDetection.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    var patternFramesNodesMap = Map<String, Map<String, PoseSpacePoint>>();
    var patternFramesJson = json['pattern_frames'] as Map<String, dynamic>;
    patternFramesJson.keys.forEach((element) {
      var patternFramesNode = Map<String, PoseSpacePoint>();
      var patternFramesNodeJson =
          patternFramesJson[element] as Map<String, dynamic>;
      patternFramesNodeJson.keys.forEach((element) {
        patternFramesNode[element] =
            PoseSpacePoint.fromJson(patternFramesNodeJson[element]);
      });
      patternFramesNodesMap[element] = patternFramesNode;
    });

    return ExerciseDetection(
      id: json['id'],
      exerciseId: json['exercise_id'],
      exerciseKey: json['exercise_key'],
      pattern: json['pattern'],
      patternFrames: patternFramesNodesMap,
      thresholdDistance: json['threshold_distance'],
      thresholdCount: json['threshold_count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'exercise_id': this.exerciseId,
        'exercise_key': this.exerciseKey,
        'pattern': this.pattern,
        'pattern_frames': this.patternFrames,
        'threshold_distance': this.thresholdDistance,
        'threshold_count': this.thresholdCount,
      };
}
