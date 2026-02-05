package com.windchaser.runningos

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

/**
 * RunningOS 应用程序类
 * 必须使用 @HiltAndroidApp 注解以启用 Hilt 依赖注入
 */
@HiltAndroidApp
class RunningOSApplication : Application() {

    override fun onCreate() {
        super.onCreate()
        // 应用初始化
    }
}
