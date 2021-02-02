import '../camera_alt/bbox.dart';
import 'package:vptree/space_point.dart';

class PoseSpacePoint extends SpacePoint {
  List pose;
  List confidence;
  Bbox bbox;
  PoseSpacePoint(List pose, List confidence, Bbox bbox) : super(null);

  static fromJsonArray(List<dynamic> jsonArray) {
    List<PoseSpacePoint> res;

    if (jsonArray == null) {
      return res;
    }

    res = [];
    for (var json in jsonArray) {
      res.add(PoseSpacePoint.fromJson(json));
    }

    return res;
  }

  factory PoseSpacePoint.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    var pose = List<List<double>>();
    (json['pose'] as List).forEach((poseJointCoordsJson) {
      var poseJointCoords = List<double>();
      (poseJointCoordsJson as List).forEach((element) {
        poseJointCoords.add(element);
      });
      pose.add(poseJointCoords);
    });

    var confidence = List<double>();
    (json['confidence'] as List).forEach((element) {
      confidence.add(element);
    });

    return PoseSpacePoint(
      pose,
      confidence,
      Bbox.fromJson(json['bbox']),
    );
  }

  Map<String, dynamic> toJson() => {
        'pose': this.pose,
        'confidence': this.confidence,
        'bbox': this.bbox,
      };
}
