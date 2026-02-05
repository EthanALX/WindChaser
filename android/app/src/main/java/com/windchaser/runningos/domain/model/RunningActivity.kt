package com.windchaser.runningos.domain.model

/**
 * 跑步活动领域模型
 */
data class RunningActivity(
    val id: String,
    val name: String,
    val distance: Double,        // 公里
    val duration: Long,          // 秒
    val pace: Double,            // 分钟/公里
    val calories: Int,
    val timestamp: Long,
    val route: Route? = null
)

/**
 * 路线模型
 */
data class Route(
    val id: String,
    val name: String,
    val coordinates: List<Coordinate>,
    val distance: Double,
    val type: RouteType
)

/**
 * 坐标点
 */
data class Coordinate(
    val latitude: Double,
    val longitude: Double,
    val elevation: Double = 0.0
)

/**
 * 路线类型
 */
enum class RouteType {
    LOOP, OUT_AND_BACK, POINT_TO_POINT
}

/**
 * 用户统计数据
 */
data class UserStats(
    val totalDistance: Double,     // 总距离 (公里)
    val totalRuns: Int,            // 总跑步次数
    val totalMarathons: Int,       // 完成马拉松数量
    val avgPace: Double,           // 平均配速 (分钟/公里)
    val activeDays: Int,           // 活跃天数
    val personalBests: PersonalBests
)

/**
 * 个人最佳成绩
 */
data class PersonalBests(
    val fiveK: String?,           // 5K 最佳成绩
    val tenK: String?,            // 10K 最佳成绩
    val halfMarathon: String?,    // 半马最佳成绩
    val marathon: String?         // 全马最佳成绩
)
