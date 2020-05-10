import 'package:flutter/material.dart';
import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';
import 'package:screen_keep_on/screen_keep_on.dart';

void main() => runApp(MyApp());




class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

var link;
bool valueg = false;
class _MyAppState extends State<MyApp> {
  final controller = RtmpLiveViewController();

  var _hint=" 192.168.0.111 ";
  TextEditingController _textFieldController = TextEditingController();

  void _onChanged(bool value){
    setState(() {
     valueg=value;
     if(valueg==true){
     showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            "Enter the IP of your network",
            textScaleFactor: 0.9,
            style: TextStyle(fontWeight: FontWeight.w300, fontFamily: "Roboto", color: Colors.white),
            ),
          content: Container(
            color: Colors.white,
            child: TextField(
                autofocus: true,
                onTap: (){_hint="";},
                controller: _textFieldController,
                decoration: InputDecoration(hintText: _hint),
                style: TextStyle(fontWeight: FontWeight.w300, fontFamily: "Roboto", color: Colors.black),
              ),
          ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                    _hint=" 192.168.0.111 ";
                    if(_textFieldController.text!="")
                      link=_textFieldController.text;
                    Navigator.of(context).pop();
                   }
                ),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
              )
            ],
          backgroundColor: Colors.black,
          );
      }
     );} 
    });
  }


  @override
  void initState() {
    super.initState();
    ScreenKeepOn.turnOn(true);
    initAsync();
  }

  @override
  void dispose() {
    ScreenKeepOn.turnOn(false);
    super.dispose();
  }

  Future initAsync() async {
    await controller.initialize(width: 640, height: 480, fps: 30, cameraPosition: RtmpLiveViewCameraPosition.back);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Live Stream app'),
          actions: <Widget>[
            ValueListenableBuilder<RtmpStatus>(
              valueListenable: controller.status,
              builder: (context, status, child) => IconButton(
                icon: Icon(status?.isStreaming == true ? Icons.cast_connected : Icons.cast),
                onPressed: () {
                  if (!status.isStreaming)
                    controller.connect(rtmpUrl: 'rtmp://'+link+':2222/live/app', streamName: 'live');
                  else
                    controller.disconnect();
                }
              )
            ),
            ValueListenableBuilder<RtmpStatus>(
              valueListenable: controller.status,
              builder: (context, status, child) => IconButton(
                icon: Icon(status == null ? Icons.camera : status.cameraPosition == RtmpLiveViewCameraPosition.back ? Icons.camera_front : Icons.camera_rear),
                onPressed: status == null ? null : () {
                  controller.swapCamera();
                }
              )
            ),
            Switch(value:valueg , onChanged: (bool value) {_onChanged(value);},)
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(2),
          child: ValueListenableBuilder<RtmpStatus>(
            valueListenable: controller.status,
            builder: (context, status, child) => Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: status?.aspectRatio ?? 1.0,
                  child: RtmpLiveView(controller: controller)
                ),
                SizedBox(height: 10),
                Text(status?.isStreaming == true ? '${status.rtmpUrl} : ${status.streamName}' : 'Not connected.'),
                Text(status != null ? 'Encoding: ${status.width} x ${status.height} ${status.fps} fps.' : ''),
                Text(status != null ? 'Camera: ${status.cameraWidth} x ${status.cameraHeight}' : ''),
              ]
            )
          ),
        )
      )
    );
  }
}

