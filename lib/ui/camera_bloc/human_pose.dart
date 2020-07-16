import './pose_joint.dart';

class HumanPose {
  final PoseJoint head;
  final PoseJoint handTopRight;
  final PoseJoint handTopLeft;
  final PoseJoint bodyTopRight;
  final PoseJoint bodyTopLeft;
  final PoseJoint bodyBottomLeft;
  final PoseJoint bodyBottomRight;
  final PoseJoint handBottomRight;
  final PoseJoint handBottomLeft;
  final PoseJoint footTopRight;
  final PoseJoint footTopLeft;
  final PoseJoint footBottomRight;
  final PoseJoint footBottomLeft;
  final List<dynamic> results;

  HumanPose(
      {this.bodyBottomLeft,
      this.bodyBottomRight,
      this.handBottomRight,
      this.handBottomLeft,
      this.footTopRight,
      this.footTopLeft,
      this.footBottomRight,
      this.footBottomLeft,
      this.head,
      this.handTopRight,
      this.handTopLeft,
      this.bodyTopRight,
      this.bodyTopLeft,
      this.results});

  factory HumanPose.fromJson(Map<String, dynamic> json) {
    return HumanPose(
      head: PoseJoint.fromJson(json['head']),
      handTopRight: PoseJoint.fromJson(json['hand_top_right']),
      handTopLeft: PoseJoint.fromJson(json['hand_top_left']),
      bodyTopRight: PoseJoint.fromJson(json['body_top_right']),
      bodyTopLeft: PoseJoint.fromJson(json['body_top_left']),
      bodyBottomLeft: PoseJoint.fromJson(json['body_bottom_left']),
      bodyBottomRight: PoseJoint.fromJson(json['body_bottom_right']),
      handBottomRight: PoseJoint.fromJson(json['hand_bottom_right']),
      handBottomLeft: PoseJoint.fromJson(json['hand_bottom_left']),
      footTopRight: PoseJoint.fromJson(json['foot_top_right']),
      footTopLeft: PoseJoint.fromJson(json['foot_top_left']),
      footBottomRight: PoseJoint.fromJson(json['foot_bottom_right']),
      footBottomLeft: PoseJoint.fromJson(json['foot_bottom_left']),
    );
  }

  Map<String, dynamic> toJson() => {
        'head': this.head,
        'handTopRight': this.handTopRight,
        'handTopLeft': this.handTopLeft,
        'bodyTopRight': this.bodyTopRight,
        'bodyTopLeft': this.bodyTopLeft,
        'bodyBottomLeft': this.bodyBottomLeft,
        'bodyBottomRight': this.bodyBottomRight,
        'handBottomRight': this.handBottomRight,
        'handBottomLeft': this.handBottomLeft,
        'footTopRight': this.footTopRight,
        'footTopLeft': this.footTopLeft,
        'footBottomRight': this.footBottomRight,
        'footBottomLeft': this.footBottomLeft,
      };
}
