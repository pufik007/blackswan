import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image/image.dart' as imglib;
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'camera_bloc/human_pose.dart';
import 'dart:ui' as ui;

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  CameraPage(this.cameras);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  bool isPredictingRemotely = false;

  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
      "ws://ec2-18-218-127-154.us-east-2.compute.amazonaws.com/frame"));
  @override
  void initState() {
    super.initState();

    this.channel.stream.listen(onData, onError: onError, onDone: onDone);
    controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
      controller.startImageStream((CameraImage image) {
        if (!isPredictingRemotely) {
          isPredictingRemotely = true;
          convertYUV420toImageColor(image);
        }
      });
    });
  }

  Future<Image> convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;
      // print("uvRowStride: " + uvRowStride.toString());
      // print("uvPixelStride: " + uvPixelStride.toString());

      // imgLib -> Image package from https://pub.dartlang.org/packages/image
      var img = imglib.Image(width, height); // Create Image buffer
      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final int uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = y * width + x;

          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];
          // Calculate pixel color
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
        }
      }
      imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
      List<int> png = pngEncoder.encodeImage(img);

      String img64 = base64Encode(png);
      channel.sink.add(img64);
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  onDone() {
    debugPrint("Socket is closed");
    isPredictingRemotely = false;
  }

  onError(err) {
    debugPrint(err.runtimeType.toString());
    WebSocketChannelException ex = err;
    debugPrint(ex.message);
  }

  onData(event) {
    debugPrint(event);
    isPredictingRemotely = false;

    if (event != null) {
      var jsonResponse = json.decode(event);
      if (jsonResponse != null) {
        var jsonResponseBack = jsonResponse['json_response_back'];
        if (jsonResponseBack != null && jsonResponseBack.length > 0) {
          var posePointsWrapper = jsonResponseBack[0];
          if (posePointsWrapper != null) {
            var posePoints = posePointsWrapper['pose_points'];
            if (posePoints != null) {
              var humanPose = HumanPose.fromJson(posePoints);
            }

            // convert posePoint to human pose
            // update heead with human pose
          }
        }
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    this.channel.sink.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Center(
        child: Container(
            height: double.infinity,
            child: new CustomPaint(
              foregroundPainter: new GuidelinePainter(),
              child: new AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: new CameraPreview(controller)),
            )));
  }
}

class GuidelinePainter extends CustomPainter {
  var heead = HumanPose();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final pointMode = ui.PointMode.points;

    var poseJoints = [heead.head, heead.handTopLeft, heead.handTopRight];
    List<Offset> points = List<Offset>();
    for (var i = 0; i < poseJoints.length; i++) {
      if (poseJoints[i] != null) {
        points.add(Offset(poseJoints[i].x, poseJoints[i].y));
        print(points);
        print(points.length);
      }
    }

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
