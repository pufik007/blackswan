class Level {
  final int id;
  final int number;
  final int diamondsReward;

  Level({this.id, this.number, this.diamondsReward});

  static fromJsonArray(List<dynamic> jsonArray) {
    var res = List<Level>();

    for(var json in jsonArray) {
      res.add(Level.fromJson(json));
    }

    return res;
  }

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      number: json['number'],
      diamondsReward: json['diamonds_reward'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'number': this.number,
        'diamonds_reward': this.diamondsReward,
      };
}
