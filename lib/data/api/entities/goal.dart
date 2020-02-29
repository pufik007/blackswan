class Goal {
  final int id;
  final String name;
  final String gender;

  Goal({this.id, this.name, this.gender});

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'gender': this.gender,
      };
}
