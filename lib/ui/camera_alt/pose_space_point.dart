import '../../vptree/space_point.dart';
import '../camera_alt/bbox.dart';

class PoseSpacePoint extends SpacePoint {
  List<dynamic> pose;
  List<dynamic> confidence;
  Bbox bbox;

  PoseSpacePoint(List<List<double>> pose, List<double> confidence, Bbox bbox)
      : super(null) {
    this.pose = pose;
    this.confidence = confidence;
    this.bbox = bbox;
  }
}
