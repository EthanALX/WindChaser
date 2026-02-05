package com.windchaser.runningos.data.repository

import com.windchaser.runningos.data.local.ActivityDao
import com.windchaser.runningos.data.local.ActivityEntity
import com.windchaser.runningos.data.local.RouteEntity
import com.windchaser.runningos.data.local.RouteDao
import com.windchaser.runningos.domain.model.Coordinate
import com.windchaser.runningos.domain.model.PersonalBests
import com.windchaser.runningos.domain.model.Route
import com.windchaser.runningos.domain.model.RouteType
import com.windchaser.runningos.domain.model.RunningActivity
import com.windchaser.runningos.domain.model.UserStats
import com.windchaser.runningos.domain.repository.RunningRepository
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

/**
 * 跑步数据 Repository 实现
 */
class RunningRepositoryImpl @Inject constructor(
    private val activityDao: ActivityDao,
    private val routeDao: RouteDao,
    private val gson: Gson
) : RunningRepository {

    override fun getUserStats(): Flow<UserStats> {
        // TODO: 实现从数据库聚合统计数据
        // 这里使用模拟数据
        return kotlinx.coroutines.flow.flowOf(
            UserStats(
                totalDistance = 2450.0,
                totalRuns = 156,
                totalMarathons = 42,
                avgPace = 5.5,
                activeDays = 142,
                personalBests = PersonalBests(
                    fiveK = "19:42",
                    tenK = "41:15",
                    halfMarathon = "1:32:04",
                    marathon = "3:15:30"
                )
            )
        )
    }

    override fun getAllActivities(): Flow<List<RunningActivity>> {
        return activityDao.getAllActivities().map { entities ->
            entities.map { it.toDomainModel() }
        }
    }

    override fun getLatestActivity(): Flow<RunningActivity?> {
        return activityDao.getLatestActivity().map { entity ->
            entity?.toDomainModel()
        }
    }

    override fun getAllRoutes(): Flow<List<Route>> {
        return routeDao.getAllRoutes().map { entities ->
            entities.map { it.toDomainModel(gson) }
        }
    }

    override suspend fun getRouteById(routeId: String): Route? {
        return routeDao.getRouteById(routeId)?.toDomainModel(gson)
    }

    override suspend fun saveActivity(activity: RunningActivity) {
        activityDao.insertActivity(activity.toEntity())
    }

    override suspend fun syncData(): Result<Unit> {
        return try {
            // TODO: 实现网络同步逻辑
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}

// 扩展函数：Entity ↔ Domain Model 转换
private fun ActivityEntity.toDomainModel(): RunningActivity {
    return RunningActivity(
        id = id,
        name = name,
        distance = distance,
        duration = duration,
        pace = pace,
        calories = calories,
        timestamp = timestamp,
        route = null
    )
}

private fun RunningActivity.toEntity(): ActivityEntity {
    return ActivityEntity(
        id = id,
        name = name,
        distance = distance,
        duration = duration,
        pace = pace,
        calories = calories,
        timestamp = timestamp,
        routeId = route?.id
    )
}

private fun RouteEntity.toDomainModel(gson: Gson): Route {
    val coordinateType = object : TypeToken<List<Coordinate>>() {}.type
    val coordinates: List<Coordinate> = gson.fromJson(coordinatesJson, coordinateType)

    return Route(
        id = id,
        name = name,
        coordinates = coordinates,
        distance = distance,
        type = when (type) {
            "LOOP" -> RouteType.LOOP
            "OUT_AND_BACK" -> RouteType.OUT_AND_BACK
            "POINT_TO_POINT" -> RouteType.POINT_TO_POINT
            else -> RouteType.LOOP
        }
    )
}
