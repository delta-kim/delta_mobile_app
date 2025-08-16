import Flutter
import UIKit
import AppTrackingTransparency
import AdSupport

@main
@objc class AppDelegate: FlutterAppDelegate {

    lazy var flutterEngine = FlutterEngine(name: "multi_window")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 初始化主引擎
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        
        // 获取 FlutterViewController
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("RootViewController 不是 FlutterViewController")
        }
        
        // // 方法通道设置
        // let channel = FlutterMethodChannel(
        //     name: "multi_window",
        //     binaryMessenger: controller.binaryMessenger
        // )
        
        // channel.setMethodCallHandler { [weak self] (call, result) in
        //     if call.method == "openDApp" {
        //         self?.openSecondWindow()
        //         result(nil)
        //     } else {
        //         result(FlutterMethodNotImplemented)
        //     }
        // }
        
        // 广告视图工厂注册
        let bannerFactory = IOSFlutterPlatformViewFactory(messenger: controller.binaryMessenger)
        registrar(forPlugin: "ad_set_banner")?.register(
            bannerFactory,
            withId: "ad_set/banner"
        )
        
        let nativeFactory = IOSFlutterPlatformNativeFactory(messenger: controller.binaryMessenger, withVC: controller)
        registrar(forPlugin: "ad_set_native")?.register(
            nativeFactory,
            withId: "ad_set/native"
        )
        
        // 广告SDK初始化
        OSETSDKPlugin.shareInstance().initSDK(self, with: self.window)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    } 
}
