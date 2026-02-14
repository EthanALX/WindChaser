import SwiftUI

struct ActivityDetailView: View {
    let activity: RunningActivity

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Header
                HStack {
                    Image(systemName: "figure.run")
                        .font(.largeTitle)
                        .foregroundColor(AppColor.primary)

                    VStack(alignment: .leading) {
                        Text(activity.activityType.displayName)
                            .font(AppTypography.sectionTitle)
                        Text(activity.startDate, style: .date)
                            .font(AppTypography.bodyText)
                            .foregroundColor(AppColor.textSecondary)
                    }

                    Spacer()
                }
                .padding()

                // Stats grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.lg) {
                    StatCard(value: String(format: "%.2f km", activity.distance / 1000), label: "距离")
                    StatCard(value: formatDuration(activity.movingTime), label: "时长")
                    StatCard(value: "\(activity.activeCalories)", label: "卡路里")
                    StatCard(value: String(format: "%.1f m", activity.totalElevationGain), label: "爬升")
                }
                .padding(.horizontal)
            }
        }
        .background(AppColor.background)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActivityDetailView(activity: RunningActivity(
                id: "1",
                activityType: .run,
                distance: 15000,
                movingTime: 3600,
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600),
                coordinates: [],
                splits: [],
                stepCount: 6000,
                activeCalories: 500,
                totalElevationGain: 50
            ))
        }
    }
}
