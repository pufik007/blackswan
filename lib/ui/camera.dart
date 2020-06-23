import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


List<CameraDescription> cameras;

Camera() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(CameraApp());
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
      "ws://ec2-18-218-127-154.us-east-2.compute.amazonaws.com/frame"));
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    this.channel.stream.listen(onDone());

    controller = CameraController(cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  onDone() {
    debugPrint("Socket is closed");
  }
  onError(err) {
    debugPrint(err.message);
  }
  onData(event) {
    debugPrint(event);
  }


  @override
  void dispose() {
    controller?.dispose();
    this.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
