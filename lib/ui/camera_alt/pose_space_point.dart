import '../camera_alt/bbox.dart';
import 'package:vptree/space_point.dart';

class PoseSpacePoint extends SpacePoint {
  List<List<double>> pose;
  List<double> confidence;
  Bbox bbox;
  PoseSpacePoint(List<List<double>> pose, List<double> confidence, Bbox bbox)
      : super(null) {
    this.pose = pose;
    this.confidence = confidence;
    this.bbox = bbox;
  }

  static fromJsonArray(Map<String, dynamic> jsonArray) {
    List<PoseSpacePoint> res;

    if (jsonArray == null) {
      return res;
    }
    res = [];

    res.add(PoseSpacePoint.fromJson(jsonArray));
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
