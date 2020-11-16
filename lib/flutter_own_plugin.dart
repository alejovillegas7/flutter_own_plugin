import 'dart:async';

import 'package:flutter/services.dart';

class FlutterOwnPlugin {
  static const MethodChannel _channel = const MethodChannel('flutter_own_plugin');

  static EventChannel _eventChannel = EventChannel('locationStatusStream');

  static Stream<dynamic> get locationEventStream => _eventChannel.receiveBroadcastStream();

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> get requestPermission async {
    await _channel.invokeMethod('requestPermission');
  }

  static Future<String> get startListeningPosition async {
    String location = 'no coordinates from the plugin';
    location = await _channel.invokeMethod('startListeningLocation');
    return location;
  }
}
