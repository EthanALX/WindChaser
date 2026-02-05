package com.windchaser.runningos.ui.components.map

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.viewinterop.AndroidView
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.MapView
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Polyline
import com.amap.api.maps.model.PolylineOptions
import com.windchaser.runningos.domain.model.Route

/**
 * 高德地图 Compose 组件
 */
@Composable
fun AMapView(
    route: Route?,
    modifier: Modifier = Modifier
) {
    var mapView: MapView? by remember { mutableStateOf(null) }
    var aMap: AMap? by remember { mutableStateOf(null) }
    var routePolyline: Polyline? by remember { mutableStateOf(null) }

    AndroidView(
        factory = { context ->
            MapView(context).apply {
                mapView = this
                aMap = this.map
                onCreate(null)
            }
        },
        update = { view ->
            // 绘制路线
            route?.let { route ->
                drawRoute(view.map, route)
            }
        },
        modifier = modifier.fillMaxSize()
    )

    // 生命周期管理
    LaunchedEffect(route) {
        route?.let {
            drawRoute(aMap, it)
        }
    }
}

/**
 * 绘制跑步路线
 */
private fun drawRoute(aMap: AMap?, route: Route) {
    if (aMap == null) return

    // 清除旧路线
    aMap.clear()

    // 转换坐标点
    val latLngs = route.coordinates.map { coord ->
        LatLng(coord.latitude, coord.longitude)
    }

    if (latLngs.isNotEmpty()) {
        // 绘制发光效果路线
        val glowOptions = PolylineOptions()
            .addAll(latLngs)
            .width(24f)
            .color(0x999D4BF6.toInt()) // 半透明紫色
            .zIndex(1f)

        // 绘制主路线
        val mainOptions = PolylineOptions()
            .addAll(latLngs)
            .width(8f)
            .color(0xFF7F0DF2.toInt()) // 主紫色
            .zIndex(2f)

        aMap.addPolyline(glowOptions)
        aMap.addPolyline(mainOptions)

        // 移动相机到路线
        val firstLatLng = latLngs.first()
        aMap.animateCamera(
            CameraUpdateFactory.newLatLngZoom(firstLatLng, 13f)
        )
    }
}

/**
 * 获取默认的东京环线路线（示例数据）
 */
fun getTokyoLoopRoute(): Route {
    return Route(
        id = "tokyo_loop",
        name = "Tokyo Loop",
        coordinates = listOf(
            com.windchaser.runningos.domain.model.Coordinate(35.6930, 139.7020),
            com.windchaser.runningos.domain.model.Coordinate(35.7010, 139.7130),
            com.windchaser.runningos.domain.model.Coordinate(35.7070, 139.7280),
            com.windchaser.runningos.domain.model.Coordinate(35.6980, 139.7420),
            com.windchaser.runningos.domain.model.Coordinate(35.6860, 139.7440),
            com.windchaser.runningos.domain.model.Coordinate(35.6740, 139.7340),
            com.windchaser.runningos.domain.model.Coordinate(35.6670, 139.7180),
            com.windchaser.runningos.domain.model.Coordinate(35.6650, 139.7010),
            com.windchaser.runningos.domain.model.Coordinate(35.6710, 139.6860),
            com.windchaser.runningos.domain.model.Coordinate(35.6830, 139.6760),
            com.windchaser.runningos.domain.model.Coordinate(35.6960, 139.6810),
            com.windchaser.runningos.domain.model.Coordinate(35.7050, 139.6920),
            com.windchaser.runningos.domain.model.Coordinate(35.7060, 139.7030),
            com.windchaser.runningos.domain.model.Coordinate(35.7010, 139.7120),
            com.windchaser.runningos.domain.model.Coordinate(35.6930, 139.7020)
        ),
        distance = 15.2,
        type = com.windchaser.runningos.domain.model.RouteType.LOOP
    )
}
