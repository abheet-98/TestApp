import 'package:flutter/material.dart';
import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = HaishinViewController();

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future initAsync() async {
    await controller.initialize(width: 640, height: 480, fps: 30, camera: HaishinViewCameraPosition.back);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.cast_connected),
            onPressed: () {
              controller.connect(rtmpUrl: 'rtmp://xxxxxx/input/', name: 'main');
            },)
          ],
        ),
        body: Center(
          child: Container(
            width: 400,
            height: 400,
            child: HaishinView(controller: controller)
          ),
        ),
      ),
    );
  }
}

