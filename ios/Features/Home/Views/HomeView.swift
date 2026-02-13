import SwiftUI

/// 首页
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            CyberGridBackground()

            switch viewModel.uiState {
            case .loading:
                ProgressView()
            case .success(let stats, let latestActivityName):
                HomeContent(
                    stats: stats,
                    latestActivityName: latestActivityName,
                    selectedRoute: viewModel.selectedRoute,
                    onRefresh: { viewModel.refresh() }
                )
            case .error(let message):
                Text("Error: \(message)")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

// MARK: - Home Content

private struct HomeContent: View {
    let stats: UserStats
    let latestActivityName: String
    let selectedRoute: Route?
    let onRefresh: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                TopBar()
                MapCard(route: selectedRoute, latestActivityName: latestActivityName)
                HeatmapCard()
                StatsRow(stats: stats)
                PersonalBestsCard(stats: stats)
                MetricCard(title: "Total Distance", value: String(format: "%,.0f", stats.totalDistance), unit: "km", accent: AppColors.primary)
                MetricCard(title: "Avg Pace", value: String(format: "%.1f", stats.avgPace), unit: "/km", accent: Color(hex: "60A5FA"))
                MetricCard(title: "Active Days", value: "\(stats.activeDays)", unit: "Days", accent: Color(hex: "FB923C"))
                Footer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
