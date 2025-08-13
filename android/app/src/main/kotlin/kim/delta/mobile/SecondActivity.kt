package kim.delta.mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import android.os.Bundle
import io.flutter.FlutterInjector

class SecondActivity : FlutterActivity() {
    private var shouldDestroyEngine = true
    override fun provideFlutterEngine(context: android.content.Context): FlutterEngine {
        // 标记引擎由外部管理
        shouldDestroyEngine = false
        val app = context.applicationContext as MultiWindowApplication
                // 如果已有引擎，先销毁
        flutterEngine?.let {
            if (shouldDestroyEngine) {
                it.destroy()
            }
            // FlutterEngineGroup 不需要手动移除引擎
            // 当引擎被销毁后，它会自动从组中移除
        }
        return app.engineGroup.createAndRunEngine(
            this,
            DartExecutor.DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                "dAppMain"  // 你的自定义入口点名称
            )
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        // 不自动销毁引擎
    }

    override fun onDestroy() {
        try {
            // 安全销毁引擎
            flutterEngine?.let {
                if (shouldDestroyEngine) {
                    it.destroy()
                }
            }
        } finally {
            super.onDestroy()
        }
    }
}