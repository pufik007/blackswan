class PoseJoint {
  final double x;
  final double y;

  PoseJoint({this.x, this.y});

  factory PoseJoint.fromJson(Map<String, dynamic> json) {
    return PoseJoint(
      x: json['x'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() => {'x': this.x, 'y': this.y};
}
