package com.windchaser.runningos

import android.os.Bundle
import android.view.View
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyHorizontalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.CalendarToday
import androidx.compose.material.icons.outlined.DirectionsRun
import androidx.compose.material.icons.outlined.ExpandLess
import androidx.compose.material.icons.outlined.ExpandMore
import androidx.compose.material.icons.outlined.Grade
import androidx.compose.material.icons.outlined.Notifications
import androidx.compose.material.icons.outlined.Search
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material.icons.outlined.ShowChart
import androidx.compose.material.icons.outlined.Speed
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.blur
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import coil.compose.AsyncImage
import com.mapbox.geojson.Point
import com.mapbox.maps.CameraOptions
import com.mapbox.maps.MapInitOptions
import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxOptions
import com.mapbox.maps.Style
import com.mapbox.maps.plugin.annotation.generated.PolylineAnnotationOptions

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MapboxOptions.accessToken = getString(R.string.mapbox_access_token)

        setContent {
            RunningOSTheme {
                Surface(color = AppColors.Background) {
                    RunningOSScreen()
                }
            }
        }
    }
}

@Composable
fun RunningOSScreen() {
    Box(modifier = Modifier.fillMaxSize()) {
        CyberGridBackground()
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
            item { TopBar() }
            item { MapSection() }
            item { HeatmapSection() }
            item { StatsRow() }
            item { PersonalBestsSection() }
            item { MetricCard(title = "Total Distance", value = "2,450", unit = "km", accent = AppColors.Primary, icon = Icons.Outlined.ShowChart, border = AppColors.Primary.copy(alpha = 0.25f)) }
            item { MetricCard(title = "Avg Pace", value = "5:30", unit = "/km", accent = Color(0xFF60A5FA), icon = Icons.Outlined.Speed, border = Color.White.copy(alpha = 0.08f)) }
            item { MetricCard(title = "Active Days", value = "142", unit = "Days", accent = Color(0xFFFB923C), icon = Icons.Outlined.CalendarToday, border = Color.White.copy(alpha = 0.08f)) }
            item { Footer() }
        }
    }
}

@Composable
fun TopBar() {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            // Logo icon
            Box(
                modifier = Modifier
                    .size(32.dp)
                    .clip(RoundedCornerShape(8.dp))
                    .background(AppColors.Primary.copy(alpha = 0.1f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Outlined.DirectionsRun,
                    contentDescription = null,
                    tint = AppColors.Primary,
                    modifier = Modifier.size(20.dp)
                )
            }

            // App name
            Column(modifier = Modifier.padding(bottom = 2.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        "RUNNING",
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 2.sp
                    )
                    Text(
                        "OS",
                        color = AppColors.Primary,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        letterSpacing = 2.sp
                    )
                }
                Text(
                    "v2.0",
                    color = AppColors.TextTertiary,
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Normal
                )
            }
        }

        // Right icons
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButtonCircle(icon = Icons.Outlined.Settings)
            Box {
                IconButtonCircle(icon = Icons.Outlined.Notifications)
                Box(
                    modifier = Modifier
                        .size(8.dp)
                        .align(Alignment.TopEnd)
                        .clip(CircleShape)
                        .background(AppColors.Primary)
                        .drawBehind {
                            drawRoundRect(
                                color = AppColors.Primary.copy(alpha = 0.4f),
                                style = Stroke(width = 4.dp.toPx())
                            )
                        }
                )
            }
            Avatar()
        }
    }
}

@Composable
fun IconButtonCircle(icon: androidx.compose.ui.graphics.vector.ImageVector) {
    Box(
        modifier = Modifier
            .size(36.dp)
            .clip(CircleShape)
            .background(Color.White.copy(alpha = 0.05f)),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color.White.copy(alpha = 0.7f),
            modifier = Modifier.size(20.dp)
        )
    }
}

@Composable
fun Avatar() {
    val avatarUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuBPQvYKlZ68vwXRnPjsPPKdpvjNiWIcNEB5MQuCjNCWKXCQrRm-6GF2r89aG_aL8fFiJIN9dqg1DkRJjulKPSnO0I5HSSvp_HQEv2vH7FfSO5Y9vTVJBDPp3awRLgDZY6jrAq-HZ2gYozzRAUB7z_D5Nw0nWwJcai1Q1R3-bSXRLBhcY7mJOxitHaR5Dg9xU0RdyFxa0yMdJe5V0-0dCGr013ycR-cWyRRuGbNjdKI96cGAj6RdKQrZGradXKDgZ5Kxn4VvexMPhKtn"
    Box(
        modifier = Modifier
            .size(36.dp)
            .clip(CircleShape)
            .background(
                Brush.linearGradient(
                    colors = listOf(AppColors.Primary, Color(0xFF3B82F6))
                )
            ),
        contentAlignment = Alignment.Center
    ) {
        Box(
            modifier = Modifier
                .size(32.dp)
                .clip(CircleShape)
                .background(AppColors.Background)
        ) {
            AsyncImage(
                model = avatarUrl,
                contentDescription = null,
                modifier = Modifier.fillMaxSize()
            )
        }
    }
}

@Composable
fun MapSection() {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(400.dp)
            .clip(RoundedCornerShape(12.dp))
            .background(Color.Transparent)
            .border(1.dp, Color.White.copy(alpha = 0.1f), RoundedCornerShape(12.dp))
            .shadow(
                elevation = 30.dp,
                spotColor = Color.Black.copy(alpha = 0.3f),
                ambientColor = Color.Black.copy(alpha = 0.3f)
            )
    ) {
        // Map view
        MapboxMapView(
            modifier = Modifier.fillMaxSize(),
            coordinates = MapRouteData.tokyoLoop
        )

        // Dark overlay with multiply blend mode
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(AppColors.Background.copy(alpha = 0.6f))
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
        ) {
            Row(
                verticalAlignment = Alignment.Top,
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                SearchBar()
                ZoomControls()
            }
            Spacer(modifier = Modifier.weight(1f))
            LatestActivityBadge()
        }
    }
}

@Composable
fun MapboxMapView(modifier: Modifier = Modifier, coordinates: List<Point>) {
    val context = LocalContext.current
    val lifecycleOwner = LocalLifecycleOwner.current
    val mapView = remember {
        MapView(context, MapInitOptions(context, styleUri = Style.DARK))
    }
    var routeAdded by remember { mutableStateOf(false) }

    DisposableEffect(lifecycleOwner, mapView) {
        val observer = LifecycleEventObserver { _, event ->
            when (event) {
                Lifecycle.Event.ON_START -> mapView.onStart()
                Lifecycle.Event.ON_STOP -> mapView.onStop()
                Lifecycle.Event.ON_DESTROY -> mapView.onDestroy()
                else -> Unit
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose {
            lifecycleOwner.lifecycle.removeObserver(observer)
        }
    }

    AndroidView(
        factory = { mapView },
        modifier = modifier
    ) { view ->
        view.ornaments.logo.visibility = View.GONE
        view.ornaments.attributionButton.visibility = View.GONE
        view.ornaments.compass.visibility = View.GONE
        view.ornaments.scaleBar.visibility = View.GONE

        view.mapboxMap.loadStyleUri(Style.DARK) {
            if (!routeAdded) {
                routeAdded = true
                addRoute(view, coordinates)
                view.mapboxMap.setCamera(
                    CameraOptions.Builder()
                        .center(Point.fromLngLat(139.705, 35.6895))
                        .zoom(12.8)
                        .build()
                )
            }
        }
    }
}

private fun addRoute(mapView: MapView, coordinates: List<Point>) {
    val annotationApi = mapView.annotations
    val glowManager = annotationApi.createPolylineAnnotationManager()
    val mainManager = annotationApi.createPolylineAnnotationManager()

    glowManager.create(
        PolylineAnnotationOptions()
            .withPoints(coordinates)
            .withLineColor("#9D4BF6")
            .withLineWidth(12.0)
            .withLineOpacity(0.6)
    )

    mainManager.create(
        PolylineAnnotationOptions()
            .withPoints(coordinates)
            .withLineColor("#7F0DF2")
            .withLineWidth(5.0)
    )
}

object MapRouteData {
    val tokyoLoop = listOf(
        Point.fromLngLat(139.7020, 35.6930),
        Point.fromLngLat(139.7130, 35.7010),
        Point.fromLngLat(139.7280, 35.7070),
        Point.fromLngLat(139.7420, 35.6980),
        Point.fromLngLat(139.7440, 35.6860),
        Point.fromLngLat(139.7340, 35.6740),
        Point.fromLngLat(139.7180, 35.6670),
        Point.fromLngLat(139.7010, 35.6650),
        Point.fromLngLat(139.6860, 35.6710),
        Point.fromLngLat(139.6760, 35.6830),
        Point.fromLngLat(139.6810, 35.6960),
        Point.fromLngLat(139.6920, 35.7050),
        Point.fromLngLat(139.7030, 35.7060),
        Point.fromLngLat(139.7120, 35.7010),
        Point.fromLngLat(139.7020, 35.6930)
    )
}

@Composable
fun SearchBar() {
    var value by remember { mutableStateOf("") }
    Row(
        modifier = Modifier
            .clip(RoundedCornerShape(8.dp))
            .background(AppColors.SurfaceTransparent)
            .border(1.dp, Color.White.copy(alpha = 0.1f), RoundedCornerShape(8.dp))
            .shadow(
                elevation = 8.dp,
                spotColor = Color.Black.copy(alpha = 0.2f),
                ambientColor = Color.Black.copy(alpha = 0.2f)
            )
            .padding(horizontal = 12.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = Icons.Outlined.Search,
            contentDescription = null,
            tint = AppColors.TextSecondary,
            modifier = Modifier.size(18.dp)
        )
        Spacer(modifier = Modifier.width(8.dp))
        BasicTextField(
            value = value,
            onValueChange = { value = it },
            singleLine = true,
            textStyle = TextStyle(
                color = Color.White,
                fontSize = 14.sp
            ),
            modifier = Modifier.width(160.dp)
        ) { innerTextField ->
            if (value.isEmpty()) {
                Text(
                    "Search routes...",
                    color = AppColors.TextTertiary,
                    fontSize = 14.sp
                )
            }
            innerTextField()
        }
    }
}

@Composable
fun ZoomControls() {
    Column(
        modifier = Modifier
            .clip(RoundedCornerShape(8.dp))
            .background(AppColors.SurfaceTransparent)
            .border(1.dp, Color.White.copy(alpha = 0.1f), RoundedCornerShape(8.dp))
            .shadow(
                elevation = 8.dp,
                spotColor = Color.Black.copy(alpha = 0.2f),
                ambientColor = Color.Black.copy(alpha = 0.2f)
            )
    ) {
        ZoomButton(icon = Icons.Outlined.ExpandLess)
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(1.dp)
                .background(Color.White.copy(alpha = 0.08f))
        )
        ZoomButton(icon = Icons.Outlined.ExpandMore)
    }
}

@Composable
fun ZoomButton(icon: androidx.compose.ui.graphics.vector.ImageVector) {
    Box(
        modifier = Modifier
            .size(36.dp),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            tint = Color.White,
            modifier = Modifier.size(20.dp)
        )
    }
}

@Composable
fun LatestActivityBadge() {
    Row(
        modifier = Modifier
            .clip(RoundedCornerShape(8.dp))
            .background(AppColors.SurfaceTransparent)
            .border(1.dp, AppColors.Primary.copy(alpha = 0.3f), RoundedCornerShape(8.dp))
            .padding(horizontal = 16.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        PulsingDot()
        Column {
            Text(
                "LATEST ACTIVITY",
                color = AppColors.TextSecondary,
                fontSize = 11.sp,
                fontWeight = FontWeight.Bold,
                letterSpacing = 1.5.sp
            )
            Text(
                "Midnight Run - Shinjuku",
                color = Color.White,
                fontSize = 14.sp,
                fontWeight = FontWeight.Medium,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
        }
    }
}

@Composable
fun PulsingDot() {
    val transition = rememberInfiniteTransition(label = "pulse")
    val scale by transition.animateFloat(
        initialValue = 1f,
        targetValue = 1.6f,
        animationSpec = infiniteRepeatable(
            animation = tween(1200, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "scale"
    )
    val alpha by transition.animateFloat(
        initialValue = 1f,
        targetValue = 0f,
        animationSpec = infiniteRepeatable(
            animation = tween(1200, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "alpha"
    )

    Box(contentAlignment = Alignment.Center) {
        Box(
            modifier = Modifier
                .size(12.dp)
                .background(AppColors.Primary.copy(alpha = 0.75f), CircleShape)
                .graphicsLayer {
                    scaleX = scale
                    scaleY = scale
                    this.alpha = alpha
                }
        )
        Box(
            modifier = Modifier
                .size(8.dp)
                .clip(CircleShape)
                .background(AppColors.Primary)
        )
    }
}

@Composable
fun HeatmapSection() {
    val rows = 7
    val columns = 18
    val data = listOf(
        1,0,3,2,0,0,2,
        0,0,4,2,0,1,0,
        3,2,0,1,0,0,4,
        0,1,0,3,0,0,0,
        2,0,0,3,0,0,0,
        0,4,0,0,1,0,0,
        2,0,2,0,0,3,0,
        0,0,0,0,2,0,0,
        3,0,0,0,0,2,0,
        0,3,0,0,0,0,0,
        0,0,1,0,3,0,0,
        1,0,0,2,0,0,0,
        0,4,0,0,1,0,0,
        2,0,2,0,0,3,0,
        0,0,0,0,2,0,0,
        3,0,0,0,0,2,0,
        0,3,0,0,0,0,0,
        0,0,1,0,3,0,0
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
                            .then(
                                if (level == 4) {
                                    Modifier.drawBehind {
                                        drawRoundRect(
                                            color = AppColors.Primary.copy(alpha = 0.3f),
                                            style = Stroke(width = 2.dp.toPx())
                                        )
                                    }
                                } else {
                                    Modifier.border(
                                        0.5.dp,
                                        Color.White.copy(alpha = 0.05f),
                                        RoundedCornerShape(2.dp)
                                    )
                                }
                            )
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
            HeatLegendBlock(color = AppColors.HeatmapLevel2)
            HeatLegendBlock(color = AppColors.Primary)
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
            .then(
                if (color == AppColors.Primary) {
                    Modifier.drawBehind {
                        drawRoundRect(
                            color = AppColors.Primary.copy(alpha = 0.4f),
                            style = Stroke(width = 2.dp.toPx())
                        )
                    }
                } else {
                    Modifier.border(
                        0.5.dp,
                        Color.White.copy(alpha = 0.05f),
                        RoundedCornerShape(2.dp)
                    )
                }
            )
    )
}

@Composable
fun StatsRow() {
    Row(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        modifier = Modifier.fillMaxWidth()
    ) {
        StatBox(value = "42", label = "MARATHONS", modifier = Modifier.weight(1f))
        StatBox(value = "156", label = "RUNS", modifier = Modifier.weight(1f))
        StatBox(value = "8.9k", label = "LIFE KM", modifier = Modifier.weight(1f))
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

@Composable
fun PersonalBestsSection() {
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
                BestCell(title = "5K", value = "19:42", modifier = Modifier.weight(1f))
                BestCell(title = "10K", value = "41:15", modifier = Modifier.weight(1f))
                BestCell(title = "Half", value = "1:32:04", modifier = Modifier.weight(1f))
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

@Composable
fun MetricCard(
    title: String,
    value: String,
    unit: String,
    accent: Color,
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    border: Color
) {
    GlassCard(
        border = border,
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
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = accent.copy(alpha = 0.7f),
                    modifier = Modifier.size(24.dp)
                )
            }
            Spacer(modifier = Modifier.height(8.dp))
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

@Composable
fun GlassCard(
    modifier: Modifier = Modifier,
    border: Color,
    padding: Dp,
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

@Composable
fun CyberGridBackground() {
    Canvas(modifier = Modifier.fillMaxSize()) {
        val step = 40.dp.toPx()
        val strokeWidth = 1.dp.toPx()
        val width = size.width
        val height = size.height

        // Draw vertical lines
        var x = 0f
        while (x <= width) {
            drawLine(
                color = AppColors.GridLine,
                start = Offset(x, 0f),
                end = Offset(x, height),
                strokeWidth = strokeWidth
            )
            x += step
        }

        // Draw horizontal lines
        var y = 0f
        while (y <= height) {
            drawLine(
                color = AppColors.GridLine,
                start = Offset(0f, y),
                end = Offset(width, y),
                strokeWidth = strokeWidth
            )
            y += step
        }
    }
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
