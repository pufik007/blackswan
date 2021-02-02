class ExerciseDetection {
  final int id;
  final int exerciseId;
  final String exerciseKey;
  final String pattern;
  final Map<String, dynamic> patternFrames;
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

    return ExerciseDetection(
      id: json['id'],
      exerciseId: json['exercise_id'],
      exerciseKey: json['exercise_key'],
      pattern: json['pattern'],
      patternFrames: json['pattern_frames'],
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
