import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyApp extends StatefulWidget {
  final title = 'WebSocket Demo';
  MyApp({Key key, title}) : super(key: key);
  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
      "ws://ec2-18-218-127-154.us-east-2.compute.amazonaws.com/frame"));
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.channel.stream.listen(onDone());
    setState(() {});
  }
  onDone() {
    debugPrint("Socket is closed1");
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(widget.title),
    ));
  }
}
