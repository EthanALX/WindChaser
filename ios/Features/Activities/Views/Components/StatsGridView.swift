import SwiftUI

struct StatsGridView: View {
    let statistics: ActivityStatistics

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
            // Row 1
            StatCard(value: formatDuration(statistics.totalDuration), label: "跑步时长")
            StatCard(value: formatDistance(statistics.totalDistance), label: "总距离(km)")
            StatCard(value: formatPace(statistics.avgPace), label: "平均配速")

            // Row 2
            StatCard(value: "\(statistics.activityCount)", label: "跑步次数")
            StatCard(value: "\(Int(statistics.totalElevation))", label: "总爬升(m)")
            StatCard(value: "\(Int(statistics.totalCalories))", label: "卡路里(kcal)")

            // Row 3
            StatCard(value: "\(statistics.avgCadence)", label: "平均步频")
            StatCard(value: "\(Int(statistics.avgStride))", label: "平均步长(cm)")
            StatCard(value: "", label: "") // Empty placeholder
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    private func formatDistance(_ distance: Double) -> String {
        String(format: "%.1f", distance / 1000)
    }

    private func formatPace(_ pace: Double) -> String {
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d'%02d\"", minutes, seconds)
    }
}

struct StatsGridView_Previews: PreviewProvider {
    static var previews: some View {
        StatsGridView(statistics: ActivityStatistics.empty)
    }
}
