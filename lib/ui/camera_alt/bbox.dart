class Bbox {
  double minX = 0.4184454094855432;
  double maxX = 0.5581277770900933;
  double minY = 0.21103941565226464;
  double maxY = 0.8675315422341545;
  double A = 0.0941;
  double B = 0.0865;

  Bbox({this.minX, this.maxX, this.minY, this.maxY, this.A, this.B});

  static fromJsonArray(List<dynamic> jsonArray) {
    List<Bbox> res;

    if (jsonArray == null) {
      return res;
    }

    res = [];
    for (var json in jsonArray) {
      res.add(Bbox.fromJson(json));
    }

    return res;
  }

  factory Bbox.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return Bbox(
      minX: json['minX'],
      maxX: json['maxX'],
      minY: json['minY'],
      maxY: json['maxY'],
      A: json['A'],
      B: json['B'],
    );
  }

  Map<String, dynamic> toJson() => {
        'minX': this.minX,
        'maxX': this.maxX,
        'minY': this.minY,
        'maxY': this.maxY,
        'A': this.A,
        'B': this.B,
      };
}
