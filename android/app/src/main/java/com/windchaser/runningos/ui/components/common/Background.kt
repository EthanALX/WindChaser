package com.windchaser.runningos.ui.components.common

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.unit.dp
import com.windchaser.runningos.ui.theme.AppColors

/**
 * Cyber Grid 背景效果
 */
@Composable
fun CyberGridBackground() {
    Canvas(modifier = Modifier.fillMaxSize()) {
        val step = 40.dp.toPx()
        val strokeWidth = 1.dp.toPx()
        val width = size.width
        val height = size.height

        // 绘制垂直线
        var x = 0f
        while (x <= width) {
            drawLine(
                color = AppColors.GridLine,
                start = Offset(x, 0f),
                end = Offset(x, height),
                strokeWidth = strokeWidth
            )
            x += step
        }

        // 绘制水平线
        var y = 0f
        while (y <= height) {
            drawLine(
                color = AppColors.GridLine,
                start = Offset(0f, y),
                end = Offset(width, y),
                strokeWidth = strokeWidth
            )
            y += step
        }
    }
}
