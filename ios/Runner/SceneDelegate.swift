class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var flutterEngine: FlutterEngine?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // 检查是否为第二个窗口
        if session.userInfo?["isSecondWindow"] as? Bool == true {
            setupSecondWindow(sceneSession: session)
        } else {
            setupMainWindow()
        }
    }
    
    private func setupMainWindow() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let flutterViewController = FlutterViewController(engine: appDelegate.flutterEngine, nibName: nil, bundle: nil)
        
        // 设置方法通道
        let channel = FlutterMethodChannel(name: "multi_window", binaryMessenger: flutterViewController.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "openDApp" {
                self?.openSecondWindow()
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        window?.rootViewController = flutterViewController
        window?.makeKeyAndVisible()
    }
    
    private func setupSecondWindow(sceneSession: UISceneSession) {
        // 为第二个窗口创建新的Flutter引擎
        flutterEngine = FlutterEngine(name: "second flutter engine")
        flutterEngine?.run(withEntrypoint: "dAppMain")
        GeneratedPluginRegistrant.register(with: flutterEngine!)
        
        let flutterViewController = FlutterViewController(engine: flutterEngine!, nibName: nil, bundle: nil)
        window?.rootViewController = flutterViewController
        window?.makeKeyAndVisible()
    }
    
    private func openSecondWindow() {
        let userActivity = NSUserActivity(activityType: "com.yourcompany.yourapp.secondWindow")
        userActivity.userInfo = ["isSecondWindow": true]
        
        let options = UIScene.ActivationRequestOptions()
        options.requestingScene = window?.windowScene
        
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: options) { error in
            if let error = error {
                print("Failed to open second window: \(error.localizedDescription)")
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // 清理第二个窗口的引擎
        if let session = (scene as? UIWindowScene)?.session,
           session.userInfo?["isSecondWindow"] as? Bool == true {
            flutterEngine?.destroy()
            flutterEngine = nil
        }
    }
}