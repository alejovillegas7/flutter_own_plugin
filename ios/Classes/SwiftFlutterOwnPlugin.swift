import Flutter
import UIKit
import CoreLocation

public class SwiftFlutterOwnPlugin: NSObject, FlutterPlugin {
    let locationManager = CoreLocation.CLLocationManager()
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_own_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterOwnPlugin()
    let eventChannel = FlutterEventChannel(name: "locationStatusStream", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(SwiftStreamHandler())
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "requestPermission":
        requestPermission()
    case "startListeningLocation":
        startListeningPosition(result : result)
    default:
        result("no method found")
    }
  }
    
    private func requestPermission(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func startListeningPosition(result: FlutterResult){
        
    }
    
    class SwiftStreamHandler : NSObject, FlutterStreamHandler {
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            <#code#>
        }
        
        
    }
}
