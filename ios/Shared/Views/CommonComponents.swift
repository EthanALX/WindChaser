import SwiftUI
import AMapFoundationKit
import MAMapKit

// MARK: - Top Bar

struct TopBar: View {
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                // Logo icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "terminal")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.primary)
                    )

                // Logo text
                HStack(spacing: 2) {
                    Text("Running")
                        .font(AppFonts.display(20, weight: .bold))
                        .tracking(2)
                        .foregroundColor(.white)
                    Text("OS")
                        .font(AppFonts.display(20, weight: .bold))
                        .tracking(2)
                        .foregroundColor(AppColors.primary)
                    Text("v2.0")
                        .font(AppFonts.display(12, weight: .regular))
                        .foregroundColor(AppColors.textTertiary)
                        .padding(.leading, 2)
                }
            }

            Spacer()

            HStack(spacing: 12) {
                // Settings button
                Button(action: {}) {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "gearshape")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                        )
                }

                // Notifications button with badge
                ZStack(alignment: .topTrailing) {
                    Button(action: {}) {
                        Circle()
                            .fill(Color.white.opacity(0.05))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "bell")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.7))
                            )
                    }

                    // Notification badge
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 8, height: 8)
                        .offset(x: 4, y: -4)
                        .shadow(color: AppColors.primary, radius: 4)
                }

                // Avatar
                AvatarView()
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Avatar View

struct AvatarView: View {
    private let avatarUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuBPQvYKlZ68vwXRnPjsPPKdpvjNiWIcNEB5MQuCjNCWKXCQrRm-6GF2r89aG_aL8fFiJIN9dqg1DkRJjulKPSnO0I5HSSvp_HQEv2vH7FfSO5Y9vTVJBDPp3awRLgDZY6jrAq-HZ2gYozzRAUB7z_D5Nw0nWwJcai1Q1R3-bSXRLBhcY7mJOxitHaR5Dg9xU0RdyFxa0yMdJe5V0-0dCGr013ycR-cWyRRuGbNjdKI96cGAj6RdKQrZGradXKDgZ5Kxn4VvexMPhKtn"

    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [AppColors.primary, Color(hex: "3B82F6")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 36, height: 36)
            .overlay(
                Circle()
                    .stroke(AppColors.background, lineWidth: 2)
                    .padding(1)
                    .background(
                        Circle()
                            .fill(AppColors.background)
                            .padding(3)
                    )
                    .overlay(
                        AsyncImage(url: URL(string: avatarUrl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure(_):
                                Color.white.opacity(0.08)
                            case .empty:
                                Color.white.opacity(0.08)
                            @unknown default:
                                Color.white.opacity(0.08)
                            }
                        }
                        .clipShape(Circle())
                        .padding(4)
                    )
            )
    }
}

// MARK: - Map Card

struct MapCard: View {
    let route: Route?
    let latestActivityName: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Map 必须直接显示，不能有任何覆盖层
            AMapViewRepresentable(route: route)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)

            VStack {
                HStack {
                    SearchBar()
                    Spacer()
                    ZoomControls()
                }
                .padding(12)

                Spacer()

                LatestActivityBadge(name: latestActivityName)
                    .padding(.leading, 12)
                    .padding(.bottom, 12)
            }
        }
        .frame(height: 500)
        .clipped()
    }
}

// MARK: - AMap View Representable

class AMapViewDelegate: NSObject, MAMapViewDelegate {
    // 代理方法用于自定义路线样式
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            let polylineRenderer = MAPolylineRenderer(overlay: overlay)
            polylineRenderer?.lineWidth = 3.0
            polylineRenderer?.strokeColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
            return polylineRenderer
        }
        return nil
    }
}

struct AMapViewRepresentable: UIViewRepresentable {
    let route: Route?

    func makeUIView(context: Context) -> MAMapView {
        // 使用足够大的帧初始化地图视图（必须在 SwiftUI 容器大小确定后再调整）
        let mapView = MAMapView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        
        // 设置代理以处理路线绘制
        mapView.delegate = context.coordinator
        
        // 基本配置
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none
        mapView.zoomLevel = 13.0
        mapView.mapType = .standard
        
        // 关键：设置初始中心坐标（北京）- 这会触发地图初始化
        let initialCoordinate = CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)
        mapView.setCenter(initialCoordinate, animated: false)
        
        // 手势配置
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = false
        
        // 清空任何之前的覆盖层
        mapView.removeOverlays(mapView.overlays)

        return mapView
    }

    func updateUIView(_ uiView: MAMapView, context: Context) {
        // 关键检查：确保地图已加载到窗口并完全初始化
        guard uiView.window != nil else {
            return
        }
        
   
        guard let route = route else { 
            return 
        }

        // 绘制路线
        let coordinates = route.coordinates.map { coord in
            CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
        }

        if coordinates.count > 1 {
            // 清除之前的覆盖层
            let overlays = uiView.overlays ?? []
            if !overlays.isEmpty {
                uiView.removeOverlays(overlays)
            }
            
            // 绘制主路线
            var coords = coordinates
            if let polyline = MAPolyline(coordinates: &coords, count: UInt(coordinates.count)) {
                polyline.title = "mainRoute"
                uiView.add(polyline)
            }

            // 异步更新中心坐标（给 SDK 足够的时间初始化）
            if let firstCoord = coordinates.first {
                let center = CLLocationCoordinate2D(latitude: firstCoord.latitude, longitude: firstCoord.longitude)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // 再次检查地图是否有效
                    if uiView.window != nil {
                        uiView.setCenter(center, animated: true)
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> AMapViewDelegate {
        AMapViewDelegate()
    }
}

// MARK: - Search Bar

struct SearchBar: View {
    @State private var searchText = ""

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.white.opacity(0.5))
                .font(.system(size: 16, weight: .medium))
            TextField("Search routes...", text: $searchText)
                .font(AppFonts.label(14))
                .foregroundColor(.white)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(AppColors.surfaceTransparent)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Zoom Controls

struct ZoomControls: View {
    var body: some View {
        VStack(spacing: 0) {
            ZoomButton(systemName: "plus")
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
            ZoomButton(systemName: "minus")
        }
        .background(AppColors.surfaceTransparent)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct ZoomButton: View {
    let systemName: String

    var body: some View {
        Button(action: {}) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
    }
}

// MARK: - Latest Activity Badge

struct LatestActivityBadge: View {
    let name: String

    var body: some View {
        HStack(spacing: 12) {
            PulsingDot()
            VStack(alignment: .leading, spacing: 2) {
                Text("Latest Activity")
                    .font(AppFonts.label(10, weight: .bold))
                    .foregroundColor(AppColors.textSecondary)
                    .tracking(1.5)
                Text(name)
                    .font(AppFonts.label(13, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(AppColors.surfaceTransparent)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: AppColors.primary.opacity(0.3), radius: 6)
    }
}

// MARK: - Pulsing Dot

struct PulsingDot: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            Circle()
                .fill(AppColors.primary.opacity(0.75))
                .frame(width: 12, height: 12)
                .scaleEffect(pulse ? 1.5 : 1)
                .opacity(pulse ? 0 : 1)
            Circle()
                .fill(AppColors.primary)
                .frame(width: 6, height: 6)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                pulse = true
            }
        }
    }
}

// MARK: - Heatmap Card

struct HeatmapCard: View {
    var body: some View {
        GlassCard(padding: EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14), border: Color.white.opacity(0.1)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundColor(AppColors.primary)
                        .font(.system(size: 14, weight: .medium))
                    Text("Activity Heatmap")
                        .font(AppFonts.label(12, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(1.5)
                }

                // 模拟热力图网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 12), spacing: 4) {
                    ForEach(0..<84, id: \.self) { index in
                        let level = Int.random(in: 0...4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(heatmapColor(for: level))
                            .frame(height: 12)
                    }
                }
            }
        }
    }

    private func heatmapColor(for level: Int) -> Color {
        switch level {
        case 0: return AppColors.heatmapEmpty
        case 1: return AppColors.heatmapLevel1
        case 2: return AppColors.heatmapLevel2
        case 3: return AppColors.heatmapLevel3
        default: return AppColors.heatmapLevel4
        }
    }
}

// MARK: - Stats Row

struct StatsRow: View {
    let stats: UserStats

    var body: some View {
        HStack(spacing: 12) {
            StatBox(value: "\(stats.totalMarathons)", label: "Marathons")
            StatBox(value: "\(stats.totalRuns)", label: "Runs")
            StatBox(value: String(format: "%.1fk", stats.totalDistance / 1000), label: "Life KM")
        }
    }
}

struct StatBox: View {
    let value: String
    let label: String

    var body: some View {
        GlassCard(padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12), border: Color.white.opacity(0.05)) {
            VStack(spacing: 4) {
                Text(value)
                    .font(AppFonts.display(20, weight: .bold))
                    .foregroundColor(.white)
                Text(label.uppercased())
                    .font(AppFonts.label(9, weight: .medium))
                    .foregroundColor(AppColors.textTertiary)
                    .tracking(1.2)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Personal Bests Card

struct PersonalBestsCard: View {
    let stats: UserStats

    var body: some View {
        GlassCard(padding: EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14), border: Color.white.opacity(0.1)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(AppColors.primary)
                        .font(.system(size: 14, weight: .medium))
                    Text("Personal Bests")
                        .font(AppFonts.label(12, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(1.5)
                }
                HStack(spacing: 12) {
                    BestCell(title: "5K", value: stats.personalBests.fiveK ?? "--:--")
                    BestCell(title: "10K", value: stats.personalBests.tenK ?? "--:--")
                    BestCell(title: "Half", value: stats.personalBests.halfMarathon ?? "--:--")
                }
            }
        }
    }
}

struct BestCell: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(AppFonts.label(11, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
            Text(value)
                .font(AppFonts.display(16, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

// MARK: - Metric Card

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String
    let accent: Color

    var body: some View {
        ZStack {
            // Background glow effect
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(accent.opacity(0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .blur(radius: 40)
                .offset(x: 40, y: -40)

            GlassCard(padding: EdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18), border: accent.opacity(0.2)) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title.uppercased())
                            .font(AppFonts.label(11, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                            .tracking(1.5)
                        HStack(alignment: .lastTextBaseline, spacing: 6) {
                            Text(value)
                                .font(AppFonts.display(34, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: accent.opacity(0.5), radius: 10)
                            Text(unit)
                                .font(AppFonts.label(12, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Footer

struct Footer: View {
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 16) {
                FooterLink(title: "Privacy")
                FooterLink(title: "Terms")
                FooterLink(title: "Data Export")
            }
            Text("(c) 2024 RunningOS v2.0. All systems nominal.")
                .font(AppFonts.label(9))
                .foregroundColor(AppColors.textTertiary)
        }
        .padding(.top, 10)
    }
}

struct FooterLink: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppFonts.label(9, weight: .medium))
            .foregroundColor(AppColors.textTertiary)
    }
}

// MARK: - Glass Card

struct GlassCard<Content: View>: View {
    let padding: EdgeInsets
    let border: Color
    let content: Content

    init(padding: EdgeInsets, border: Color, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.border = border
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(
                ZStack {
                    // Blur effect
                    BlurView(style: .systemUltraThinMaterialDark)
                    // Semi-transparent background
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(AppColors.surfaceTransparent)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(border, lineWidth: 1)
            )
    }
}

// MARK: - Blur View

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - Cyber Grid Background

struct CyberGridBackground: View {
    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let step: CGFloat = 40
                var path = Path()
                var x: CGFloat = 0
                while x <= size.width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                    x += step
                }
                var y: CGFloat = 0
                while y <= size.height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                    y += step
                }
                context.stroke(path, with: .color(AppColors.gridLine), lineWidth: 1)
            }
            .ignoresSafeArea()
        }
    }
}
