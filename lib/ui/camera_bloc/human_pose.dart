import './pose_joint.dart';

class HumanPose {
  final PoseJoint head;
  final PoseJoint handTopRight;
  final PoseJoint handTopLeft;
  final List<dynamic> results;

  HumanPose({this.head, this.handTopRight, this.handTopLeft, this.results});

  factory HumanPose.fromJson(Map<String, dynamic> json) {
    return HumanPose(
      head: PoseJoint.fromJson(json['head']),
      handTopRight: PoseJoint.fromJson(json['hand_top_right']),
      handTopLeft: PoseJoint.fromJson(json['hand_top_left']),
    );
  }

  Map<String, dynamic> toJson() => {
        'head': this.head,
        'handTopRight': this.handTopRight,
        'handTopLeft': this.handTopLeft,
      };
}
