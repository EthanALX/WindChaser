import SwiftUI
import MapboxMaps
import CoreLocation

struct ContentView: View {
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            CyberGridBackground()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    TopBar()
                    MapCard()
                    HeatmapCard()
                    StatsRow()
                    PersonalBestsCard()
                    MetricCard(title: "Total Distance", value: "2,450", unit: "km", accent: AppColors.primary, icon: "timeline", border: AppColors.primary.opacity(0.2))
                    MetricCard(title: "Avg Pace", value: "5:30", unit: "/km", accent: Color(hex: "60A5FA"), icon: "speedometer", border: Color.white.opacity(0.08))
                    MetricCard(title: "Active Days", value: "142", unit: "Days", accent: Color(hex: "FB923C"), icon: "calendar", border: Color.white.opacity(0.08))
                    Footer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
        }
    }
}

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

struct CircleIcon: View {
    let systemName: String

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.06))
            .frame(width: 30, height: 30)
            .overlay(
                Image(systemName: systemName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.white.opacity(0.8))
            )
    }
}

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

struct MapCard: View {
    @State private var searchText = ""

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Map container with glass effect
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColors.surfaceTransparent)
                .overlay(
                    ZStack {
                        MapboxMapView(coordinates: MapRouteData.tokyoLoop)
                        Color.black.opacity(0.6)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)

            VStack {
                HStack {
                    SearchBar(text: $searchText)
                    Spacer()
                    ZoomControls()
                }
                .padding(12)

                Spacer()

                LatestActivityBadge()
                    .padding(.leading, 12)
                    .padding(.bottom, 12)
            }
        }
        .frame(height: 500)
        .clipped()
    }
}

struct MapboxMapView: UIViewRepresentable {
    let coordinates: [CLLocationCoordinate2D]

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> MapView {
        let mapInitOptions = MapInitOptions(styleURI: .dark)
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)

        mapView.ornaments.options.logo.visibility = .hidden
        mapView.ornaments.options.attributionButton.visibility = .hidden
        mapView.ornaments.options.compass.visibility = .hidden
        mapView.ornaments.options.scaleBar.visibility = .hidden

        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            context.coordinator.configureRoute(on: mapView, coordinates: coordinates)
        }

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {}

    class Coordinator {
        private var didAddRoute = false

        func configureRoute(on mapView: MapView, coordinates: [CLLocationCoordinate2D]) {
            guard !didAddRoute else { return }
            didAddRoute = true

            let lineString = LineString(coordinates)
            var source = GeoJSONSource()
            source.data = .geometry(.lineString(lineString))
            try? mapView.mapboxMap.style.addSource(source, id: "route-source")

            var glowLayer = LineLayer(id: "route-glow")
            glowLayer.source = "route-source"
            glowLayer.lineColor = .constant(StyleColor(UIColor(hex: "9D4BF6", alpha: 0.6)))
            glowLayer.lineWidth = .constant(12)
            glowLayer.lineBlur = .constant(6)
            glowLayer.lineCap = .constant(.round)
            glowLayer.lineJoin = .constant(.round)

            var mainLayer = LineLayer(id: "route-line")
            mainLayer.source = "route-source"
            mainLayer.lineColor = .constant(StyleColor(UIColor(hex: "7F0DF2")))
            mainLayer.lineWidth = .constant(5)
            mainLayer.lineCap = .constant(.round)
            mainLayer.lineJoin = .constant(.round)

            try? mapView.mapboxMap.style.addLayer(glowLayer)
            try? mapView.mapboxMap.style.addLayer(mainLayer)

            let camera = mapView.mapboxMap.camera(for: coordinates, padding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40), bearing: 0, pitch: 0)
            mapView.mapboxMap.setCamera(to: camera)
        }
    }
}

enum MapRouteData {
    static let tokyoLoop: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 35.6930, longitude: 139.7020),
        CLLocationCoordinate2D(latitude: 35.7010, longitude: 139.7130),
        CLLocationCoordinate2D(latitude: 35.7070, longitude: 139.7280),
        CLLocationCoordinate2D(latitude: 35.6980, longitude: 139.7420),
        CLLocationCoordinate2D(latitude: 35.6860, longitude: 139.7440),
        CLLocationCoordinate2D(latitude: 35.6740, longitude: 139.7340),
        CLLocationCoordinate2D(latitude: 35.6670, longitude: 139.7180),
        CLLocationCoordinate2D(latitude: 35.6650, longitude: 139.7010),
        CLLocationCoordinate2D(latitude: 35.6710, longitude: 139.6860),
        CLLocationCoordinate2D(latitude: 35.6830, longitude: 139.6760),
        CLLocationCoordinate2D(latitude: 35.6960, longitude: 139.6810),
        CLLocationCoordinate2D(latitude: 35.7050, longitude: 139.6920),
        CLLocationCoordinate2D(latitude: 35.7060, longitude: 139.7030),
        CLLocationCoordinate2D(latitude: 35.7010, longitude: 139.7120),
        CLLocationCoordinate2D(latitude: 35.6930, longitude: 139.7020)
    ]
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.white.opacity(0.5))
                .font(.system(size: 16, weight: .medium))
            TextField("Search routes...", text: $text)
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

struct LatestActivityBadge: View {
    var body: some View {
        HStack(spacing: 12) {
            PulsingDot()
            VStack(alignment: .leading, spacing: 2) {
                Text("Latest Activity")
                    .font(AppFonts.label(10, weight: .bold))
                    .foregroundColor(AppColors.textSecondary)
                    .tracking(1.5)
                Text("Midnight Run - Shinjuku")
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

struct HeatmapCard: View {
    private let rows = 7
    private let columns = 18
    private let data: [Int] = [
        2,0,4,3,0,0,3,
        0,0,4,2,0,1,0,
        4,3,0,2,0,0,4,
        0,1,0,4,0,0,0,
        2,0,0,4,0,0,0,
        0,4,0,0,1,0,0,
        2,0,3,0,0,4,0,
        0,0,0,0,2,0,0,
        4,0,0,0,0,3,0,
        0,4,0,0,0,0,0,
        0,0,1,0,4,0,0,
        1,0,0,2,0,0,0,
        0,4,0,0,1,0,0,
        2,0,3,0,0,4,0,
        0,0,0,0,2,0,0,
        4,0,0,0,0,3,0,
        0,4,0,0,0,0,0,
        0,0,1,0,4,0,0
    ]

    var body: some View {
        GlassCard(padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16), border: Color.white.opacity(0.1)) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "square.grid.3x3.fill")
                            .foregroundColor(AppColors.primary)
                            .font(.system(size: 16, weight: .medium))
                        Text("Activity Heatmap")
                            .font(AppFonts.label(15, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    HeatmapLegend()
                }

                // Heatmap grid
                LazyHGrid(rows: Array(repeating: GridItem(.fixed(12), spacing: 4), count: rows), spacing: 4) {
                    ForEach(0..<min(data.count, rows * columns), id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(heatmapColor(level: data[index]))
                            .frame(width: 12, height: 12)
                    }
                }
                .frame(height: 92)
            }
        }
    }

    private func heatmapColor(level: Int) -> Color {
        switch level {
        case 1:
            return AppColors.heatmapLevel1
        case 2:
            return AppColors.heatmapLevel2
        case 3:
            return AppColors.heatmapLevel3
        case 4:
            return AppColors.heatmapLevel4
        default:
            return AppColors.heatmapEmpty
        }
    }
}

struct HeatmapLegend: View {
    var body: some View {
        HStack(spacing: 6) {
            Text("Less")
                .font(AppFonts.label(11, weight: .medium))
                .foregroundColor(AppColors.textTertiary)
            HStack(spacing: 4) {
                HeatLegendBlock(color: AppColors.heatmapEmpty)
                HeatLegendBlock(color: AppColors.heatmapLevel1)
                HeatLegendBlock(color: AppColors.heatmapLevel3)
                HeatLegendBlock(color: AppColors.heatmapLevel4)
            }
            Text("More")
                .font(AppFonts.label(11, weight: .medium))
                .foregroundColor(AppColors.textTertiary)
        }
    }
}

struct HeatLegendBlock: View {
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 2, style: .continuous)
            .fill(color)
            .frame(width: 12, height: 12)
            .overlay(
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
    }
}

struct StatsRow: View {
    var body: some View {
        HStack(spacing: 12) {
            StatBox(value: "42", label: "Marathons")
            StatBox(value: "156", label: "Runs")
            StatBox(value: "8.9k", label: "Life KM")
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

struct PersonalBestsCard: View {
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
                    BestCell(title: "5K", value: "19:42")
                    BestCell(title: "10K", value: "41:15")
                    BestCell(title: "Half", value: "1:32:04")
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

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String
    let accent: Color
    let icon: String
    let border: Color

    var body: some View {
        ZStack {
            // Background glow effect
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(accent.opacity(0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .blur(radius: 40)
                .offset(x: 40, y: -40)

            GlassCard(padding: EdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18), border: border) {
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
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(accent.opacity(0.7))
                }
            }
        }
    }
}

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

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

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

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
