package com.school.finder

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import mobile.Mobile

class MainActivity: FlutterActivity() {
    private val CHANNEL = "school_app/bridge"
    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize the Go backend on a background thread
        scope.launch(Dispatchers.IO) {
            val appPath = context.filesDir.absolutePath
            val initErr = Mobile.init(appPath)
            if (initErr != "") {
                println("Go backend init failed: $initErr")
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "invoke" -> {
                    val inputBytes = call.arguments as? ByteArray
                    if (inputBytes == null) {
                        result.error("INVALID_ARGUMENT", "Expected byte array payload", null)
                        return@setMethodCallHandler
                    }
                    
                    // Run Go call on IO thread to prevent UI blocking
                    scope.launch(Dispatchers.IO) {
                        try {
                            val outputBytes = Mobile.call(inputBytes)
                            withContext(Dispatchers.Main) {
                                result.success(outputBytes)
                            }
                        } catch (e: Exception) {
                            withContext(Dispatchers.Main) {
                                result.error("NATIVE_ERROR", e.message, null)
                            }
                        }
                    }
                }
                "ping" -> {
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        scope.cancel()
    }
}
