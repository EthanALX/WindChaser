package com.windchaser.runningos.ui.screens.home

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.windchaser.runningos.domain.model.Route
import com.windchaser.runningos.domain.model.UserStats
import com.windchaser.runningos.domain.usecase.GetAllRoutesUseCase
import com.windchaser.runningos.domain.usecase.GetLatestActivityUseCase
import com.windchaser.runningos.domain.usecase.GetUserStatsUseCase
import com.windchaser.runningos.domain.usecase.SyncDataUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * 首页 ViewModel
 */
@HiltViewModel
class HomeViewModel @Inject constructor(
    private val getUserStats: GetUserStatsUseCase,
    private val getLatestActivity: GetLatestActivityUseCase,
    private val getAllRoutes: GetAllRoutesUseCase,
    private val syncData: SyncDataUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow<HomeUiState>(HomeUiState.Loading)
    val uiState: StateFlow<HomeUiState> = _uiState.asStateFlow()

    init {
        loadData()
    }

    private fun loadData() {
        viewModelScope.launch {
            try {
                // 收集用户统计数据
                getUserStats().collect { stats ->
                    _uiState.value = HomeUiState.Success(
                        stats = stats,
                        latestActivityName = "Midnight Run - Shinjuku",
                        selectedRoute = null
                    )
                }

                // 收集路线数据
                getAllRoutes().collect { routes ->
                    val currentState = _uiState.value
                    if (currentState is HomeUiState.Success) {
                        _uiState.value = currentState.copy(
                            routes = routes,
                            selectedRoute = routes.firstOrNull()
                        )
                    }
                }
            } catch (e: Exception) {
                _uiState.value = HomeUiState.Error(e.message ?: "Unknown error")
            }
        }
    }

    fun selectRoute(route: Route) {
        val currentState = _uiState.value
        if (currentState is HomeUiState.Success) {
            _uiState.value = currentState.copy(selectedRoute = route)
        }
    }

    fun refresh() {
        viewModelScope.launch {
            syncData().fold(
                onSuccess = { loadData() },
                onFailure = { error ->
                    _uiState.value = HomeUiState.Error(error.message ?: "Sync failed")
                }
            )
        }
    }
}

/**
 * 首页 UI 状态
 */
sealed class HomeUiState {
    object Loading : HomeUiState()
    data class Success(
        val stats: UserStats,
        val latestActivityName: String,
        val routes: List<Route> = emptyList(),
        val selectedRoute: Route? = null
    ) : HomeUiState()
    data class Error(val message: String) : HomeUiState()
}
