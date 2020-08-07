class Level {
  final int id;
  final int number;
  final int diamondsReward;
  final String motivationText;
  final int exerciseVariantsCount;
  final int totalDuration;

  Level(
      {this.id,
      this.number,
      this.diamondsReward,
      this.motivationText,
      this.exerciseVariantsCount,
      this.totalDuration});

  static fromJsonArray(List<dynamic> jsonArray) {
    var res = List<Level>();

    for (var json in jsonArray) {
      res.add(Level.fromJson(json));
    }

    return res;
  }

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      number: json['number'],
      diamondsReward: json['diamonds_reward'],
      motivationText: json['motivation_text'],
      exerciseVariantsCount: json['exercise_variants_count'],
      totalDuration: json['total_duration'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'number': this.number,
        'diamonds_reward': this.diamondsReward,
        'motivation_text': this.motivationText,
        'exercise_variants_count': this.exerciseVariantsCount,
        'total_duration': this.totalDuration,
      };
}
