import 'package:flutter/material.dart';
import './bbox.dart';

class VpTreeManager {
//   var config = config['exercises'][exercise];
//   var debug = config['debug'];
//   Map images;
//   Map joints;
//   Map trees;
//   var annotator = null;

//   restore() {}

  getNearest(List<dynamic> pose, List<dynamic> confidence, Bbox bbox) {
//       var result = Map();
//        for (var key in trees) {
//         result.putIfAbsent(key, () => trees.get_nearest_neighbor(point));
//       }

//       if (debug){
//       print([[key, round(item[0], 4)] for key, item in result.items()]);
//       }

//       return min(result.items(), key=operator.itemgetter(1));
  }
}

// import glob
// import operator
// import vptree
// import cv2
// import pickle
// import numpy as np

// from src.utils.drawer import Drawer
// from src.system.interface import AnnotatorInterface

// class VpTree(object):
//     def __init__(self, config, exercise):

//         self.config = config['exercises'][exercise]
//         self.debug = config['debug']

//         self.images = dict()
//         self.joints = dict()
//         self.trees = dict()

//         self.annotator = None

//         pass

//     @staticmethod
//     def distance(a, b):

//         point_a = (a[0] - a[0].min(axis=0))/(a[0].max(axis=0) - a[0].min(axis=0))
//         point_b = (b[0] - b[0].min(axis=0))/(b[0].max(axis=0) - b[0].min(axis=0))

//         confidence = [min([x, y]) for x, y in zip(a[1][0], b[1][0])]
//         confidence_sum = sum(confidence)
//         dist = sum((np.linalg.norm(point_a-point_b, axis=1)*confidence))/confidence_sum

//         return dist

//     def build(self):

//         video = cv2.VideoCapture(self.config['video'])
//         self.annotator = AnnotatorInterface.build(max_persons=1)

//         while True:

//             ret, frame = video.read()
//             if not ret:
//                 break

//             frame_id = int(video.get(cv2.CAP_PROP_POS_FRAMES))
//             persons = self.annotator.update(frame)

//             pose_2d = [p['pose_2d'] for p in persons]
//             confidence = [p['confidence'] for p in persons]

//             for key, ids in self.config['frame_id'].items():
//                 if frame_id in ids:
//                     target_frame = 1

//                     joints = pose_2d[0].joints

//                     if self.debug:
//                         print(key, joints, confidence)

//                     if key in self.joints:
//                         self.joints[key].append([joints, confidence])
//                     else:
//                         self.joints[key] = []
//                         self.joints[key].append([joints, confidence])
//                     break

//                 else:
//                     target_frame = 0

//             if self.debug:
//                 frame = Drawer.draw_scene(frame, pose_2d, 0, target_frame, 0, frame_id)
//                 cv2.imshow('frame', frame)

//                 if cv2.waitKey(1) & 0xFF == ord('q'):
//                     break

//         video.release()
//         self.annotator.terminate()

//         if self.debug:
//             cv2.destroyAllWindows()

//         for key, joints in self.joints.items():
//             self.trees[key] = vptree.VPTree(joints, self.distance)

//     def dump(self):
//         with open(self.config['model'], 'wb') as file:
//             pickle.dump(self.trees, file)
//         pass

//     def restore(self):
//         with open(self.config['model'], 'rb') as f:
//             self.trees = pickle.load(f)
//         pass

//     def get_nearest(self, point):
//         result = dict()
//         for key, trees in self.trees.items():
//             result[key] = trees.get_nearest_neighbor(point)

//         if self.debug:
//             print([[key, round(item[0], 4)] for key, item in result.items()])

//         return min(result.items(), key=operator.itemgetter(1))
