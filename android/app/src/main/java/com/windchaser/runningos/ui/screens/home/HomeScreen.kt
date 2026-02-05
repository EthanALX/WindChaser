package com.windchaser.runningos.ui.screens.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.lifecycle.currentState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.windchaser.runningos.ui.components.common.CyberGridBackground
import com.windchaser.runningos.ui.components.common.Footer
import com.windchaser.runningos.ui.components.common.GlassCard
import com.windchaser.runningos.ui.components.common.HeatmapCard
import com.windchaser.runningos.ui.components.common.MapCard
import com.windchaser.runningos.ui.components.common.MetricCard
import com.windchaser.runningos.ui.components.common.PersonalBestsCard
import com.windchaser.runningos.ui.components.common.StatsRow
import com.windchaser.runningos.ui.components.common.TopBar
import com.windchaser.runningos.ui.theme.AppColors

/**
 * 首页
 */
@Composable
fun HomeScreen(
    viewModel: HomeViewModel,
    modifier: Modifier = Modifier
) {
    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    Box(modifier = modifier.fillMaxSize()) {
        CyberGridBackground()

        when (val state = uiState) {
            is HomeUiState.Loading -> {
                // TODO: 添加加载动画
            }
            is HomeUiState.Success -> {
                HomeContent(
                    stats = state.stats,
                    latestActivityName = state.latestActivityName,
                    selectedRoute = state.selectedRoute,
                    onRefresh = { viewModel.refresh() }
                )
            }
            is HomeUiState.Error -> {
                // TODO: 添加错误提示
            }
        }
    }
}

/**
 * 首页内容
 */
@Composable
private fun HomeContent(
    stats: com.windchaser.runningos.domain.model.UserStats,
    latestActivityName: String,
    selectedRoute: com.windchaser.runningos.domain.model.Route?,
    onRefresh: () -> Unit
) {
    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = androidx.compose.foundation.layout.PaddingValues(
            start = 16.dp,
            end = 16.dp,
            top = 12.dp,
            bottom = 12.dp
        ),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            TopBar()
        }

        item {
            MapCard(
                route = selectedRoute,
                latestActivityName = latestActivityName
            )
        }

        item {
            HeatmapCard()
        }

        item {
            StatsRow(
                marathons = stats.totalMarathons,
                runs = stats.totalRuns,
                lifeKm = stats.totalDistance
            )
        }

        item {
            PersonalBestsCard(
                fiveK = stats.personalBests.fiveK ?: "--:--",
                tenK = stats.personalBests.tenK ?: "--:--",
                half = stats.personalBests.halfMarathon ?: "--:--"
            )
        }

        item {
            MetricCard(
                title = "Total Distance",
                value = String.format("%,.0f", stats.totalDistance),
                unit = "km",
                accent = AppColors.Primary
            )
        }

        item {
            MetricCard(
                title = "Avg Pace",
                value = String.format("%.1f", stats.avgPace),
                unit = "/km",
                accent = androidx.compose.ui.graphics.Color(0xFF60A5FA)
            )
        }

        item {
            MetricCard(
                title = "Active Days",
                value = stats.activeDays.toString(),
                unit = "Days",
                accent = androidx.compose.ui.graphics.Color(0xFFFB923C)
            )
        }

        item {
            Footer()
        }
    }
}
