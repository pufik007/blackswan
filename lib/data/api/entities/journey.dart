class Journey {
  final int id;
  final int currentLevelID;
  final String difficulty;
  final String state;

  Journey({this.id, this.currentLevelID, this.difficulty, this.state});

  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      id: json['id'],
      currentLevelID: json['current_level_id'],
      difficulty: json['difficulty'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'current_level_id': this.currentLevelID,
        'difficulty': this.difficulty,
        'state': this.state,
      };
}
