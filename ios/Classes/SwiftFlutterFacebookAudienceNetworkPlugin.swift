import Flutter
import UIKit
    
public class SwiftFlutterFacebookAudienceNetworkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_facebook_audience_network", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterFacebookAudienceNetworkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
