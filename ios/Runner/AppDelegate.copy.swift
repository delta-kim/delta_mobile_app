import Flutter
import UIKit
import AppTrackingTransparency
import AdSupport


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      // 获取 FlutterViewController
      guard let controller = window?.rootViewController as? FlutterViewController else {
          fatalError("RootViewController 不是 FlutterViewController")
      }
      // 创建 Banner 视图工厂
      let bannerFactory = IOSFlutterPlatformViewFactory(messenger: controller.binaryMessenger)
      
      // 注册视图工厂（关键步骤）
      registrar(forPlugin: "ad_set_banner")?.register(
          bannerFactory,
          withId: "ad_set/banner"
      )
      // 创建 native 视图工厂
      let nativeFactory = IOSFlutterPlatformNativeFactory(messenger: controller.binaryMessenger, withVC: controller)
      // 注册视图工厂（关键步骤）
      registrar(forPlugin: "ad_set_native")?.register(
        nativeFactory,
          withId: "ad_set/native"
      )
      //注册消息通道
      OSETSDKPlugin.shareInstance().initSDK(self, with: self.window);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    // iOS获取IDFA权限 代码 可不用 下面的 直接在flutter端调用 checkAndReqPermission 函数
    // override func applicationDidBecomeActive(_ application: UIApplication) {
    //     if #available(iOS 14, *) {
    //         // 用户未决定，弹出授权请求
    //         ATTrackingManager.requestTrackingAuthorization { status in
    //         }
    //     }
    // }
}
