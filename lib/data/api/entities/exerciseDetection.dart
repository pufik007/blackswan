class ExerciseDetection {
  final int id;
  final int exerciseId;
  final String exerciseKey;
  final String pattern;
  final Object patternFrames;
  final int thresholdCount;
  final int thresholdDistance;
 
  ExerciseDetection({
    this.id,
    this.exerciseId,
    this.exerciseKey,
    this.pattern,
    this.patternFrames,
    this.thresholdCount,
    this.thresholdDistance,
  });

  static fromJsonObject(List<dynamic> jsonObject) {
    List<ExerciseDetection> res;

    if (jsonObject == null) {
      return res;
    }
    
    res = [];
    for (var json in jsonObject) {
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
      thresholdDistance: json['thresholdDistance'],
      thresholdCount: json['thresholdCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'exercise_id': this.exerciseId,
        'exercise_key': this.exerciseKey,
        'pattern': this.pattern,
        'pattern_frames': this.patternFrames,
        'thresholdDistance': this.thresholdDistance,
        'thresholdCount': this.thresholdCount,
      };
}
