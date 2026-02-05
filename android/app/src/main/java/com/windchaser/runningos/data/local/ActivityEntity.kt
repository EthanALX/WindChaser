package com.windchaser.runningos.data.local

import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * 跑步活动实体
 */
@Entity(tableName = "activities")
data class ActivityEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val distance: Double,
    val duration: Long,
    val pace: Double,
    val calories: Int,
    val timestamp: Long,
    val routeId: String? = null
)

/**
 * 路线实体
 */
@Entity(tableName = "routes")
data class RouteEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val coordinatesJson: String,  // JSON 格式存储坐标
    val distance: Double,
    val type: String  // 路线类型枚举值
)
