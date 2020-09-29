import 'package:test/test.dart';
import '../../../lib/ui/camera_alt/exercises_counter.dart';
import '../../../lib/ui/camera_alt/bbox.dart';
import '../../../lib/ui/camera_alt/vp_tree_manager.dart';
import '../../../lib/ui/camera_alt/pose_space_point.dart';
import '../../../lib/vptree/space_point.dart';
import '../../../lib/vptree/vptree_factory.dart';
import '../../../lib/vptree/vptree.dart';

void main() {
  test('Exercises counter should be incremented', () {
    List<List<double>> pose = [
      [0.48171628, 0.21103942],
      [0.53320309, 0.28876346],
      [0.44125796, 0.2916088],
      [0.55812778, 0.41638895],
      [0.41844541, 0.41206645],
      [0.5105514, 0.44128013],
      [0.44240713, 0.43728491],
      [0.52221238, 0.51763942],
      [0.45909978, 0.52392779],
      [0.55264277, 0.66091287],
      [0.42189935, 0.6672397],
      [0.5499118, 0.85397048],
      [0.42549771, 0.86753154]
    ];

    List<double> confidence = [
      0.9806515,
      0.97254556,
      0.9624879,
      0.9721693,
      0.9917129,
      0.8090379,
      0.68297017,
      0.74535465,
      0.5589173,
      0.89043903,
      0.700753,
      0.96876717,
      0.97490084
    ];

    var bbox = Bbox();

    var poseSpacePointA1 = PoseSpacePoint(pose, confidence, bbox);
    var vpTreeA = new VpTreeFactory().build([poseSpacePointA1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var poseSpacePointB1 = PoseSpacePoint(pose, confidence, bbox);
    var vpTreeB = new VpTreeFactory().build([poseSpacePointB1 as SpacePoint], 1,
        (spacePointA, spacePointB) {
      return VpTreeManager.distance(
          spacePointA as PoseSpacePoint, spacePointB as PoseSpacePoint);
    });

    var vpTreesPool = Map<String, Vptree>();
    vpTreesPool['A'] = vpTreeA;
    vpTreesPool['B'] = vpTreeB;

    var vpTreeManager = VpTreeManager();
    vpTreeManager.put("squats", vpTreesPool);
    var counter = ExercisesCounter(vpTreeManager);

    var repsCount = counter.repsCounter(pose, confidence, bbox);

    expect(repsCount, 1);
  });
}

//flutter test test\ui\camera_alt\exercises_counter_test.dart
