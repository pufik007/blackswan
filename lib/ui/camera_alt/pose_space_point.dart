import '../../vptree/space_point.dart';
import '../camera_alt/bbox.dart';

class PoseSpacePoint extends SpacePoint {
  List<dynamic> pose;
  List<dynamic> confidence;
  Bbox bbox;
}
