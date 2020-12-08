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
}
