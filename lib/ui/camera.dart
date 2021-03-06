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

Future<String> convertYUV420toImageColor(CameraImage image) async {
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
    var fixedImage = imglib.copyRotate(img, 90);
    var resizedImage = imglib.copyResize(fixedImage,
        width: 250, height: fixedImage.height * fixedImage.width ~/ 250);
    imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
    List<int> png = pngEncoder.encodeImage(resizedImage);
    return base64Encode(png);
  } catch (e) {
    print(">>>>>>>>>>>> ERROR:" + e.toString());
  }
  return null;
}

Future<HumanPose> parseHumanPose(String event) async {
  var jsonResponse = json.decode(event);
  if (jsonResponse != null) {
    var jsonResponseBackText = jsonResponse['json_response_back'];
    if (jsonResponseBackText != null) {
      var jsonResponseBack = json.decode(jsonResponseBackText);
      if (jsonResponseBack != null && jsonResponseBack.length > 0) {
        var posePointsWrapper = jsonResponseBack[0];
        if (posePointsWrapper != null) {
          var posePoints = posePointsWrapper['pose_points'];
          if (posePoints != null) {
            var humanPose = HumanPose.fromJson(posePoints);
            return humanPose;
          }
        }
      }
    }
  }
  return null;
}

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  CameraPage(this.cameras);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;
  bool isPredictingRemotely = false;
  var currentHumanPose = HumanPose();

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
          sendCameraImageToWebSocket(image);
        }
      });
    });
  }

  Future<void> sendCameraImageToWebSocket(CameraImage image) async {
    var img64 = await compute(convertYUV420toImageColor, image);
    debugPrint('1');
    channel.sink.add(img64);
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

  Future<void> onData(event) async {
    debugPrint('2');
    debugPrint(event);
    isPredictingRemotely = false;

    if (event != null) {
      var humanPose = await compute(parseHumanPose, event.toString());
      if (humanPose != null) {
        debugPrint('3');
        setState(() {
          currentHumanPose = humanPose;
        });
      }
    }
    return null;
  }

  @override
  void dispose() {
    controller?.dispose();
    this.channel.sink.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: CustomPaint(
          foregroundPainter: GuidelinePainter(currentHumanPose),
          child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller)),
        ));
  }
}

class GuidelinePainter extends CustomPainter {
  var currentHumanPose;
  GuidelinePainter(this.currentHumanPose);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final pointMode = ui.PointMode.points;

    var poseJoints = [
      this.currentHumanPose.head,
      this.currentHumanPose.handTopLeft,
      this.currentHumanPose.handTopRight,
      this.currentHumanPose.bodyTopRight,
      this.currentHumanPose.bodyTopLeft,
      this.currentHumanPose.bodyBottomLeft,
      this.currentHumanPose.bodyBottomRight,
      this.currentHumanPose.handBottomRight,
      this.currentHumanPose.handBottomLeft,
      this.currentHumanPose.footTopRight,
      this.currentHumanPose.footTopLeft,
      this.currentHumanPose.footBottomRight,
      this.currentHumanPose.footBottomLeft,
    ];

    List<Offset> points = List<Offset>();

    for (var i = 0; i < poseJoints.length; i++) {
      if (poseJoints[i] != null) {
        points.add(Offset(
            size.width * poseJoints[i].x, size.height * poseJoints[i].y));
        print(points);
        print(points.length);
      }
    }

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
