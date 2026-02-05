package com.windchaser.runningos

import android.Manifest
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import com.windchaser.runningos.ui.screens.home.HomeScreen
import com.windchaser.runningos.ui.theme.RunningOSTheme
import dagger.hilt.android.AndroidEntryPoint

/**
 * 主 Activity - 应用入口
 */
@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    private val viewModel: HomeViewModel by viewModels()

    // 权限请求
    private val locationPermissionRequest = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { /* 权限结果处理 */ }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 请求位置权限
        locationPermissionRequest.launch(Manifest.permission.ACCESS_FINE_LOCATION)

        setContent {
            RunningOSTheme {
                HomeScreen(viewModel = viewModel)
            }
        }
    }
}
