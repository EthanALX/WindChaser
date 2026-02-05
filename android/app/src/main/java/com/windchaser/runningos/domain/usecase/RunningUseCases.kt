package com.windchaser.runningos.domain.usecase

import com.windchaser.runningos.domain.model.UserStats
import com.windchaser.runningos.domain.repository.RunningRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

/**
 * 获取用户统计数据用例
 */
class GetUserStatsUseCase @Inject constructor(
    private val repository: RunningRepository
) {
    operator fun invoke(): Flow<UserStats> {
        return repository.getUserStats()
    }
}

/**
 * 获取最新活动用例
 */
class GetLatestActivityUseCase @Inject constructor(
    private val repository: RunningRepository
) {
    operator fun invoke() = repository.getLatestActivity()
}

/**
 * 获取所有路线用例
 */
class GetAllRoutesUseCase @Inject constructor(
    private val repository: RunningRepository
) {
    operator fun invoke() = repository.getAllRoutes()
}

/**
 * 同步数据用例
 */
class SyncDataUseCase @Inject constructor(
    private val repository: RunningRepository
) {
    suspend operator fun invoke(): Result<Unit> {
        return repository.syncData()
    }
}
