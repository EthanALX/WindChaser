package com.windchaser.runningos.ui.components.common

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyHorizontalGrid
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Grade
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.windchaser.runningos.ui.theme.AppColors

/**
 * 统计数据行
 */
@Composable
fun StatsRow(
    marathons: Int,
    runs: Int,
    lifeKm: Double
) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        modifier = Modifier.fillMaxWidth()
    ) {
        StatBox(
            value = marathons.toString(),
            label = "MARATHONS",
            modifier = Modifier.weight(1f)
        )
        StatBox(
            value = runs.toString(),
            label = "RUNS",
            modifier = Modifier.weight(1f)
        )
        StatBox(
            value = String.format("%.1fk", lifeKm / 1000),
            label = "LIFE KM",
            modifier = Modifier.weight(1f)
        )
    }
}

@Composable
fun StatBox(value: String, label: String, modifier: Modifier = Modifier) {
    GlassCard(
        border = Color.White.copy(alpha = 0.05f),
        padding = 12.dp,
        modifier = modifier
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            Text(
                value,
                color = Color.White,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold
            )
            Text(
                label,
                color = AppColors.TextTertiary,
                fontSize = 10.sp,
                letterSpacing = 1.sp
            )
        }
    }
}

/**
 * 个人最佳成绩卡片
 */
@Composable
fun PersonalBestsCard(
    fiveK: String,
    tenK: String,
    half: String
) {
    GlassCard(
        border = Color.White.copy(alpha = 0.1f),
        padding = 16.dp
    ) {
        Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Icon(
                    imageVector = Icons.Outlined.Grade,
                    contentDescription = null,
                    tint = AppColors.Primary,
                    modifier = Modifier.size(18.dp)
                )
                Text(
                    "Personal Bests",
                    color = Color.White,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold,
                    letterSpacing = 1.5.sp
                )
            }
            Row(
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                BestCell(
                    title = "5K",
                    value = fiveK,
                    modifier = Modifier.weight(1f)
                )
                BestCell(
                    title = "10K",
                    value = tenK,
                    modifier = Modifier.weight(1f)
                )
                BestCell(
                    title = "Half",
                    value = half,
                    modifier = Modifier.weight(1f)
                )
            }
        }
    }
}

@Composable
fun BestCell(title: String, value: String, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .clip(RoundedCornerShape(8.dp))
            .background(Color.White.copy(alpha = 0.05f))
            .padding(vertical = 12.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Text(
            title,
            color = AppColors.TextSecondary,
            fontSize = 12.sp
        )
        Text(
            value,
            color = Color.White,
            fontSize = 18.sp,
            fontWeight = FontWeight.Bold
        )
    }
}

/**
 * 指标卡片
 */
@Composable
fun MetricCard(
    title: String,
    value: String,
    unit: String,
    accent: Color
) {
    GlassCard(
        border = accent.copy(alpha = 0.2f),
        padding = 20.dp
    ) {
        Column {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    title.uppercase(),
                    color = AppColors.TextSecondary,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    letterSpacing = 1.5.sp
                )
            }
            Box(modifier = Modifier.height(8.dp))
            Row(
                verticalAlignment = Alignment.Bottom,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                Text(
                    value,
                    color = Color.White,
                    fontSize = 40.sp,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    unit,
                    color = AppColors.TextSecondary,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Medium
                )
            }
        }
    }
}

/**
 * 活动热力图卡片
 */
@Composable
fun HeatmapCard() {
    val rows = 7
    val columns = 18
    val data = listOf(
        2,0,4,3,0,0,3,
        0,0,4,2,0,1,0,
        4,3,0,2,0,0,4,
        0,1,0,4,0,0,0,
        2,0,0,4,0,0,0,
        0,4,0,0,1,0,0,
        2,0,3,0,0,4,0,
        0,0,0,0,2,0,0,
        4,0,0,0,0,3,0,
        0,4,0,0,0,0,0,
        0,0,1,0,4,0,0,
        1,0,0,2,0,0,0,
        0,4,0,0,1,0,0,
        2,0,3,0,0,4,0,
        0,0,0,0,2,0,0,
        4,0,0,0,0,3,0,
        0,4,0,0,0,0,0,
        0,0,1,0,4,0,0
    )

    GlassCard(
        border = Color.White.copy(alpha = 0.1f),
        padding = 20.dp
    ) {
        Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Icon(
                        imageVector = Icons.Outlined.Grade,
                        contentDescription = null,
                        tint = AppColors.Primary,
                        modifier = Modifier.size(20.dp)
                    )
                    Text(
                        "Activity Heatmap",
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
                Spacer(modifier = Modifier.weight(1f))
                HeatmapLegend()
            }

            LazyHorizontalGrid(
                rows = GridCells.Fixed(rows),
                modifier = Modifier.height(100.dp),
                horizontalArrangement = Arrangement.spacedBy(4.dp),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                items(data.take(rows * columns)) { level ->
                    Box(
                        modifier = Modifier
                            .size(12.dp)
                            .clip(RoundedCornerShape(2.dp))
                            .background(heatmapColor(level))
                    )
                }
            }
        }
    }
}

@Composable
fun HeatmapLegend() {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Text(
            "Less",
            color = AppColors.TextSecondary,
            fontSize = 12.sp
        )
        Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
            HeatLegendBlock(color = AppColors.HeatmapEmpty)
            HeatLegendBlock(color = AppColors.HeatmapLevel1)
            HeatLegendBlock(color = AppColors.HeatmapLevel3)
            HeatLegendBlock(color = AppColors.HeatmapLevel4)
        }
        Text(
            "More",
            color = AppColors.TextSecondary,
            fontSize = 12.sp
        )
    }
}

@Composable
fun HeatLegendBlock(color: Color) {
    Box(
        modifier = Modifier
            .size(12.dp)
            .clip(RoundedCornerShape(2.dp))
            .background(color)
    )
}

private fun heatmapColor(level: Int): Color {
    return when (level) {
        1 -> AppColors.HeatmapLevel1
        2 -> AppColors.HeatmapLevel2
        3 -> AppColors.HeatmapLevel3
        4 -> AppColors.HeatmapLevel4
        else -> AppColors.HeatmapEmpty
    }
}

/**
 * Footer
 */
@Composable
fun Footer() {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(8.dp),
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 12.dp)
    ) {
        Row(
            horizontalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            FooterLink(title = "Privacy")
            FooterLink(title = "Terms")
            FooterLink(title = "Data Export")
        }
        Text(
            "© 2024 RunningOS v2.0. All systems nominal.",
            color = AppColors.TextTertiary,
            fontSize = 12.sp
        )
    }
}

@Composable
fun FooterLink(title: String) {
    Text(
        title,
        color = AppColors.TextTertiary,
        fontSize = 12.sp
    )
}

/**
 * Glass Card 组件
 */
@Composable
fun GlassCard(
    modifier: Modifier = Modifier,
    border: Color,
    padding: androidx.compose.ui.unit.Dp,
    content: @Composable () -> Unit
) {
    Box(
        modifier = modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .background(AppColors.CardBackground)
            .border(1.dp, border, RoundedCornerShape(12.dp))
            .padding(padding)
    ) {
        content()
    }
}
