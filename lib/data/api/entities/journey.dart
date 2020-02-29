class Journey {
  final int id;
  final String difficulty;
  final String state;
  final String body;

  Journey({this.id, this.difficulty, this.state, this.body});

  factory Journey.fromJson(Map<String, dynamic> json, String body) {
    return Journey(
      id: json['id'],
      difficulty: json['difficulty'],
      state: json['state'],
      body: body,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'difficulty': this.difficulty,
        'state': this.state,
      };
}
