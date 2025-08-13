package kim.delta.mobile

import io.flutter.embedding.engine.FlutterEngineGroup
import android.app.Application

class MultiWindowApplication : Application() {
    lateinit var engineGroup: FlutterEngineGroup
        private set

    override fun onCreate() {
        super.onCreate()
        engineGroup = FlutterEngineGroup(this)
    }

    override fun onTerminate() {
        // 可在此处添加全局引擎清理逻辑
        super.onTerminate()
    }
}