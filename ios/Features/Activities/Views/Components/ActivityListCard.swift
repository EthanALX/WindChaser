import SwiftUI

struct ActivityListCard: View {
    let activity: RunningActivity
    let onTap: () -> Void
    let onLongPress: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text(dateLabel)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColor.textSecondary)

                    Spacer()
                }

                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "figure.run")
                        .foregroundColor(AppColor.primary)

                    Text(activity.activityType.displayName)
                        .font(AppTypography.bodyText)
                        .foregroundColor(AppColor.textPrimary)

                    Spacer()

                    Text(distanceLabel)
                        .font(AppTypography.bodyText)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColor.textPrimary)
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColor.cardBackground)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0.5) {
            withAnimation(.easeInOut) {
                onLongPress()
            }
        }
    }

    private var dateLabel: String {
        let calendar = Calendar.current
        let now = Date()
        if calendar.isDateInToday(activity.startDate) {
            return "今天"
        } else if calendar.isDateInYesterday(activity.startDate) {
            return "昨天"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            formatter.locale = Locale(identifier: "zh_CN")
            return formatter.string(from: activity.startDate)
        }
    }

    private var distanceLabel: String {
        String(format: "%.2f km", activity.distance / 1000)
    }
}

struct ActivityListCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListCard(
            activity: RunningActivity(
                id: "preview",
                activityType: .run,
                distance: 15000,
                movingTime: 3600,
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600),
                coordinates: [],
                splits: [],
                stepCount: 2500,
                activeCalories: 500,
                totalElevationGain: 20
            ),
            onTap: {},
            onLongPress: {}
        )
        .padding()
    }
}
