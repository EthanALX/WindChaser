package com.windchaser.runningos.domain.repository

import com.windchaser.runningos.domain.model.RunningActivity
import com.windchaser.runningos.domain.model.Route
import com.windchaser.runningos.domain.model.UserStats
import kotlinx.coroutines.flow.Flow

/**
 * 跑步数据 Repository 接口
 */
interface RunningRepository {
    /**
     * 获取用户统计数据
     */
    fun getUserStats(): Flow<UserStats>

    /**
     * 获取所有跑步活动
     */
    fun getAllActivities(): Flow<List<RunningActivity>>

    /**
     * 获取最新活动
     */
    fun getLatestActivity(): Flow<RunningActivity?>

    /**
     * 获取所有路线
     */
    fun getAllRoutes(): Flow<List<Route>>

    /**
     * 根据ID获取路线
     */
    suspend fun getRouteById(routeId: String): Route?

    /**
     * 保存跑步活动
     */
    suspend fun saveActivity(activity: RunningActivity)

    /**
     * 同步数据
     */
    suspend fun syncData(): Result<Unit>
}
