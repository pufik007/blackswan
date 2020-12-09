class ExerciseDetection {
  final int id;
  final int thresholdDistance;
  final int thresholdCount;
  final String exerciseKey;
  final List<String> pattern;

  ExerciseDetection({
    this.id,
    this.thresholdDistance,
    this.thresholdCount,
    this.exerciseKey,
    this.pattern,
  });

  static fromJsonObject(List<dynamic> jsonObject) {
    List<ExerciseDetection> res;

    if (jsonObject == null) {
      return res;
    }
    res = [];
    return res;
  }

  factory ExerciseDetection.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return ExerciseDetection(
      id: json['id'],
      thresholdDistance: json['thresholdDistance'],
      thresholdCount: json['thresholdCount'],
      exerciseKey: json['exerciseKey'],
      pattern: json['pattern'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'thresholdDistance': this.thresholdDistance,
        'thresholdCount': this.thresholdCount,
        'exerciseKey': this.exerciseKey,
        'pattern': this.pattern,
      };
}

class Exercise {
  final int id;
  final String name;
  final String description;
  final List<ExerciseTrait> traits;

  Exercise({this.id, this.name, this.description, this.traits});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      traits: ExerciseTrait.fromJsonArray(json['exercise_traits']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'description': this.description,
        'exercise_traits': this.traits,
      };
}

class ExerciseTrait {
  final int id;
  final String name;

  ExerciseTrait({this.id, this.name});

  static fromJsonArray(List<dynamic> jsonArray) {
    List<ExerciseTrait> res;

    if (jsonArray == null) {
      return res;
    }

    res = [];
    for (var json in jsonArray) {
      res.add(ExerciseTrait.fromJson(json));
    }

    return res;
  }

  factory ExerciseTrait.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return ExerciseTrait(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
      };
}
