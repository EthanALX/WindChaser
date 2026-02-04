package com.windchaser.runningos

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

object AppColors {
    // Primary colors from design
    val Primary = Color(0xFF7F0DF2)
    val PrimaryGlow = Color(0xFF9D4BF6)

    // Background colors
    val Background = Color(0xFF0A0E14)
    val BackgroundLight = Color(0xFFF7F5F8)
    val Surface = Color(0xFF131620)
    val SurfaceTransparent = Color(0x99131620) // rgba(19, 22, 32, 0.6)

    // Grid and background effects
    val GridLine = Color(0x0D7F0DF2) // rgba(127, 13, 242, 0.05)
    val CyberGrid = Color(0x0D7F0DF2)

    // Text colors
    val TextPrimary = Color.White
    val TextSecondary = Color(0xFF9CA3AF)
    val TextTertiary = Color(0xFF6B7280)

    // Heatmap colors
    val HeatmapEmpty = Color(0xFF1E2330)
    val HeatmapLevel1 = Color(0x407F0DF2) // 25%
    val HeatmapLevel2 = Color(0x807F0DF2) // 50%
    val HeatmapLevel3 = Color(0xB27F0DF2) // 70%
    val HeatmapLevel4 = Color(0xFF7F0DF2) // 100%

    // Card backgrounds
    val CardBackground = Color(0x66131620) // rgba(19, 22, 32, 0.4)
    val CardHover = Color(0x99131620) // rgba(19, 22, 32, 0.6)
}

private val DarkColors = darkColorScheme(
    primary = AppColors.Primary,
    background = AppColors.Background,
    surface = AppColors.Surface,
    onPrimary = Color.White,
    onBackground = Color.White,
    onSurface = Color.White
)

@Composable
fun RunningOSTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = DarkColors,
        typography = androidx.compose.material3.Typography().apply {
            // Display font for Space Grotesk style
            this.displayLarge = androidx.compose.material3.Typography().displayLarge.copy(
                fontFamily = FontFamily.Default,
                fontWeight = FontWeight.W400
            )
        },
        content = content
    )
}

// Text styles matching the design
object AppTextStyle {
    val Header = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Bold,
        fontSize = 20.sp,
        letterSpacing = 2.sp
    )

    val Title = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Bold,
        fontSize = 18.sp
    )

    val CardTitle = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Bold,
        fontSize = 11.sp,
        letterSpacing = 1.sp
    )

    val StatValue = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Bold,
        fontSize = 24.sp
    )

    val StatLabel = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 10.sp,
        letterSpacing = 1.sp
    )

    val MetricValue = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Bold,
        fontSize = 36.sp
    )

    val MetricLabel = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Medium,
        fontSize = 14.sp,
        letterSpacing = 0.5.sp
    )

    val Body = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 14.sp
    )

    val Caption = androidx.compose.ui.text.TextStyle(
        fontFamily = FontFamily.Default,
        fontWeight = FontWeight.Normal,
        fontSize = 12.sp
    )
}
