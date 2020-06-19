import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyApp extends StatefulWidget {
  final title = 'WebSocket Demo';
  MyApp({Key key, title}) : super(key: key);
  
  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse("ws://ec2-18-218-127-154.us-east-2.compute.amazonaws.com/frame"));
   @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.channel.stream.listen(onData, onError: onError, onDone: onDone);
    setState(() {});
}

onDone(){
    debugPrint("Socket is closed - Ya eto sdelal!!1");
  }

  onError(err){
    debugPrint(err.runtimeType.toString());
    WebSocketChannelException ex = err;
    debugPrint(ex.message);
  }

  onData(event){
    debugPrint(event);
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
  }}
  

  