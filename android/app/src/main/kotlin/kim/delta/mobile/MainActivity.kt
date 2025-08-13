package kim.delta.mobile

//import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import androidx.annotation.NonNull
import android.os.Bundle 

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "multi_window"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // 设置方法通道
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openDApp" -> {
                    openSecondWindow(this)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    fun openSecondWindow(context: android.content.Context) {
        Intent(context, SecondActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }.also { intent -> context.startActivity(intent)}
    }
}