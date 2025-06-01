package com.example.flutter_study

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.android.TransparencyMode

class MainActivity: FlutterActivity() {
    override fun getRenderMode(): RenderMode {
        return RenderMode.texture // <- 중요: TextureView 사용 강제
    }

    override fun getTransparencyMode(): TransparencyMode {
        return TransparencyMode.opaque
    }
}