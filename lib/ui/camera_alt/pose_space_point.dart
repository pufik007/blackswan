import '../camera_alt/bbox.dart';
import 'package:vptree/space_point.dart';

class PoseSpacePoint extends SpacePoint {
  List pose;
  List confidence;
  Bbox bbox;
  PoseSpacePoint(List pose, List confidence, Bbox bbox) : super(null);

  static fromJsonArray(List<dynamic> jsonArray) {
    var pose = List<List<double>>();
    var confidence = List<double>();
    var bbox = List<Object>();

    for (var json in jsonArray) {
      pose.add(json['pose']);
      confidence.add(json['confidence']);
      bbox.add(json['bbox']);
    }
  }

  factory PoseSpacePoint.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return PoseSpacePoint(
      json['pose'],
      json['confidence'],
      Bbox.fromJsonArray(['bbox']),
    );
  }

  Map<String, dynamic> toJson() => {
        'pose': this.pose,
        'confidence': this.confidence,
        'bbox': this.bbox,
      };
}
