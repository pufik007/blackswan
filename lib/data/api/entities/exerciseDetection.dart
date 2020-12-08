class ExerciseDetection {
  final int id;
  final String difficulty;
  final int duration;
  final Exercise exercise;
  final int levelID;
  final int numberOfReps;
  final int position;
  final int substituteID;
  final ExerciseDetection substitute;
  final List<ExerciseDetection> substitutes;

  ExerciseDetection({
    this.id,
    this.difficulty,
    this.duration,
    this.exercise,
    this.levelID,
    this.numberOfReps,
    this.position,
    this.substituteID,
    this.substitute,
    this.substitutes,
  });

  static fromJsonObject(List<dynamic> jsonObject) {
    List<ExerciseDetection> res;

    if (jsonObject == null) {
      return res;
    }

    res = [];
    for (var json in jsonObject) {
      res.sort((a, b) => a.position.compareTo(b.position));
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
      difficulty: json['difficulty'],
      duration: json['duration'],
      exercise: Exercise.fromJson(json['exercise']),
      levelID: json['level_id'],
      numberOfReps: json['number_of_reps'],
      position: json['position'],
      substituteID: json['substitute_id'],
      substitute: ExerciseDetection.fromJson(json['substitute']),
      substitutes: ExerciseDetection.fromJsonObject(json['substitutes']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'difficulty': this.difficulty,
        'duration': this.duration,
        'exercise': this.exercise,
        'level_id': this.levelID,
        'number_of_reps': this.numberOfReps,
        'position': this.position,
        'substitute_id': this.substituteID,
        'substitute': this.substitute,
        'substitutes': this.substitutes,
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
