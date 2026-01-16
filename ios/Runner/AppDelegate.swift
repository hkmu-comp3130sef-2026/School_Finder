import Flutter
import UIKit
import Mobile

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let bridgeChannel = FlutterMethodChannel(name: "school_app/bridge",
                                              binaryMessenger: controller.binaryMessenger)
    
    // Initialize Go backend on background thread
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0].path
    DispatchQueue.global(qos: .userInitiated).async {
        let initErr = MobileInit(documentsDirectory)
        if initErr != "" {
            print("Go backend init failed: \(initErr)")
        }
    }
    
    bridgeChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "invoke" {
         if let inputBytes = call.arguments as? FlutterStandardTypedData {
             // Pass data directly to Go on a background thread
             DispatchQueue.global(qos: .userInitiated).async {
                 let outputData = MobileCall(inputBytes.data)
                 DispatchQueue.main.async {
                     result(outputData)
                 }
             }
         } else {
             result(FlutterError(code: "INVALID_ARGUMENT", message: "Expected byte array payload", details: nil))
         }
      } else if call.method == "ping" {
         result(true)
      } else {
         result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
