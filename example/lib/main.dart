import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_own_plugin/flutter_own_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _currentLocation = 'where are u at?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterOwnPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> requestPermission() async {
    await FlutterOwnPlugin.requestPermission;
  }

  Future<void> getPosition2() async {
    String location = 'no location from flutter';
    try {
      location = await FlutterOwnPlugin.startListeningPosition;
    } catch (e) {
      debugPrint('error: $e');
    }
    setState(() {
      _currentLocation = location;
    });
  }

  Future<String> startListening() async {
    String location = 'no location from flutter';
    try {
      location = await FlutterOwnPlugin.startListeningPosition;
    } catch (e) {
      debugPrint('error: $e');
    }
    return location;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              FlatButton(
                onPressed: requestPermission,
                child: Text('request permission'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    color: Colors.blue,
                    onPressed: startListening,
                    child: Text('start listening position'),
                  ),
                  Text(_currentLocation),
                  StreamBuilder<String>(builder: (context, data) {
                    if (data != null) {
                      _currentLocation = data.data ?? 'data.data is null';
                    }
                    return Text(_currentLocation);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
